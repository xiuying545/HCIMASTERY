// Shared Base Class
import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/components_profile.dart';
import 'package:google_fonts/google_fonts.dart';

// ------------------ Product Card ------------------
class ProductCard extends UIComponent {
  final Map<String, String> selectedProduct;

  static int productIndex = 0;

  static final List<Map<String, String>> productList = [
    {
      'image': 'assets/Animation/tshirt.png',
      'name': 'T-Shirt',
      'price': '\$20'
    },
    {'image': 'assets/Animation/shoes.png', 'name': 'Shoes', 'price': '\$40'},
    {'image': 'assets/Animation/hat.png', 'name': 'Hat', 'price': '\$15'},
    {'image': 'assets/Animation/skirt.png', 'name': 'Skirt', 'price': '\$50'},
  ];

  ProductCard()
      : selectedProduct = productList[productIndex],
        super(
          type: 'ProductCard',
          text: productList[productIndex]['name']!,
          fontSize: 14,
          color: Colors.black,
          x: 40,
          y: 140,
        ) {
    productIndex = (productIndex + 1) % productList.length;
  }

  @override
  Widget buildWidget(BuildContext context) {
    return wrapWithSizeUpdater(_ProductCardWidget(product: selectedProduct));
  }
}

class _ProductCardWidget extends StatelessWidget {
  final Map<String, String> product;
  const _ProductCardWidget({required this.product});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth * 0.4,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFDEB8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: screenWidth * 0.18,
            height: screenWidth * 0.18,
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                product['image']!,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product['name']!,
            style: GoogleFonts.fredoka(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(product['price']!,
              style: const TextStyle(color: Colors.deepOrange, fontSize: 15)),
        ],
      ),
    );
  }
}

// ------------------ Search Bar ------------------
class SearchBarUI extends UIComponent {
  SearchBarUI()
      : super(
          type: 'SearchBarUI',
          text: 'Search',
          fontSize: 16,
          color: Colors.grey.shade600,
          x: 40,
          y: 80,
        );

  @override
  Widget buildWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return wrapWithSizeUpdater(Container(
      width: screenWidth * 0.9,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Text(
            text,
            style: GoogleFonts.fredoka(
              fontSize: fontSize.toDouble(),
              color: color,
            ),
          ),
        ],
      ),
    ));
  }
}

// ------------------ Filter Tabs ------------------
class FilterTabs extends UIComponent {
  FilterTabs()
      : super(
          type: 'FilterTabs',
          text: '',
          color: Colors.black,
          x: 40,
          y: 150,
        );

  @override
  Widget buildWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return wrapWithSizeUpdater(Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildTab("All", Colors.orange, true),
          _buildTab("Popular", Colors.amber.shade100, false),
          _buildTab("New", Colors.blue.shade100, false),
        ],
      ),
    ));
  }

  Widget _buildTab(String label, Color color, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: selected ? color : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.fredoka(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}

class BottomNavBar extends UIComponent {
  BottomNavBar()
      : super(
          type: 'BottomNavBar',
          text: '',
          fontSize: 14,
          x: 0,
          y: 450,
          width: 360,
          height: 80,
        );

  @override
  Widget buildWidget(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return wrapWithSizeUpdater(
      Container(
        width: screenWidth,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade400,
              blurRadius: 4,
              offset: const Offset(0, -2),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildNavItem(Icons.home_rounded, 'Home', Colors.blue),
            _buildNavItem(Icons.shopping_cart_rounded, 'Cart', Colors.grey),
            _buildNavItem(Icons.person_rounded, 'Profile', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
