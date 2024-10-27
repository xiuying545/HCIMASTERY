import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final List<Quiz> quizzes;
  final int questionIndex;

  const QuizPage({super.key, required this.quizzes, required this.questionIndex});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int currentQuestionIndex;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.questionIndex; // Initialize currentQuestionIndex here
  }

  @override
  Widget build(BuildContext context) {
    print("Number of quizzes: ${widget.quizzes.length}");

    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    String quizId = widget.quizzes[currentQuestionIndex].quizzID ?? '-1';
    List<String> choice = ['A', 'B', 'C', 'D'];

    return Scaffold(
      body: Container(
        color: const Color(0xFF6a5ae0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Quiz',
                        style: GoogleFonts.rubik(fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.quizzes[currentQuestionIndex].question,
                        style: GoogleFonts.rubik(fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      FutureBuilder<int>(
                        future: quizViewModel.getUserAnswer(
                          1,
                          widget.quizzes[currentQuestionIndex].chapter,
                          widget.quizzes[currentQuestionIndex].quizzID ?? '-1',
                        ),
                        builder: (context, snapshot) {
                          // If the future is still loading
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          }

                          // If there's an error
                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }

                          int userAnswer = snapshot.data ?? -1;

                          // Ensure the currentQuestionIndex is valid before rendering
                          if (currentQuestionIndex < widget.quizzes.length) {
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: widget.quizzes[currentQuestionIndex].options.length,
                              itemBuilder: (context, index) {
                                // Set color based on user answer
                                Color color = (userAnswer == index)
                                    ? const Color(0xFFfd7e7e) // Color for the selected answer
                                    : const Color(0xFFfeb3b3); // Default color

                                return GestureDetector(
                                  onTap: () {
                                    // Update the answer when the user taps on an option
                                    quizViewModel.saveAnswer(1, widget.quizzes[currentQuestionIndex].chapter, quizId, index);
                                    updateQuestionIndex();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: color,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: const Color(0xFFfd7e7e),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            child: Text(
                                              choice[index],
                                              style: GoogleFonts.rubik(fontSize: 24.0, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            child: AutoSizeText(
                                              widget.quizzes[currentQuestionIndex].options[index],
                                              style: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w400),
                                              minFontSize: 10,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          // If currentQuestionIndex is out of bounds, return an empty Container
                          return Container();
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: currentQuestionIndex > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentQuestionIndex > 0) {
                                      currentQuestionIndex--;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 1,
                                  side: const BorderSide(color: Color(0xFF6a5ae0), width: 2),
                                  shadowColor: Colors.transparent,
                                  shape: const CircleBorder(),
                                  minimumSize: const Size(50, 50),
                                ),
                                child: const Icon(Icons.arrow_back_ios, color: Color(0xFF6a5ae0)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 1,
                                side: const BorderSide(color: Color(0xFF6a5ae0), width: 2),
                                shadowColor: Colors.transparent,
                                shape: const CircleBorder(),
                                minimumSize: const Size(50, 50),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentQuestionIndex < widget.quizzes.length - 1) {
                                    currentQuestionIndex++;
                                  } else {
                                    _showCompletionDialog(context);
                                  }
                                });
                              },
                              child: Icon(
                                currentQuestionIndex == widget.quizzes.length - 1 ? Icons.check : Icons.arrow_forward_ios,
                                color: const Color(0xFF6a5ae0),
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

  void updateQuestionIndex() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        if (currentQuestionIndex < widget.quizzes.length - 1) {
          currentQuestionIndex++;
        } else {
          _showCompletionDialog(context);
        }
      });
    });
  }

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
              // You can add navigation or reset logic here
            },
          ),
        ],
      ),
    );
  }
}
