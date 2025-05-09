// design_challenge_ui_base.dart

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
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
  final PageController _pageController = PageController();

  GlobalKey lockKey = GlobalKey();
  GlobalKey backgroundColorKey = GlobalKey();
  GlobalKey addButtonKey = GlobalKey();
  GlobalKey checkButtonKey = GlobalKey();

  int score = 0;
  List<Map<String, String>> feedbackList = [];

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

  Future<void> editComponent2(int index) async {
    UIComponent comp = components[index];

    await showDialog(
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
                      value: comp.fontSize.toDouble(),
                      min: 10,
                      max: 28,
                      activeColor: Color(0xFF45C1A1), // Teal Green
                      thumbColor: Color(0xFFFF9641), // Warm Orange
                      onChanged: (value) {
                        setState(() {
                          comp.fontSize = value.toInt();
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
                        Color(0xFFF76707),
                        Color(0xFFF4B400),
                        Color(0xFFA0C94F),
                        Color(0xFF40BEB0),
                        Color(0xFFEEEEEE),
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
                                color: comp.color == color
                                    ? Colors.black
                                    : Colors.transparent,
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
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
    setState(() {});
  }

  void submitDesign(
      void Function(List<Map<String, String>> feedback) onResult) {}

  void handleSubmitDesign() {
    submitDesign((feedback) {
      setState(() {
        feedbackList = feedback;
      });

      showDialog(
        context: context,
        barrierColor: Colors.black.withOpacity(0.9),
        builder: (BuildContext context) {
          return Dialog(
            backgroundColor: Colors.transparent, // Let Stack background show
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 10,
                  child: Image.asset(
        feedback.any((f) => f['text']?.contains('Well done') ?? false)
            ? 'assets/Animation/grandmahappy.png'
            : 'assets/Animation/grandmasad.png',
                    height: MediaQuery.of(context).size.height * 0.23,
                  ),
                ),
                // Main dialog box
                Container(
                  margin:  EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.23), 
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDBF2FF),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color.fromARGB(255, 175, 222, 248),
                      width: 4,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.emoji_emotions,
                              size: 25, color: Colors.deepOrange),
                          const SizedBox(width: 8),
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

                      SizedBox(
                        height: feedback.any((line) => line["image"] != null)
                            ? MediaQuery.of(context).size.height * 0.40
                            : MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: PageView.builder(
                                controller: _pageController,
                                itemCount: feedback.length,
                                itemBuilder: (context, index) {
                                  final line = feedback[index];
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (line["image"] != null)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 12.0),
                                          child: Image.asset(
                                            line["image"]!,
                                            height: MediaQuery.of(context).size.height * 0.25,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16.0),
                                        child: Text(
                                          line["text"] ??
                                              "Something went wrong.",
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            height: 1.2,
                                            color: Color(0xFF4E4E4E),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                           if( feedback.length>1)
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: feedback.length,
                              effect: WormEffect(
                                dotHeight: 10,
                                dotWidth: 10,
                                activeDotColor: Colors.deepOrange,
                                dotColor: Colors.orange.shade200,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Close button
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF59C3A6),
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
              ],
            ),
          );
        },
      );
    });
  }
}
