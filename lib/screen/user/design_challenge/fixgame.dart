// FixTheUIGame - Spot Heuristic Violations (Product Page Scenario - Revised)
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(const FixTheUIGame());

class FixTheUIGame extends StatelessWidget {
  const FixTheUIGame({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.fredokaTextTheme(),
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
      ),
      home: const HeuristicChallengeScreen(),
    );
  }
}

class HeuristicViolation {
  final Rect area;
  final String heuristic;
  final String explanation;

  HeuristicViolation({
    required this.area,
    required this.heuristic,
    required this.explanation,
  });
}

class HeuristicChallengeScreen extends StatefulWidget {
  const HeuristicChallengeScreen({super.key});

  @override
  State<HeuristicChallengeScreen> createState() => _HeuristicChallengeScreenState();
}

class _HeuristicChallengeScreenState extends State<HeuristicChallengeScreen> {
  int score = 0;

  final List<HeuristicViolation> violations = [
    HeuristicViolation(
      area: Rect.fromLTWH(30, 100, 330, 60),
      heuristic: 'Match between system and real world',
      explanation: '“Popular” is vague. Use terms like “Bestsellers” that better match user expectations.',
    ),
    HeuristicViolation(
      area: Rect.fromLTWH(30, 180, 330, 60),
      heuristic: 'Consistency and standards',
      explanation: 'Search icon looks like a microphone. Use standard magnifying glass icon.',
    ),
    HeuristicViolation(
      area: Rect.fromLTWH(30, 270, 160, 160),
      heuristic: 'Visibility of system status',
      explanation: 'There is no visual feedback when adding an item to cart.',
    ),
    HeuristicViolation(
      area: Rect.fromLTWH(200, 270, 160, 160),
      heuristic: 'Error prevention',
      explanation: 'Adding item to cart has no undo or confirmation.',
    ),
    HeuristicViolation(
      area: Rect.fromLTWH(0, 480, 390, 60),
      heuristic: 'Recognition rather than recall',
      explanation: 'The active page is not indicated in the bottom navigation bar.',
    ),
  ];

  final List<String> heuristics = [
    'Visibility of system status',
    'Match between system and real world',
    'User control and freedom',
    'Consistency and standards',
    'Error prevention',
    'Recognition rather than recall',
  ];

  final Set<Rect> resolvedAreas = {};

  void handleTap(Offset position) {
    for (var v in violations) {
      if (v.area.contains(position) && !resolvedAreas.contains(v.area)) {
        _showHeuristicDialog(v);
        return;
      }
    }
  }

  void _showHeuristicDialog(HeuristicViolation violation) {
    String? selected;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Which heuristic rule is violated?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: heuristics.map((rule) {
              return RadioListTile<String>(
                title: Text(rule),
                value: rule,
                groupValue: selected,
                onChanged: (value) => setState(() => selected = value),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showResultDialog(selected == violation.heuristic, violation);
                if (selected == violation.heuristic) {
                  setState(() {
                    score++;
                    resolvedAreas.add(violation.area);
                  });
                }
              },
              child: const Text("Submit"),
            )
          ],
        ),
      ),
    );
  }

  void _showResultDialog(bool correct, HeuristicViolation violation) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(correct ? '✅ Correct!' : '❌ Incorrect'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(violation.explanation, style: const TextStyle(height: 1.5)),
            const SizedBox(height: 12),
            Text('This violates the heuristic: ${violation.heuristic}',
                style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => handleTap(details.localPosition),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text("Fix the UI: Product Page"),
        ),
        body: Stack(
          children: [
            const Positioned(
              left: 30,
              top: 20,
              child: Text("🛍️ Product Page (Tap what's wrong):",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            // FilterTabs with unclear label
            Positioned(
              left: 30,
              top: 100,
              child: Container(
                width: 330,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Popular"),
                    Text("New"),
                    Text("All"),
                  ],
                ),
              ),
            ),
            // SearchBar with wrong icon
            Positioned(
              left: 30,
              top: 180,
              child: Container(
                width: 330,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(Icons.mic), // Wrong icon for search
                    ),
                    Text("Type here")
                  ],
                ),
              ),
            ),
            // Product Card - no feedback
            Positioned(
              left: 30,
              top: 270,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(child: Text("👕 T-Shirt - \$20")),
              ),
            ),
            // Product Card - no undo
            Positioned(
              left: 200,
              top: 270,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Center(child: Text("👟 Shoes - \$40")),
              ),
            ),
            // Bottom Navigation - no highlight
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 60,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(Icons.home, color: Colors.grey),
                    Icon(Icons.shopping_cart, color: Colors.grey),
                    Icon(Icons.person, color: Colors.grey),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 70,
              left: 20,
              child: Text("Score: $score/5",
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrange)),
            )
          ],
        ),
      ),
    );
  }
}