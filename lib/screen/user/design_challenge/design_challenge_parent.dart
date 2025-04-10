// design_challenge_ui_base.dart

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'components.dart';

abstract class DesignChallengeUIState<T extends StatefulWidget>
    extends State<T> {
  List<UIComponent> components = [];
  Color canvasBackgroundColor = Colors.white;
  double canvasWidth = 400;
  double canvasHeight = 600;
  int? selectedIndex;
  bool isPlay = true;
  OverlayEntry? overlayEntry;
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
        canvasHeight = MediaQuery.of(context).size.height * 0.8;
      });
    });
  }

  Widget buildCanvasBody() {
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
                      color: canvasBackgroundColor,
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Stack(
                      children: components.isEmpty
                          ? [_buildEmptyMessage()]
                          : List.generate(components.length,
                              (i) => buildDraggableComponent(i)),
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
          if (!isPlay) return;
          setState(() {
            comp.x =
                (comp.x + details.delta.dx).clamp(0, canvasWidth - comp.width);
            comp.y = (comp.y + details.delta.dy)
                .clamp(0, canvasHeight - comp.height);
          });
        },
        onTap: () {
          setState(() => selectedIndex = index);
          editComponent(index);
        },
        child: Transform.scale(
          scale: selectedIndex == index ? 1.05 : 1.0,
          child: _buildComponentWidget(comp),
        ),
      ),
    );
  }

  Widget _buildComponentWidget(UIComponent comp) {
    switch (comp.type) {
      case 'ProfilePicture':
        return (comp as ProfilePicture).buildWidget(context);
      case 'Name':
        return (comp as Name).buildWidget(context);
      case 'Bio':
        return (comp as Bio).buildWidget(context);
      case 'ContactInfo':
        return (comp as ContactInfo).buildWidget(context);

      case 'EditProfile':
        return (comp as EditProfile).buildWidget(context);
      default:
        return const SizedBox();
    }
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
            identify: "BackgroundColorKey",
            keyTarget: backgroundColorKey,
            contents: [
              _buildTutorialContent(
                  "Step 2 of 5", "🎨 Change canvas background color.")
            ]),
        TargetFocus(
          identify: "Component",
          shape: ShapeLightFocus.RRect,
          targetPosition: TargetPosition(
            const Size(300, 90),
            const Offset(40, 280), // Position (x, y)
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

  void submitDesign(void Function(String feedback, int score) onResult) {
    int total = components.length;
    if (total == 0) return;

    int goodFontSize = 0, goodContrast = 0, touchable = 0;
    Set<double> fontSizes = {};
    Set<Color> usedColors = {};
    bool layoutOk = true, spacingOk = true;

    for (var comp in components) {
      if (comp.fontSize >= 14.0) goodFontSize++;
      fontSizes.add(comp.fontSize);
      usedColors.add(comp.color);
      if (_calculateContrastRatio(comp.color, canvasBackgroundColor) >= 4.5)
        goodContrast++;

      for (var other in components) {
        if (comp != other) {
          double dx = (comp.x + comp.width / 2) - (other.x + other.width / 2);
          double dy = (comp.y + comp.height / 2) - (other.y + other.height / 2);
          if (math.sqrt(dx * dx + dy * dy) < 20) spacingOk = false;
        }
      }

      if (comp.x < 0 ||
          comp.y < 0 ||
          comp.x + comp.width > canvasWidth ||
          comp.y + comp.height > canvasHeight) layoutOk = false;
      if (comp.width >= 48 && comp.height >= 48) touchable++;
    }

    double fontScore = (goodFontSize / total) * 15;
    double fontConsistent = fontSizes.length <= 3 ? 10 : 5;
    double colorConsistent = usedColors.length <= 3
        ? 10
        : math.max(0, 10 - (usedColors.length - 3) * 3);
    double contrastScore = (goodContrast / total) * 15;
    double layoutScore = layoutOk ? 15 : 8;
    double spacingScore = spacingOk ? 10 : 5;
    double touchScore = (touchable / total) * 10;
    double headerScore = components.any((c) => c.type == 'Header') ? 5 : 0;
    double aesthetics = 5;

    int finalScore = (fontScore +
            fontConsistent +
            colorConsistent +
            contrastScore +
            layoutScore +
            spacingScore +
            touchScore +
            headerScore +
            aesthetics)
        .round();

    String feedback = '''
🔍 HCI Evaluation:
• Font Size: ${fontScore.round()}/15
• Font Consistency: $fontConsistent/10
• Color Consistency: ${colorConsistent.round()}/10
• Contrast: ${contrastScore.round()}/15
• Layout: ${layoutScore.round()}/15
• Spacing: $spacingScore/10
• Button Size: ${touchScore.round()}/10
• Header: $headerScore/5
• Aesthetic Bonus: $aesthetics/5
🎯 Total Score: $finalScore / 100
''';

    onResult(feedback, finalScore);
  }

  double _calculateContrastRatio(Color color1, Color color2) {
    double luminance(Color c) {
      final r = c.red / 255.0;
      final g = c.green / 255.0;
      final b = c.blue / 255.0;
      double channel(double v) => (v <= 0.03928)
          ? v / 12.92
          : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
      return 0.2126 * channel(r) + 0.7152 * channel(g) + 0.0722 * channel(b);
    }

    final l1 = luminance(color1);
    final l2 = luminance(color2);

    return (l1 > l2) ? (l1 + 0.05) / (l2 + 0.05) : (l2 + 0.05) / (l1 + 0.05);
  }
}
