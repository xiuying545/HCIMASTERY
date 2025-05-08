import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_parent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp1/screen/user/design_challenge/components_profile.dart';


class ProfileDesignChallengePage extends StatefulWidget {
  const ProfileDesignChallengePage({super.key});

  @override
  _ProfileDesignChallengePageState createState() =>
      _ProfileDesignChallengePageState();
}

class _ProfileDesignChallengePageState
    extends DesignChallengeUIState<ProfileDesignChallengePage> {

  @override
  void initState() {
    super.initState();
    components = [
      ProfilePicture(),
      Bio(),
      ContactInfo(),
      EditProfile(),
      Name()
    ];
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    // appBar: AppBar(
    //   // backgroundColor: Colors.blue.shade900,
    //   // foregroundColor: Colors.white,
    //   // title: Text(
    //   //   'Profile Page',
    //   //   style: GoogleFonts.poppins(
    //   //     fontSize: 24,
    //   //     fontWeight: FontWeight.w600,
    //   //   ),
    //   // ),
    // ),
    body: Stack(
      children: [
        buildCanvasBody(backgroundImage: "assets/Animation/profilebackground.png"),

        // Top-left button like AppBar back button
        Positioned(
          top: 40,
          left: 16,
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.brown, size: 28),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
    ),
  
    bottomNavigationBar: buildBottomBar(),
  );
}


Widget buildBottomBar() {
  return Container(
    height: 90,
    decoration: BoxDecoration(
      color: Color(0xFFF48C8C), // Soft coral pink
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(40),
        topRight: Radius.circular(40),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 10,
          offset: Offset(0, -4),
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
             _buildNavItem(
            icon: isPlay?Icons.lock_rounded:Icons.lock_open_rounded,
            label: isPlay?'Lock':'Unlock',
            onTap: () => setState(() => isPlay = !isPlay),
            key: lockKey,
          ),
          _buildNavItem(
            icon: Icons.send_rounded,
            label: 'Submit',
            onTap: handleSubmitDesign,
            key: checkButtonKey,
          ),
          _buildNavItem(
            icon: Icons.auto_awesome_rounded,
            label: 'Help',
            onTap: () => showTutorial(true),
          ),
      ],
    ),
  );
}

Widget navBarItem(IconData icon, String label) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
      SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}

Widget _buildNavItem({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
  bool isActive = false,
  Key? key,
}) {
  return GestureDetector(
    key: key,
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
color: isActive ? Color(0xFFA2D2FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(25),
        border: isActive ? Border.all(
          color: Colors.white,
          width: 2,
        ) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.white : Colors.white70,
            size: 30,
          ),
          const SizedBox(height: 6),
         Text(
        label,
        style: TextStyle(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
         )
        ],
      ),
    ),
  );
}
  // Widget _buildBottomBar() {
  //   return ClipRRect(
  //     borderRadius: const BorderRadius.vertical(top: Radius.circular(35)),
  //     child: BottomAppBar(
  //       color: Colors.orange,
  //       child: Row(
  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //         children: [
  //      _buildBottomButton('GUIDE', Icons.tips_and_updates, () => showTutorial(true)),
  //           _buildBottomButton('CHECK', Icons.rate_review, _handleSubmitDesign, key: checkButtonKey),
  //         ],
  //       ),
  //     ),
  //   );
  // }

 






  
@override
  void submitDesign(void Function(String feedback) onResult) {

    
    int total = components.length;
    if (total == 0) {
      onResult("No components to evaluate.");
      return;
    }

    List<String> feedbackList = [];

    // Font Size Evaluation
    int goodFontSize = components.where((c) => c.fontSize >= 14.0).length;
    if (goodFontSize == total) {
      feedbackList.add(
          "✅ All text elements have an adequate font size, ensuring readability.");
    } else {
      feedbackList.add(
          "⚠️ Some text elements have a font size smaller than 14pt, which may hinder readability.");
    }

    // Font Consistency Evaluation
    Set<double> fontSizes = components.map((c) => c.fontSize).toSet();
    if (fontSizes.length <= 3) {
      feedbackList.add(
          "✅ The design maintains consistent font sizes, enhancing visual coherence.");
    } else {
      feedbackList.add(
          "⚠️ Multiple font sizes are used, which may affect the design's uniformity.");
    }

    // Contrast Evaluation
    int goodContrast = components
        .where((c) => _calculateContrastRatio(c.color, Colors.white) >= 4.5)
        .length;
    if (goodContrast == total) {
      feedbackList.add(
          "✅ All components have sufficient contrast against the background, ensuring legibility.");
    } else {
      feedbackList.add(
          "⚠️ Some components lack adequate contrast with the background, which may impair legibility.");
    }

    // Layout Evaluation
    bool layoutOk = components.every((c) =>
        c.x >= 0 &&
        c.y >= 0 &&
        c.x + c.width <= canvasWidth &&
        c.y + c.height <= canvasHeight);
    if (layoutOk) {
      feedbackList.add(
          "✅ All components are within the canvas boundaries, ensuring a proper layout.");
    } else {
      feedbackList.add(
          "⚠️ Some components extend beyond the canvas boundaries, which may lead to layout issues.");
    }

/////////////////////check for color harmony
    ///spacinggg

    // Button Placement Evaluation
    double bottomThreshold = canvasHeight * 0.8;
    int wellPlacedButtons = components
        .where((c) => c.type == 'Button' && (c.y + c.height) >= bottomThreshold)
        .length;
    if (wellPlacedButtons > 0) {
      feedbackList.add(
          "✅ Primary action buttons are placed towards the bottom of the screen, aligning with user expectations.");
    } else {
      feedbackList.add(
          "⚠️ Consider placing primary action buttons at the bottom of the screen for better accessibility.");
    }

    // Alignment Consistency Evaluation
    List<UIComponent> checkedComponents = components.where((component) {
      const allowedTypes = {'Name', 'Bio', 'ContactInfo'};
      return allowedTypes.contains(component.type);
    }).toList();
    double? commonX =
        checkedComponents.isNotEmpty ? checkedComponents.first.x : null;
    bool consistentAlignment = false;
    if (commonX != null) {
      consistentAlignment =
          checkedComponents.every((c) => (c.x - commonX).abs() <= 10);
    }
    if (consistentAlignment) {
      feedbackList.add(
          "✅ Components are consistently aligned, enhancing the design's visual structure.");
    } else {
      feedbackList.add(
          "⚠️ Inconsistent alignment detected among components, which may disrupt the visual flow.");
    }

    // Compile Feedback
    String feedback = "${feedbackList.join("\n")}";
    onResult(feedback);
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
