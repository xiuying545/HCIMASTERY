import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // Import GoogleFonts

class QuizResultPage extends StatelessWidget {
  final int totalQuestions = 10;
  final int correctAnswers = 8;

  // Sample questions with a correct or incorrect answer
  final List<Map<String, dynamic>> questions = [
    {'text': 'What is the capital of France?', 'isCorrect': true},
    {'text': 'What is 2 + 2?', 'isCorrect': true},
    {'text': 'What is the capital of Germany?', 'isCorrect': false},
    {'text': 'What is 3 * 5?', 'isCorrect': true},
    {'text': 'What is the largest planet?', 'isCorrect': false},
    {'text': 'What is 5 - 3?', 'isCorrect': true},
    {'text': 'What is the chemical symbol for water?', 'isCorrect': true},
    {'text': 'What is the smallest prime number?', 'isCorrect': true},
    {'text': 'What is the capital of Italy?', 'isCorrect': false},
    {'text': 'What is 10 / 2?', 'isCorrect': true},
     {'text': 'What is the capital of France?', 'isCorrect': true},
    {'text': 'What is 2 + 2?', 'isCorrect': true},
    {'text': 'What is the capital of Germany?', 'isCorrect': false},
    {'text': 'What is 3 * 5?', 'isCorrect': true},
    {'text': 'What is the largest planet?', 'isCorrect': false},
    {'text': 'What is 5 - 3?', 'isCorrect': true},
    {'text': 'What is the chemical symbol for water?', 'isCorrect': true},
    {'text': 'What is the smallest prime number?', 'isCorrect': true},
    {'text': 'What is the capital of Italy?', 'isCorrect': false},
    {'text': 'What is 10 / 2?', 'isCorrect': true},
  ];

   QuizResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    double percentage = correctAnswers / totalQuestions;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DashboardPage'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                width: double.infinity,
                color: const Color(0xFF6a5ae0),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Chapter 1',
                        style: GoogleFonts.rubik(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Container(
                            color: const Color(0xFFfeb3b3),
                            child: Row(
                              children: [
                                CircularPercentIndicator(
                                  radius: 45.0, // Size of the circular chart
                                  lineWidth: 7.0, // Thickness of the progress line
                                  percent: percentage, // The percentage of correct answers (0.0 to 1.0)
                                  center: Text(
                                    "$correctAnswers/$totalQuestions",
                                    style: GoogleFonts.rubik(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  progressColor: Colors.white, // The color of the progress bar
                                  backgroundColor: const Color.fromARGB(
                                      255, 190, 192, 193), // The background color of the circle
                                  circularStrokeCap: CircularStrokeCap.round, // Makes the ends of the progress rounded
                                ),
                                const SizedBox(width: 10), // Add some space between the chart and the text
                                Expanded(
                                  child: Text(
                                    "You got $correctAnswers correct out of $totalQuestions questions",
                                    style: GoogleFonts.rubik(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Space between sections
            Text(
              "Your Answers",
              style: GoogleFonts.rubik(
                fontSize: 20.0,
                fontWeight: FontWeight.w500,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Color(0xffefeefb),
                child: ListView.builder(
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${index + 1}. ${questions[index]['text']}', 
                              style: GoogleFonts.rubik(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          // Icon to indicate correctness
                          Icon(
                            questions[index]['isCorrect']
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: questions[index]['isCorrect']
                                ? Colors.green
                                : Colors.red,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

