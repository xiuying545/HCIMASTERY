
  import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Color getBubbleColor(IconData icon) {
    if (icon == Icons.person) return const Color(0xFFD8EAF7); // Name
    if (icon == Icons.person_outline)
      return const Color(0xFFDDEBFB); // Username
    if (icon == Icons.phone) return const Color(0xFFE3F2DB); // Phone
    if (icon == Icons.email) return const Color(0xFFFADADA); // Email
    return const Color(0xFFF3F3F3);
  }

  Color getIconColor(IconData icon) {
    if (icon == Icons.person) return const Color(0xFF4D7FA9); // Name
    if (icon == Icons.person_outline)
      return const Color(0xFF4C6A92); // Username
    if (icon == Icons.phone) return const Color(0xFF5B8B57); // Phone
    if (icon == Icons.email) return const Color(0xFFB85667); // Email
    return Colors.black54;
  }


   final List<Color> pastelColors = [
  Colors.pink.shade200,
  Colors.lightBlue.shade200,
  Colors.green.shade200,
  Colors.amber.shade200,
  Colors.deepPurple.shade200,
  Colors.orange.shade200,
  Colors.teal.shade200,
  Colors.indigo.shade200,
  Colors.cyan.shade200,
  Colors.red.shade200,
  Colors.purple.shade100,
  Colors.lime.shade200,
  Colors.yellow.shade200,
  Colors.blueGrey.shade200,
  Colors.brown.shade200,
];


  Widget buildRoundedButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
    required BuildContext context
  }) {
   return SizedBox(
  width: MediaQuery.of(context).size.width*0.4, // <- set your desired width here
  child: ElevatedButton.icon(
    onPressed: onTap,
    icon: Icon(icon, color: Colors.white, size: 18),
    label: Text(
      label,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(vertical: 14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 1,
    ),
  ),
);
  }
