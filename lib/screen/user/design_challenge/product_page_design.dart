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
  OverlayEntry? overlayEntry;
  bool showOverlay = false;
  @override
  void initState() {
    super.initState();
    components = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          buildCanvasBody(),

          // Top-left button like AppBar back button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.brown, size: 28),
              onPressed: () {
                if (showOverlay) {
                  _toggleOverlay();
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
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
            _buildNavItem(
              icon: showOverlay ? Icons.close : Icons.add,
              label: showOverlay ? 'Close' : 'Add',
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
    setState(() {
      showOverlay = !showOverlay;
    });

    if (showOverlay) {
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
          }
        });
        _toggleOverlay();
      },
      tooltip: type,
    );
  }

  @override
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

  @override
  void submitDesign(
      void Function(List<Map<String, String>> feedback) onResult) {
    int total = components.length;

    if (total == 0) {
      onResult([
        {
          "text":
              "⚠️ Try dragging in some UI components to start your design . You're creating a product listing page where users can easily find, view product, and navigate to other sections.",
          "image": "assets/Game/empty.png",
        }
      ]);
      return;
    }

    List<Map<String, String>> feedbackList = [];

    // Missing Required Elements
    final hasSearchBar = components.any((c) => c.type == 'SearchBarUI');
    final hasFilter = components.any((c) => c.type == 'FilterTabs');
    final hasProduct = components
        .any((c) => c.type == 'ProductCard' || c.type == 'ProductGridItem');
    final hasNav = components.any((c) => c.type == 'BottomNavBar');

    List<String> missing = [];
    if (!hasSearchBar) missing.add("Search Bar");
    if (!hasFilter) missing.add("Filter Tabs");
    if (!hasProduct) missing.add("Product Item");
    if (!hasNav) missing.add("Bottom Navigation");

    if (missing.isNotEmpty) {
      feedbackList.add({
        "text": "⚠️ You're missing some key components: ${missing.join(", ")}.",
        "image": "assets/Game/missingcomponent.png"
      });
    }

    // Layout Boundaries
    bool layoutOk = components.every((c) =>
        c.x >= 0 &&
        c.y >= 0 &&
        c.x + c.width <= canvasWidth &&
        c.y + c.height <= canvasHeight);

    if (!layoutOk) {
      feedbackList.add({
        "text":
            "⚠️ Some components extend beyond the canvas. Try adjusting their position.",
        "image": "assets/Game/withinscreen.png"
      });
    }

    // Bottom Navigation Placement
    double bottomThreshold = canvasHeight * 0.75;
    bool navAtBottom = components.any(
      (c) => c.type == 'BottomNavBar' && (c.y + c.height) >= bottomThreshold,
    );

    if (!navAtBottom) {
      feedbackList.add({
        "text":
            "⚠️ Consider placing the Bottom Navigation at the bottom for better usability.",
        "image": "assets/Game/layout.png"
      });
    }

    // Search & Filter at Top
    bool searchAtTop = components
        .any((c) => c.type == 'SearchBarUI' && c.y < canvasHeight * 0.3);
    bool filterAtTop = components
        .any((c) => c.type == 'FilterTabs' && c.y < canvasHeight * 0.4);

    if (!searchAtTop || !filterAtTop) {
      feedbackList.add({
        "text":
            "⚠️ Place Search Bar and Filters near the top where users expect them.",
        "image": "assets/Game/topbar_hint.png"
      });
    }

    // Product Alignment
    final productCards =
        components.where((c) => c.type == 'ProductCard').toList();

    if (!(_isAlignedHorizontally(productCards) ||
        _isAlignedVertically(productCards))) {
      feedbackList.add({
        "text":
            "⚠️ Product items seem misaligned. Try organizing them in a grid-like structure.",
        "image": "assets/Game/misaligned.png"
      });
    }

    // Even Spacing
    if (!_hasConsistentSpacing(productCards)) {
      feedbackList.add({
        "text":
            "⚠️ Try to use even spacing between items for a more balanced layout.",
        "image": "assets/Game/spacing.png"
      });
    }
    if (feedbackList.isEmpty) {
      feedbackList.add({
        'text':
            "Well done! Your design looks great overall. HCI reminds us that users don’t read manuals — they rely on design to guide them. Make every element speak for itself. 🎉",
      });
    }
    onResult(feedbackList);
  }

  void printComponentPositions(List<UIComponent> components) {
    for (var c in components) {
      print('Component at x: ${c.x}, y: ${c.y}');
    }
  }

  bool _isAlignedHorizontally(List<UIComponent> components) {
    const rowTolerance = 50.0;
    const alignTolerance = 10.0;
    for (var row in _groupByRow(components, rowTolerance)) {
      double referenceY = 0;
      print(row.length);
      for (var c in row) {
        if (referenceY == 0) {
          referenceY = c.y;
          print('referenceY $referenceY');
        } else {
          if ((c.y - referenceY).abs() > alignTolerance) return false;
          print((c.y - referenceY).abs());
        }
      }
    }
    return true;
  }

  bool _isAlignedVertically(List<UIComponent> components) {
    const columnTolerance = 100.0;
    const alignTolerance = 10.0;
    for (var col in _groupByColumn(components, columnTolerance)) {
      double? referenceX;
      for (var c in col) {
        referenceX ??= c.x;
        if ((c.x - referenceX).abs() > alignTolerance) return false;
      }
    }
    return true;
  }

  bool _hasConsistentSpacing(List<UIComponent> components) {
    const spacingTolerance = 10.0;
    for (var row in _groupByRow(components, 10.0)) {
      final sorted = row..sort((a, b) => a.x.compareTo(b.x));
      final gaps = <double>[];
      for (int i = 1; i < sorted.length; i++) {
        gaps.add(sorted[i].x - sorted[i - 1].x);
      }
      if (gaps.isEmpty) continue;
      final avgGap = gaps.reduce((a, b) => a + b) / gaps.length;
      if (!gaps.every((gap) => (gap - avgGap).abs() <= spacingTolerance)) {
        return false;
      }
    }
    return true;
  }

  List<List<UIComponent>> _groupByRow(
      List<UIComponent> components, double threshold) {
    components.sort((a, b) => a.y.compareTo(b.y));
    List<List<UIComponent>> rows = [];

    for (var comp in components) {
      bool added = false;
      for (var row in rows) {
        if ((row.first.y - comp.y).abs() <= threshold) {
          row.add(comp);
          added = true;
          break;
        }
      }
      if (!added) {
        rows.add([comp]);
      }
    }

// Print rows with components
    for (int i = 0; i < rows.length; i++) {
      print('🔹 Row $i contains:');
      for (var comp in rows[i]) {
        print('   → Component: x=${comp.x}, y=${comp.y}');
      }
    }

    return rows;
  }

  List<List<UIComponent>> _groupByColumn(
      List<UIComponent> components, double threshold) {
    components.sort((a, b) => a.x.compareTo(b.x));
    List<List<UIComponent>> cols = [];
    for (var comp in components) {
      final col = cols.firstWhere(
        (c) => (c.first.x - comp.x).abs() <= threshold,
        orElse: () {
          cols.add([comp]);
          return cols.last;
        },
      );
      if (!col.contains(comp)) col.add(comp);
    }
    return cols;
  }
}
