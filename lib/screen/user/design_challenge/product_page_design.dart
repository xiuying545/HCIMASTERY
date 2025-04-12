
import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/components_product.dart';
import 'package:fyp1/screen/user/design_challenge/design_challenge_parent.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fyp1/screen/user/design_challenge/components_profile.dart';

class ProductDesignChallengePage extends StatefulWidget {
  const ProductDesignChallengePage({super.key});

  @override
  _ProductDesignChallengePage createState() => _ProductDesignChallengePage();
}

class _ProductDesignChallengePage
    extends DesignChallengeUIState<ProductDesignChallengePage> {
  @override
  void initState() {
    super.initState();
    components = [];
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
      // body: buildCanvasBody(backgroundImage: 'assets/Animation/weatherbackground.png'),
      body: buildCanvasBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink[100],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.lock_rounded,
              label: 'Lock',
              onTap: () => setState(() => isPlay = !isPlay),
              isActive: isPlay,
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
            _buildNavItem(
              icon: Icons.add,
              label: 'Add',
              onTap: _toggleOverlay,
            ),
          ],
        ),
      ),
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
          color: isActive ? Colors.purple.shade200 : Colors.transparent,
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
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: isActive ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleOverlay() {
    if (overlayEntry == null) {
      overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
          top: 100,
          left: MediaQuery.of(context).size.width * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Material(
            color: Colors.blue.shade900.withOpacity(0.8),
            elevation: 8,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.center,
                children: [
                  _buildOverlayIconButton(Icons.search, 'SearchBar'),
                  _buildOverlayIconButton(Icons.filter_list, 'FilterTabs'),
                  _buildOverlayIconButton(Icons.local_mall, 'ProductCard'),
                  _buildOverlayIconButton(Icons.grid_view, 'ProductGridItem'),
                  _buildOverlayIconButton(Icons.navigation, 'BottomNavBar'),
                ],
              ),
            ),
          ),
        ),
      );
      Overlay.of(context).insert(overlayEntry!);
    } else {
      overlayEntry?.remove();
      overlayEntry = null;
    }
  }

  Widget _buildOverlayIconButton(IconData icon, String type) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () {
        setState(() {
          switch (type) {
            // 🛍️ 商店组件
            case 'ProductCard':
              components.add(ProductCard());
              break;
            case 'SearchBar':
              components.add(SearchBarUI());
              break;
            case 'FilterTabs':
              components.add(FilterTabs());
              break;
            case 'BottomNavBar':
              components.add(BottomNavBar());
              break;
            case 'ProductGridItem':
              components.add(ProductGridItem());
              break;
          }
        });
        _toggleOverlay();
      },
      tooltip: type,
    );
  }


  @override
  void submitDesign(void Function(String feedback) onResult) {
    int total = components.length;
    if (total == 0) {
      onResult(
          "Your canvas is empty. Try dragging in some UI components to begin your design!");
      return;
    }

    List<String> feedbackList = [];

    // Required Elements Check
    final hasSearchBar = components.any((c) => c.type == 'SearchBarUI');
    final hasFilter = components.any((c) => c.type == 'FilterTabs');
    final hasProduct = components
        .any((c) => c.type == 'ProductCard' || c.type == 'ProductGridItem');
    final hasNav = components.any((c) => c.type == 'BottomNavBar');

    if (hasSearchBar && hasFilter && hasProduct && hasNav) {
      feedbackList.add(
          "✅ Your page includes all the essential UI components. Well done!");
    } else {
      List<String> missing = [];
      if (!hasSearchBar) missing.add("Search Bar");
      if (!hasFilter) missing.add("Filter Tabs");
      if (!hasProduct) missing.add("Product Item");
      if (!hasNav) missing.add("Bottom Navigation");
      feedbackList
          .add("⚠️ You're missing some key components: ${missing.join(", ")}.");
    }

    // Layout Boundaries
    bool layoutOk = components.every((c) =>
        c.x >= 0 &&
        c.y >= 0 &&
        c.x + c.width <= canvasWidth &&
        c.y + c.height <= canvasHeight);
    if (layoutOk) {
      feedbackList
          .add("✅ All components fit well within the canvas. Nice layout!");
    } else {
      feedbackList.add(
          "⚠️ Some components extend beyond the canvas. Try adjusting their position.");
    }

    // Bottom Nav Placement
    double bottomThreshold = canvasHeight * 0.75;
    bool navAtBottom = components.any(
        (c) => c.type == 'BottomNavBar' && (c.y + c.height) >= bottomThreshold);
    if (navAtBottom) {
      feedbackList.add(
          "✅ Bottom navigation is well-placed toward the bottom of the screen.");
    } else {
      feedbackList.add(
          "⚠️ Consider placing the Bottom Navigation at the bottom for better usability.");
    }

    // Search & Filter at Top
    bool searchAtTop = components
        .any((c) => c.type == 'SearchBarUI' && c.y < canvasHeight * 0.3);
    bool filterAtTop = components
        .any((c) => c.type == 'FilterTabs' && c.y < canvasHeight * 0.4);
    if (searchAtTop && filterAtTop) {
      feedbackList.add(
          "✅ Search and filter components are appropriately placed near the top.");
    } else {
      feedbackList.add(
          "⚠️ Place Search Bar and Filters near the top where users expect them.");
    }

    // Alignment Check (Product Items)
    final productCards = components
        .where((c) => c.type == 'ProductCard' || c.type == 'ProductGridItem')
        .toList();
    bool alignedX = _isAlignedHorizontally(productCards);
    bool alignedY = _isAlignedVertically(productCards);

    if (alignedX || alignedY) {
    } else {
      feedbackList.add(
          "⚠️ Product items seem misaligned. Try organizing them in a grid-like structure.");
    }

    // Even Spacing
    if (_hasConsistentSpacing(productCards)) {
    } else {
      feedbackList.add(
          "⚠️ Try to use even spacing between items for a more balanced layout.");
    }

    // Final Feedback
    String feedback =
        "${feedbackList.join("\n")}";
    onResult(feedback);
  }

  bool _isAlignedHorizontally(List<UIComponent> components) {
    const tolerance = 10.0;
    List<double> xValues = components.map((c) => c.x).toList();
    for (int i = 0; i < xValues.length; i++) {
      for (int j = i + 1; j < xValues.length; j++) {
        if ((xValues[i] - xValues[j]).abs() > tolerance) return false;
      }
    }
    return true;
  }

  bool _isAlignedVertically(List<UIComponent> components) {
    const tolerance = 10.0;
    List<double> yValues = components.map((c) => c.y).toList();
    for (int i = 0; i < yValues.length; i++) {
      for (int j = i + 1; j < yValues.length; j++) {
        if ((yValues[i] - yValues[j]).abs() > tolerance) return false;
      }
    }
    return true;
  }

  bool _hasConsistentSpacing(List<UIComponent> components) {
    if (components.length < 2) return true;
    List<double> sortedX = components.map((c) => c.x).toList()..sort();
    List<double> gaps = [];
    for (int i = 1; i < sortedX.length; i++) {
      gaps.add((sortedX[i] - sortedX[i - 1]).abs());
    }
    double avgGap = gaps.reduce((a, b) => a + b) / gaps.length;
    return gaps.every((gap) => (gap - avgGap).abs() <= 10);
  }
}
