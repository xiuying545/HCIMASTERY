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
              editComponent(index);
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
            onPressed: () => setState(() {
              components.removeAt(index);
              Navigator.pop(context);
            }),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24),side: const BorderSide(
          color: Color.fromARGB(255, 175, 222, 248), 
          width: 6, 
        ),),
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
                        "DESIGN FEEDBACK",
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Feedback content
                  ...feedback.split('\n').map((line) {
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
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  const SizedBox(height: 20),

                  // Close button
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: BorderSide(
                          color: Colors.orange.shade700,
                          width: 4,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
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
