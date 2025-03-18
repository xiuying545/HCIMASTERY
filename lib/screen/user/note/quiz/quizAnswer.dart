import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizAnswerPage extends StatefulWidget {
  final String quizzID;

  const QuizAnswerPage({
    super.key,
    required this.quizzID,
  });

  @override
  _QuizAnswerPage createState() => _QuizAnswerPage();
}

class _QuizAnswerPage extends State<QuizAnswerPage> {
  late QuizViewModel quizViewModel;
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    List<String> choice = ['A', 'B', 'C', 'D'];
    Quiz quiz = quizViewModel.quizzes.firstWhere(
      (quiz) => quiz.quizzID == widget.quizzID,
    );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.blue.shade700.withOpacity(0.9)),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          'Quiz Answer',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Question Text
                    Text(
                      quiz.question,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Options List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quiz.options.length,
                      itemBuilder: (context, index) {
                        Color optionColor;
                        if (index == quiz.answer) {
                          optionColor = Colors.green; // Correct answer
                        } else if (index == quizViewModel.cachedAnswers[widget.quizzID] && index != quiz.answer) {
                          optionColor = Colors.red; // Incorrect answer
                        } else {
                          optionColor = Colors.blue.shade100.withOpacity(0.5); // Default option color
                        }

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 5, 15),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: optionColor,
                              border: Border.all(
                                color: Colors.blue.shade400.withOpacity(0.9),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.transparent,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 12),
                                      child: Text(
                                        choice[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 10),
                                      child: AutoSizeText(
                                        quiz.options[index],
                                        style: GoogleFonts.poppins(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black,
                                        ),
                                        minFontSize: 10,
                                        maxLines: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}