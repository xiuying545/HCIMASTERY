import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0; // Track current question index

  // Sample quiz data
  final List<Map<String, Object>> questions = [
    {
      'questionText': 'What is the capital of France?',
      'options': [
        'BerlinBerlinBerlinBerlinBerlinBerlinBerlinBerlin',
        'London',
        'Paris',
        'Rome'
      ],
    },
    {
      'questionText': 'What is 2 + 2?',
      'options': ['3', '4', '5', '6'],
    },
    {
      'questionText': 'What is the capital of Malaysia?',
      'options': ['Bangkok', 'Kuala Lumpur', 'Jakarta', 'Manila'],
    },
  ];

  List<String> choice = ['A', 'B', 'C', 'D'];

  // This list will store the selected answer for each question
  List<int?> selectedAnswers = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list with null values (no answers selected yet)
    selectedAnswers = List<int?>.filled(questions.length, null);
  }

  // Function to handle answer selection
  void _selectAnswer(int selectedIndex) {
    // Set the selected answer immediately
    setState(() {
      selectedAnswers[currentQuestionIndex] = selectedIndex;
    });

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        if (currentQuestionIndex + 1 != questions.length) {
          currentQuestionIndex++;
        } else {
          // Quiz is complete; you can handle the end of the quiz here if necessary
          _showCompletionDialog(context);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        backgroundColor:
            const Color(0xFF6a5ae0), // Set AppBar color to match the background
      ),
      body: Container(
        color: const Color(0xFF6a5ae0), // Set the background color of the body
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.end, // Align children to the bottom
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Question ${currentQuestionIndex + 1}',
                        style: GoogleFonts.rubik(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        questions[currentQuestionIndex]['questionText']
                            as String,
                        style: GoogleFonts.rubik(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      ListView.builder(
                        shrinkWrap: true, // Prevent overflow
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: (questions[currentQuestionIndex]['options']
                                as List<String>)
                            .length,
                        itemBuilder: (context, index) {
                          List<String> options = questions[currentQuestionIndex]
                              ['options'] as List<String>;
                          return Column(
                            children: <Widget>[
                              GestureDetector(
                                  onTap: () {
                                    _selectAnswer(index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 5),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 100),
                                      curve: Curves.easeInOut,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: selectedAnswers[
                                                    currentQuestionIndex] ==
                                                index
                                            ? const Color(0xFFfd7e7e)
                                            : const Color(0xFFfeb3b3),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: const Color(0xFFfd7e7e)),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10,
                                                      horizontal: 15),
                                              child: Text(
                                                choice[index],
                                                style: GoogleFonts.rubik(
                                                  fontSize: 24.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10,
                                                        horizontal: 15),
                                                child: AutoSizeText(
                                                  options[index],
                                                  style: GoogleFonts.rubik(
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                  minFontSize: 10,
                                                  maxLines: 2,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                  )),
                            ],
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Back Button
                          Visibility(
                            visible: currentQuestionIndex > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    currentQuestionIndex--;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 1,
                                  side: const BorderSide(
                                      color: Color(0xFF6a5ae0), width: 2),
                                  shadowColor: Colors.transparent,
                                  shape:
                                      const CircleBorder(), // Set to CircleBorder for circular buttons
                                  minimumSize: const Size(50, 50),
                                ),
                                child: const Icon(Icons.arrow_back_ios,
                                    color: Color(0xFF6a5ae0)),
                              ),
                            ),
                          ),
                          // Next Button
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 1,
                                side: const BorderSide(
                                    color: Color(0xFF6a5ae0), width: 2),
                                shadowColor: Colors.transparent,
                                shape:
                                    const CircleBorder(), // Set to CircleBorder for circular buttons
                                minimumSize: const Size(50, 50),
                              ),
                              onPressed: () {
                                if (currentQuestionIndex <
                                    questions.length - 1) {
                                  setState(() {
                                    currentQuestionIndex++;
                                  });
                                } else {
                                  // Show dialog or perform action on quiz completion
                                  _showCompletionDialog(context);
                                }
                              },
                              child: Icon(
                                currentQuestionIndex == questions.length - 1
                                    ? Icons
                                        .check // Check icon if it's the last question
                                    : Icons
                                        .arrow_forward_ios, // Back icon otherwise
                                color: const Color(
                                    0xFF6a5ae0), // Set the icon color
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a completion dialog
  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: const Text('You have completed the quiz!'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
