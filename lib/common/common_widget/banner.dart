import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomBanner extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomBanner({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     padding:
                //         const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                //     backgroundColor: Colors.white,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(10),
                //     ),
                //   ),
                //   onPressed: onPressed,
                //   child: Text(
                //     "Explore",
                //     style: GoogleFonts.poppins(
                //       fontSize: 14,
                //       fontWeight: FontWeight.bold,
                //       color: Colors.blue.shade900,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Positioned(
            bottom:-20,
            right: -20,
            child: Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
