import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_A.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/flow_B.dart';
import 'package:google_fonts/google_fonts.dart';

class CoffeeGame extends StatelessWidget {
  const CoffeeGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F4E8),
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
                    "Permainan \nKopi Ceria",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF5A3410),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Image.asset(
                      "assets/Animation/coffee.png",
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "Cuba dua aliran tempahan kopi yang comel dan beritahu kami yang mana lebih baik! ☕",
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Mulakan Aliran A',
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink[200],
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text('Mulakan Aliran B',
                          style: GoogleFonts.fredoka(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          )),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const FlowBScreen()),
                        );
                      },
                    ),
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
              icon: const Icon(Icons.arrow_back, color: Colors.brown, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
