// design_challenge_ui_base.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'components_profile.dart';

abstract class DesignChallengeUIState<T extends StatefulWidget>
    extends State<T> {
  List<UIComponent> components = [];
  Color canvasBackgroundColor = Colors.white;
  double canvasWidth = 400;
  double canvasHeight = 600;
  int? selectedIndex;
  bool isPlay = true;
  OverlayEntry? overlayEntry;
  bool showTrashBin = false;
  Color primaryColor = Colors.orange;

  GlobalKey lockKey = GlobalKey();
  GlobalKey backgroundColorKey = GlobalKey();
  GlobalKey addButtonKey = GlobalKey();
  GlobalKey checkButtonKey = GlobalKey();

  int score = 0;
  String feedbackText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        canvasWidth = MediaQuery.of(context).size.width;
        canvasHeight = MediaQuery.of(context).size.height * 0.85;
      });
    });
  }

  Widget buildCanvasBody({String? backgroundImage}) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: canvasWidth,
                    height: canvasHeight,
                    decoration: BoxDecoration(
                      image: backgroundImage != null
                          ? DecorationImage(
                              image: AssetImage(backgroundImage),
                              fit: BoxFit.cover,
                            )
                          : null,
                      color: canvasBackgroundColor,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: [
                        if (components.isEmpty)
                          _buildEmptyMessage()
                        else
                          ...List.generate(components.length,
                              (i) => buildDraggableComponent(i)),
                        if (showTrashBin) _buildTrashBin(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTrashBin() {
    return Positioned(
      bottom: 20,
      right: MediaQuery.of(context).size.width * 0.5 - 30,
      child: DragTarget<int>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (DragTargetDetails<int> details) {
          setState(() {
            components.removeAt(details.data);
            showTrashBin = false;
          });
        },
        builder: (context, candidateData, rejectedData) {
          return Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.red.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Icon(Icons.delete, color: Colors.white),
          );
        },
      ),
    );
  }

  Widget _buildEmptyMessage() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Drag elements onto the canvas to design a page',
          style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget buildDraggableComponent(int index) {
    final comp = components[index];
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 200),
      left: comp.x.clamp(0, canvasWidth - comp.width),
      top: comp.y.clamp(0, canvasHeight - comp.height),
      child: LongPressDraggable<int>(
        data: index,
        feedback: Opacity(
          opacity: 0.7,
          child: SizedBox(
            child: buildComponentWidget(comp),
          ),
        ),
        childWhenDragging: Container(),
        onDragStarted: () => setState(() => showTrashBin = true),
        onDragEnd: (_) => setState(() => showTrashBin = false),
        child: GestureDetector(
          onPanUpdate: (details) {
            if (!isPlay) return;
            setState(() {
              comp.x = (comp.x + details.delta.dx)
                  .clamp(0, canvasWidth - comp.width);
              comp.y = (comp.y + details.delta.dy)
                  .clamp(0, canvasHeight - comp.height);
            });
          },
          onTap: () {
            if (comp.isEditable == true) {
              setState(() => selectedIndex = index);
              editComponent2(index);
            }
          },
          child: Transform.scale(
            scale: selectedIndex == index ? 1.05 : 1.0,
            child: buildComponentWidget(comp),
          ),
        ),
      ),
    );
  }

  Widget buildComponentWidget(UIComponent comp) {
    return comp.buildWidget(context);
  }

  Future<Color?> showColorPickerDialog(Color initialColor) async {
    Color tempColor = initialColor;
    return await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blue.shade50,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: Text("Pick a color",
            style: TextStyle(
                color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: tempColor,
            onColorChanged: (color) => tempColor = color,
            showLabel: true,
            pickerAreaBorderRadius: BorderRadius.circular(8),
            enableAlpha: false,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(null),
            child: Text('Cancel',
                style: TextStyle(
                    color: Colors.blue.shade900, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            onPressed: () => Navigator.of(context).pop(tempColor),
            child: const Text('Save',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void showTutorial(bool hasAdd) {
    final tutorialCoachMark = TutorialCoachMark(
      targets: [
        TargetFocus(identify: "LockButton", keyTarget: lockKey, contents: [
          _buildTutorialContent("Step 1 of 5", "🔓 Enable/disable dragging.")
        ]),
        TargetFocus(
          identify: "Component",
          shape: ShapeLightFocus.RRect,
          targetPosition: TargetPosition(
            const Size(300, 90),
            const Offset(40, 280),
          ),
          contents: [
            _buildTutorialContent(
              "Step 3 of 5",
              "✏️ Tap on a component to edit its font size and color.",
            ),
          ],
        ),
        TargetFocus(
            identify: "CheckButton",
            keyTarget: checkButtonKey,
            contents: [
              _buildTutorialContent("Step 4 of 5", "✅ Evaluate your design.",
                  contentAlign: ContentAlign.top)
            ]),
        if (hasAdd)
          TargetFocus(
              identify: "AddButton",
              keyTarget: addButtonKey,
              contents: [
                _buildTutorialContent("Step 5 of 5", "➕ Add new components.")
              ]),
      ],
      skipWidget: Text("SKIP",
          style: GoogleFonts.comicNeue(
              color: Colors.white, fontWeight: FontWeight.bold)),
      onFinish: () => debugPrint("Tutorial Completed"),
    );

    tutorialCoachMark.show(context: context);
  }

  TargetContent _buildTutorialContent(String step, String message,
      {ContentAlign contentAlign = ContentAlign.bottom}) {
    return TargetContent(
      align: contentAlign,
      child: Column(
        children: [
          Text(step,
              style: GoogleFonts.comicNeue(color: Colors.white, fontSize: 20)),
          const SizedBox(height: 10),
          Text(message,
              style:
                  GoogleFonts.indieFlower(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  void editComponent(int index) {
    UIComponent comp = components[index];
    if (comp is ProfilePicture) {
      return;
    }
    TextEditingController fontSizeController =
        TextEditingController(text: comp.fontSize.toString());
    Color currentColor = comp.color;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${comp.type} Component'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fontSizeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Font Size'),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                Color? picked = await showColorPickerDialog(currentColor);
                if (picked != null) setState(() => currentColor = picked);
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: currentColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2)),
                child: const Icon(Icons.color_lens, color: Colors.white),
              ),
            )
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              setState(() {
                comp.fontSize =
                    double.tryParse(fontSizeController.text) ?? comp.fontSize;
                comp.color = currentColor;
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }


  
  void editComponent2(int index) {
    UIComponent comp = components[index];
    TextEditingController fontSizeController =
        TextEditingController(text: comp.fontSize.toString());
    Color currentColor = comp.color;
 showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(
            color: Color(0xFFFFC9C9),
            width: 4,
          ),
        ),
        backgroundColor: const Color(0xFFFFF2E3), // Pastel beige background
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    'Adjust Settings',
                    style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF7C94), // Coral Pink
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Font Size Label
                  Text(
                    'Font Size',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4E4E4E), // Soft charcoal
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Current Font Size Value
                  Text(
                    '${comp.fontSize.toInt()} pt',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF4E4E4E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Font Size Slider
                  Slider(
                    value: comp.fontSize,
                    min: 10,
                    max: 40,
                    activeColor: Color(0xFF45C1A1), // Teal Green
                    thumbColor: Color(0xFFFF9641),  // Warm Orange
                    onChanged: (value) {
                      setState(() {
                        comp.fontSize = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Color Picker Label
                  const Text(
                    'Color',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4E4E4E),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Color Choices
                  Wrap(
                    spacing: 10,
                    children: [
                      Color(0xFFF26722),
                      Color(0xFFFABD42),
                      Color(0xFFA0C94F),
                      Color(0xFF40BEB0),
                      Color(0xFF4D89FF),
                      Color(0xFFA564E9),
                    ].map((color) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            comp.color = color;
                          });
                        },
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: comp.color == color ? Colors.black : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),

                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF59C3A6), // Mint Green
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                      
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF62B6FF), // Soft Blue
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      );
    },
  );
  }

  void submitDesign(void Function(String feedback) onResult) {}


  void handleSubmitDesign() {
    submitDesign((feedback) {
      setState(() {
        feedbackText = feedback;
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: const Color(0xFFDBF2FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(
                color: Color.fromARGB(255, 175, 222, 248),
                width:4,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header with Emoji and Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.emoji_emotions,
                        size: 25,
                        color: Colors.deepOrange,
                      ),
                      SizedBox(width: 8),
                      Text(
                        "Design Feedback",
                     style: GoogleFonts.fredoka(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Scrollable feedback content
                  SizedBox(
                    height: 250,
                    child: SingleChildScrollView(
                      child: Column(
                        children: feedback.split('\n').map((line) {
                          IconData icon;
                          Color iconColor;

                          if (line.contains("✅")) {
                            icon = Icons.check_circle;
                            iconColor = Colors.green;
                          } else if (line.contains("⚠️")) {
                            icon = Icons.warning_amber_rounded;
                            iconColor = Colors.orange;
                          } else {
                            icon = Icons.bubble_chart;
                            iconColor = Colors.grey;
                          }

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(icon, color: iconColor),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    line.replaceAll(RegExp(r"✅|⚠️"), "").trim(),
                                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4E4E4E), // Soft charcoal
                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Close button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                     style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF59C3A6), // Mint Green
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                    child: Text(
                      "Close",
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
