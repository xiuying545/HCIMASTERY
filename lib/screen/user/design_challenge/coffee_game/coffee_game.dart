import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/feedback_screen.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_A.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_B.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeGame extends StatelessWidget {
  const CoffeeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9F4E8),
body: Stack(
  children: [
    // Background + content
    Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/Animation/coffeebackground.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                ' Coffee Fun \nGame ',
                textAlign: TextAlign.center,
                style: GoogleFonts.fredoka(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5A3410),
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                "assets/Animation/coffee.png",
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 30),
              Text(
                'Try two cute coffee ordering flows and tell us which is better! ☕',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.brown[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink[200],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Start Flow A',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FlowAScreen()),
                  );
                },
              ),
              SizedBox(height: 20),
              // Add Flow B button here if needed
            ],
          ),
        ),
      ),
    ),

    // Top-left floating button (e.g., back or info)
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
),);
  }
}
