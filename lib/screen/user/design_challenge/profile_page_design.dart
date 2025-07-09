import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_parent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp1/screen/user/design_challenge/components_profile.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

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
              icon: const Icon(Icons.arrow_back, color: Colors.brown, size: 28),
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
        color: const Color(0xFFF48C8C), // Soft coral pink
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
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
            label: 'Guide',
            onTap: () => showTutorial(),
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
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
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
          color: isActive ? const Color(0xFFA2D2FF) : Colors.transparent,
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
              style: const TextStyle(
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

  @override
  void submitDesign(
      void Function(List<Map<String, String>> feedbackList) onResult) {
    int total = components.length;

    if (total == 0) {
      onResult([
        {
          'text':
              "Hmm... tiada apa yang boleh diperiksa di sini! Cuba tambah beberapa komponen terlebih dahulu.",
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
            "Oops, sesetengah teks anda kelihatan agak kecil – saya hampir tak nampak! Kebiasaannya, saiz fon 15pt ke atas lebih sesuai untuk keterbacaan.",
        'image': 'assets/Game/fontsizetoosmall.png',
      });
    }

    // Font Consistency
    Set<int> fontSizes = checkedComponents.map((c) => c.fontSize).toSet();
    if (fontSizes.length > 1) {
      feedbackList.add({
        'text':
            "Hmm… nampaknya terdapat beberapa saiz fon yang berbeza digunakan. Ini boleh menyebabkan halaman kelihatan tidak kemas.",
        'image': 'assets/Game/toomanyfontsize.png',
      });
    }

    // Contrast
    if (components.any((c) => c.color.value == 0xFFEEEEEE)) {
      feedbackList.add({
        'text':
            "⚠️ Sesetengah komponen mempunyai kontras yang sangat rendah dengan teks putih. Cuba gunakan warna yang lebih gelap.",
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
            "Uh-oh… nampaknya ada komponen yang terkeluar dari skrin. Anda mungkin perlu seretnya semula ke dalam.",
        'image': 'assets/Game/withinscreen.png',
      });
    }

    components.sort((a, b) => a.y.compareTo(b.y));
    for (var comp in components) {
      print('Component Type: ${comp.type}, X: ${comp.x}, Y: ${comp.y}');
    }

    if (components.isNotEmpty && components.last.type != "Button") {
      feedbackList.add({
        'text':
            "Hmm... di mana butang tindakan? Cuba letakkannya berhampiran bahagian bawah – itu tempat biasa pengguna mencarinya.",
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
            "Hmm, nampaknya sesetengah elemen tidak sejajar dengan betul. Penjajaran yang baik akan menjadikan reka bentuk anda lebih kemas.",
        'image': 'assets/Game/goodalignment.png',
      });
    }

    // Consistent Vertical Spacing
    if (!hasConsistentVerticalSpacing(checkedComponents)) {
      feedbackList.add({
        'text':
            "Jarak menegak antara elemen tidak konsisten. Jarak yang konsisten membantu keterbacaan dan aliran visual!",
        'image': 'assets/Game/consistentspacing.png',
      });
    }

    if (!hasMinimumVerticalSpacing(components)) {
      feedbackList.add({
        'text':
            "Sesetengah elemen terlalu rapat antara satu sama lain. Cuba berikan lebih ruang agar reka bentuk lebih mudah dibaca.",
        'image': 'assets/Game/spacing.png',
      });
    }

    // If everything is good
    if (feedbackList.isEmpty) {
      feedbackList.add({
        'text':
            "Syabas! Reka bentuk anda kelihatan hebat secara keseluruhan. 🎉 HCI berkaitan dengan membantu pengguna — bukan membuat mereka juling mata. 🧐 Saiz fon, jarak, dan kejelasan semuanya penting.",
        'image': 'assets/Game/welldone.png',
      });
    }

    onResult(feedbackList);
  }

  bool hasMinimumVerticalSpacing(List<UIComponent> items,
      {double minGap = 8.0}) {
    if (items.length < 2) return true;

    final sorted = List<UIComponent>.from(items)
      ..sort((a, b) => a.y.compareTo(b.y));

    for (int i = 1; i < sorted.length; i++) {
      double prevBottom = sorted[i - 1].y + sorted[i - 1].height;
      double currTop = sorted[i].y;
      double gap = currTop - prevBottom;

      if (gap < minGap) {
        print(
            '⚠️ Gap too small between ${sorted[i - 1].type} and ${sorted[i].type}: $gap');
        return false;
      }
    }
    return true;
  }

  bool hasConsistentVerticalSpacing(List<UIComponent> items,
      {double tolerance = 15.0}) {
    if (items.length < 3) return true;

    items.sort((a, b) => a.y.compareTo(b.y));

    List<double> gaps = [];
    for (int i = 1; i < items.length; i++) {
      double previousBottom = items[i - 1].y + items[i - 1].height;
      double currentTop = items[i].y;
      gaps.add(currentTop - previousBottom);
    }

    double firstGap = gaps[0];

    return gaps.every((gap) => (gap - firstGap).abs() <= tolerance);
  }

  void showTutorial() {
    final tutorialCoachMark = TutorialCoachMark(
        targets: [
          TargetFocus(identify: "LockButton", keyTarget: lockKey, contents: [
            buildTutorialContent("Step 1 of 3", "🔓 Enable/disable dragging.",
                contentAlign: ContentAlign.top)
          ]),
          TargetFocus(
            identify: "Component",
            shape: ShapeLightFocus.RRect,
            targetPosition: TargetPosition(
              const Size(300, 90),
              const Offset(40, 280),
            ),
            contents: [
              buildTutorialContent(
                "Step 2 of 3",
                "✏️ Tap on a component to edit its font size and color.",
              ),
            ],
          ),
          TargetFocus(
              identify: "CheckButton",
              keyTarget: checkButtonKey,
              contents: [
                buildTutorialContent("Step 3 of 3", "✅ Evaluate your design.",
                    contentAlign: ContentAlign.top)
              ]),
        ],
        skipWidget: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2A0),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "SKIP",
              style: GoogleFonts.indieFlower(
                // Matches message font
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ));

    tutorialCoachMark.show(context: context);
  }
}
