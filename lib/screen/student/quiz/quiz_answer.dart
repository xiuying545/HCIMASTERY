import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common_widget/app_bar_with_back.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
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
  List<String> choice = ['A', 'B', 'C', 'D'];
  late Quiz quiz;
  late String currentQuizID;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    currentQuizID = widget.quizzID;
    quiz = quizViewModel.quizzes.firstWhere(
      (quiz) => quiz.quizzID == currentQuizID,
    );
  }

  void navigateToNextQuiz() {
    int currentIndex = quizViewModel.quizzes.indexOf(quiz);
    if (currentIndex != -1 && currentIndex < quizViewModel.quizzes.length - 1) {
      Quiz nextQuiz = quizViewModel.quizzes[currentIndex + 1];
      setState(() {
        quiz = nextQuiz;
        currentQuizID = nextQuiz.quizzID!;
      });
    }
  }

  void navigateToPreviousQuiz() {
    int currentIndex = quizViewModel.quizzes.indexOf(quiz);
    if (currentIndex > 0) {
      Quiz previousQuiz = quizViewModel.quizzes[currentIndex - 1];
      setState(() {
        quiz = previousQuiz;
        currentQuizID = previousQuiz.quizzID!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = quizViewModel.quizzes.indexOf(quiz);
    bool isFirstQuiz = currentIndex == 0;
    bool isLastQuiz = currentIndex == quizViewModel.quizzes.length - 1;

    return Scaffold(
      appBar:  AppBarWithBackBtn(
        title: 'Question ${currentIndex + 1}',
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
                        fontSize: 19.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    quiz.imageUrl != null
                        ? Image.network(
                            quiz.imageUrl!,
                            width: 400,
                            height: 200,
                          )
                        : const SizedBox.shrink(),
                    // Options List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quiz.options.length,
                      itemBuilder: (context, index) {
                        Color optionColor;
                        if (index == quiz.answer) {
                          optionColor = Colors.green; // Correct answer
                        } else if (index ==
                                quizViewModel.cachedAnswers[currentQuizID] &&
                            index != quiz.answer) {
                          optionColor = Colors.red; // Incorrect answer
                        } else {
                          optionColor = Colors.blue.shade100
                              .withOpacity(0.5); // Default option color
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
                                        maxLines: 3,
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
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: isFirstQuiz ? null : navigateToPreviousQuiz,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700.withOpacity(0.9),
                        elevation: 4,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700.withOpacity(0.9),
                        elevation: 4,
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: isLastQuiz ? null : navigateToNextQuiz,
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
