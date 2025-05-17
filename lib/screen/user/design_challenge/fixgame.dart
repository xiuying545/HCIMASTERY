import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() => runApp(FixTheUIGame());

class FixTheUIGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FixUIChallengeScreen(),
    );
  }
}

class FixUIChallengeScreen extends StatefulWidget {
  @override
  _FixUIChallengeScreenState createState() => _FixUIChallengeScreenState();
}

class _FixUIChallengeScreenState extends State<FixUIChallengeScreen> {
  int score = 0;
  String feedbackText = '';
  String userInput = '';
  int currentLevel = 0;

  final List<String> levels = ['label', 'back', 'feedback'];
  final Map<String, String> prompts = {
    'label': "The button says 'Do it'. Suggest a better label.",
    'back': "The back button says 'Go'. Suggest a clearer label.",
    'feedback': "There's no confirmation after submission. Suggest a feedback message.",
  };

  final Map<String, String> hints = {
    'label': 'e.g., Confirm Order',
    'back': 'e.g., Back to Cart',
    'feedback': 'e.g., Order placed successfully!'
  };

  void showFixDialog(String issueType) {
    userInput = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text("🛠 Fix the Issue", style: GoogleFonts.fredoka()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(prompts[issueType] ?? 'Suggest an improvement.',
                style: GoogleFonts.fredoka()),
            SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: hints[issueType] ?? 'Your suggestion',
              ),
              onChanged: (value) => userInput = value,
            ),
            SizedBox(height: 8),
            TextButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("💡 Hint: ${hints[issueType]}"),
                    backgroundColor: Colors.orange[200],
                  ),
                );
              },
              icon: Icon(Icons.lightbulb_outline),
              label: Text("Need a hint?", style: GoogleFonts.fredoka()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              evaluateInput(issueType);
            },
            child: Text("Submit", style: GoogleFonts.fredoka()),
          ),
        ],
      ),
    );
  }

  void evaluateInput(String issueType) {
    String input = userInput.toLowerCase();
    String feedback;
    bool isCorrect = false;

    switch (issueType) {
      case 'label':
        isCorrect = input.contains("confirm") || input.contains("submit") || input.contains("place order");
        break;
      case 'back':
        isCorrect = input.contains("back") || input.contains("return") || input.contains("cart");
        break;
      case 'feedback':
        isCorrect = input.contains("success") || input.contains("placed") || input.contains("completed");
        break;
    }

    if (input.trim().isEmpty) {
      feedback = "⚠️ Oops! You didn’t enter anything. Try again! 😊";
    } else if (isCorrect) {
      feedback = "🎯 Nailed it! That’s a much better UX choice! 🎉";
      score++;
      goToNextLevel();
    } else {
      feedback = "🤔 Hmm… maybe try something clearer or more user-friendly? 💡";
    }

    setState(() => feedbackText = feedback);
  }

  void goToNextLevel() {
    if (currentLevel < levels.length - 1) {
      setState(() {
        currentLevel++;
        feedbackText = '';
      });
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SummaryScreen(score: score)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String issue = levels[currentLevel];

    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("🎯 Fix the UI Challenge - Level ${currentLevel + 1}",
            style: GoogleFonts.fredoka()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (currentLevel + 1) / levels.length,
              backgroundColor: Colors.orange[100],
              color: Colors.deepOrange,
            ),
            SizedBox(height: 24),
            Text("🛒 Mock Checkout UI:",
                style: GoogleFonts.fredoka(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 6,
                    offset: Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text("Enter your shipping address",
                      style: GoogleFonts.fredoka()),
                  SizedBox(height: 24),

                  if (issue == 'label')
                    GestureDetector(
                      onTap: () => showFixDialog('label'),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text("Do it", style: GoogleFonts.fredoka()),
                      ),
                    ),

                  if (issue == 'back')
                    GestureDetector(
                      onTap: () => showFixDialog('back'),
                      child: TextButton(
                        onPressed: () {},
                        child: Text("Go", style: GoogleFonts.fredoka()),
                      ),
                    ),

                  if (issue == 'feedback')
                    GestureDetector(
                      onTap: () => showFixDialog('feedback'),
                      child: Container(
                        height: 40,
                        color: Colors.orange[100],
                        alignment: Alignment.center,
                        child: Text("(Imagine feedback should appear here)",
                            style: GoogleFonts.fredoka()),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text("💬 Feedback:",
                style: GoogleFonts.fredoka(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Container(
              padding: EdgeInsets.all(12),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4)
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.orange),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feedbackText.isEmpty
                          ? "💡 Tap on the highlighted UI element to suggest an improvement."
                          : feedbackText,
                      style: GoogleFonts.fredoka(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
            Center(
              child: Text("🏆 Score: $score",
                  style: GoogleFonts.fredoka(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}

class SummaryScreen extends StatelessWidget {
  final int score;

  const SummaryScreen({required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF3E0),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("🎉 Summary", style: GoogleFonts.fredoka()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events, color: Colors.green, size: 80),
            SizedBox(height: 16),
            Text("Well done!",
                style: GoogleFonts.fredoka(
                    fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("You fixed $score out of 3 issues!",
                style: GoogleFonts.fredoka(fontSize: 18)),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => FixUIChallengeScreen()),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child:
                  Text("Play Again", style: GoogleFonts.fredoka(fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
