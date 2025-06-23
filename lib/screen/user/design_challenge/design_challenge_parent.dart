// design_challenge_ui_base.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'components_profile.dart';

enum LayoutIssue {
  none,
  overlap,
  noGap,
  overCanvas,
}

abstract class DesignChallengeUIState<T extends StatefulWidget>
    extends State<T> {
  List<UIComponent> components = [];
  Color canvasBackgroundColor = Colors.white;
  double canvasWidth = 400;
  double canvasHeight = 600;
  int? selectedIndex;
  bool isPlay = true;

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
      child: GestureDetector(
        onPanUpdate: (details) {
          setState(() {
            if (isPlay) {
              comp.x = (comp.x + details.delta.dx)
                  .clamp(0, canvasWidth - comp.width);
              comp.y = (comp.y + details.delta.dy)
                  .clamp(0, canvasHeight - comp.height);
            }
          });
        },
        onTap: () {
          if (components[index] is ProfilePicture) {
        
            return;
          }
          setState(() {
            selectedIndex = index;
          });

          editComponent2(index);
        },
        child: Transform.scale(
          scale: selectedIndex == index ? 1.05 : 1.0,
          child: buildComponentWidget(comp),
        ),
      ),
    );
  }

  Widget buildComponentWidget(UIComponent comp) {
    return comp.buildWidget(context);
  }

  TargetContent buildTutorialContent(String step, String message,
      {ContentAlign contentAlign = ContentAlign.bottom}) {
    return TargetContent(
      align: contentAlign,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF2A0),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              step,
              style: GoogleFonts.comicNeue(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              style: GoogleFonts.indieFlower(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
          ],
        ),
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
                        color: const Color(0xFFFF7C94), // Coral Pink
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Font Size Label
                    const Text(
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
                      style: const TextStyle(
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
                      activeColor: const Color(0xFF45C1A1), // Teal Green
                      thumbColor: const Color(0xFFFF9641), // Warm Orange
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
                        const Color(0xFFF76707),
                        const Color(0xFFF4B400),
                        const Color(0xFFA0C94F),
                        const Color(0xFF40BEB0),
                        const Color(0xFFEEEEEE),
                        const Color(0xFFA564E9),
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
                            backgroundColor:
                                const Color(0xFF59C3A6), // Mint Green
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
                            backgroundColor:
                                const Color(0xFF62B6FF), // Soft Blue
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
      bool postiveFeedback =
          feedback.any((f) => f["text"]?.contains("Well done") ?? false);

      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Feedback dialog',
        barrierColor: Colors.black.withOpacity(0.8),
        transitionDuration: const Duration(milliseconds: 300),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: const Color(0xFFDBF2FF),
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Design Feedback",
                        style: GoogleFonts.fredoka(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Image.asset(
                        feedback.any((f) =>
                                f["text"]?.contains("Well done") ?? false)
                            ? 'assets/Animation/grandmahappy.png'
                            : 'assets/Animation/grandmasad.png',
                        height: MediaQuery.of(context).size.height * 0.18,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: feedback.length,
                          itemBuilder: (context, index) {
                            final line = feedback[index];
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (line["image"] != null)
                                    !postiveFeedback
                                        ? Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                  color: Colors.grey.shade300),
                                            ),
                                            child: Image.asset(
                                              line["image"]!,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.28,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : Image.asset(
                                            line["image"]!,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.25,
                                            fit: BoxFit.contain,
                                          ),
                                  const SizedBox(height: 16),
                                  Text(
                                    line["text"] ?? "Something went wrong.",
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                      color: Color(0xFF4E4E4E),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (feedback.length > 1)
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
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF59C3A6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
