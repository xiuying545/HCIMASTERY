import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class DesignChallengesPage extends StatelessWidget {
  final List<Map<String, dynamic>> challenges = [
    {
      "title": "Design a Profile Page ",
      "description": "Spot the Design Flaws! Fix Usability!",
      "icon": Icons.brush,
      "color": Colors.orange.shade400,
      "routes": "/practicalExercise/profilePage"
    },
    {
      "title": "Design a Product List Page",
      "description": "Add Suitable Component into product list page",
      "icon": Icons.graphic_eq,
      "color": Colors.green.shade400,
      "routes": "/practicalExercise/productgame"
    },
    {
      "title": "A/B Testing",
      "description": "Learn how to do A/B Testing",
      "icon": Icons.auto_awesome,
      "color": Colors.purple.shade400,
      "routes": "/practicalExercise/coffeegame"
    },
  ];

   DesignChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffFFF9F0),
        body: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                child: Image.asset(
                  'assets/Animation/gamelogo.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                bottom: -50,
                right: -80,
                child: Image.asset(
                  'assets/Animation/design3.png',
                  width: 300,
                  height: 300,
                ),
              ),
              Positioned(
                bottom: -50,
                left: -80,
                child: Image.asset(
                  'assets/Animation/design2.png',
                  width: 300,
                  height: 300,
                ),
              ),
              Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.width*0.5 ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: challenges.length,
                      itemBuilder: (context, index) {
                        final challenge = challenges[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: challenge["color"],
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20),
                            onTap: () {
                              GoRouter.of(context).push(challenge["routes"]);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  Icon(
                                    challenge["icon"],
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          challenge["title"],
                                          style: GoogleFonts.comicNeue(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          challenge["description"],
                                          style: GoogleFonts.comicNeue(
                                            fontSize: 16,
                                            color:
                                                Colors.white.withOpacity(0.9),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
