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
          buildCanvasBody(
              backgroundImage: "assets/Animation/profilebackground.png"),

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
            icon: isPlay ? Icons.lock_rounded : Icons.lock_open_rounded,
            label: isPlay ? 'Lock' : 'Unlock',
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
          border: isActive
              ? Border.all(
                  color: Colors.white,
                  width: 2,
                )
              : null,
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

  void submitDesign(
      void Function(List<Map<String, String>> feedbackList) onResult) {
    int total = components.length;

    if (total == 0) {
      onResult([
        {
          'text':
              "Hmm... there's nothing to check here! Try adding some components first.",
        }
      ]);
      return;
    }

    List<Map<String, String>> feedbackList = [];
    List<UIComponent> checkedComponents = components.where((component) {
      const allowedTypes = {'Name', 'Bio', 'ContactInfo'};
      return allowedTypes.contains(component.type);
    }).toList();
    // Font Size
    int goodFontSize = components.where((c) => c.fontSize > 14.0).length;
    if (goodFontSize != total) {
      feedbackList.add({
        'text':
            "Oops, some of your text looks a bit tiny – I can barely see it! Usually, a font size of 15pt or above works well for readability.",
        'image': 'assets/Game/fontsizetoosmall.png',
      });
    }

    // Font Consistency
    Set<int> fontSizes = checkedComponents.map((c) => c.fontSize).toSet();

    print(checkedComponents.map((c) => c.fontSize).toList());
    if (fontSizes.length > 1) {
      feedbackList.add({
        'text':
            "Hmm… it looks like quite a few different font sizes are being used. That might make the page feel a bit messy.",
        'image': 'assets/Game/toomanyfontsize.png',
      });
    }

    // Contrast

    if (components.any((c) => c.color.value == 0xFFEEEEEE)) {
      feedbackList.add({
        'text':
            "⚠️ Some components have very low contrast with white text. Try using a darker color.",
        'image': 'assets/Game/lowconstrast.png',
      });
    }

    // Layout boundary
    bool layoutOk = components.every((c) =>
        c.x >= 0 &&
        c.y >= 0 &&
        c.x + c.width <= canvasWidth &&
        c.y + c.height <= canvasHeight);
    if (!layoutOk) {
      feedbackList.add({
        'text':
            "Uh-oh… it seems like some components are falling outside the screen. You might want to drag them back in.",
        'image': 'assets/Game/withinscreen.png',
      });
    }

    // Button Placement
    double bottomThreshold = canvasHeight * 0.8;
    int wellPlacedButtons = components
        .where((c) => c.type == 'Button' && (c.y + c.height) >= bottomThreshold)
        .length;
    if (wellPlacedButtons == 0) {
      feedbackList.add({
        'text':
            "Hmm... where’s the action button? Try placing it near the bottom – that’s where users usually look.",
        'image': 'assets/Game/layout.jpg',
      });
    }

    // Alignment


    double? commonX =
        checkedComponents.isNotEmpty ? checkedComponents.first.x : null;
    bool consistentAlignment = false;
    if (commonX != null) {
      consistentAlignment =
          checkedComponents.every((c) => (c.x - commonX).abs() <= 10);
    }

    if (!consistentAlignment && checkedComponents.length > 1) {
      feedbackList.add({
        'text':
            "Hmm, looks like some items are a bit off-alignment. Aligning them better could make your design feel more polished.",
        'image': 'assets/Game/goodalignment.png',
      });
    }

    // If everything is good
    if (feedbackList.isEmpty) {
      feedbackList.add({
        'text': "Well done! Your design looks great overall. 🎉HCI is about helping users — not making them squint. 🧐 Font size, spacing, and clarity all matter.",
        'image': 'assets/Game/welldone.png',
      });
    }

    onResult(feedbackList);
  }
}
