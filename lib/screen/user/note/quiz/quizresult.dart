import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatefulWidget {
  final String chapter;

  const QuizResultPage({super.key, required this.chapter});

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
  late Future<void> _quizDataFuture;
  late UserViewModel userViewModel;
  // ignore: prefer_final_fields
  Map<String, int> _userAnswerCache = {};

  @override
  void initState() {
    super.initState();
    _quizDataFuture = _loadQuizData();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  Future<void> _loadQuizData() async {
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    await quizViewModel.fetchQuizzes(widget.chapter);
    await quizViewModel.calculateScore(widget.chapter, userViewModel.userId);
    for (var quiz in quizViewModel.quizzes) {
      final quizId = quiz.quizzID!;
      final userAnswer = await quizViewModel.getUserAnswer(
          userViewModel.userId!, widget.chapter, quizId);
      _userAnswerCache[quizId] = userAnswer;
    }
    print("Current Score: ${quizViewModel.score}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => GoRouter.of(context).push('/studentNav'),
        ),
        title: Text(
          'Chapter ${widget.chapter}',
          style: GoogleFonts.rubik(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade800,
      ),
      body: FutureBuilder<void>(
        future: _quizDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final quizViewModel =
                Provider.of<QuizViewModel>(context, listen: false);

            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(widget.chapter, quizViewModel),
                  const SizedBox(height: 20),
                  Text(
                    "See your answer",
                    style: GoogleFonts.rubik(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildAnswerList(quizViewModel),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildHeader(String chapter, QuizViewModel quizViewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Congratulations, you had scored',
            style: GoogleFonts.rubik(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              // Circular Progress Indicator
             

              // Image on Top
              Positioned(
                top: -60,
                right: -10,
                child: Image.asset(
                  'assets/Animation/congratulation.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: -60,
                left: -10,
                child: Image.asset(
                  'assets/Animation/congratulation.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -70,
                left: -60,
                child: Image.asset(
                  'assets/Animation/congratulation.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: -60,
                right: -60,
                child: Image.asset(
                  'assets/Animation/congratulation.png',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
               Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 70.0,
                      lineWidth: 7.0,
                      percent: quizViewModel.score / 100,
                      center: Container(
                          height:140,
                          width:140,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                       borderRadius: BorderRadius.circular(80)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${(quizViewModel.score / 100 * quizViewModel.quizzes.length).toInt()}",
                              style: GoogleFonts.rubik(
                                fontSize: 35.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "out of ${quizViewModel.quizzes.length}",
                              style: GoogleFonts.rubik(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      progressColor: Colors.white,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      circularStrokeCap: CircularStrokeCap.round,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
Widget _buildAnswerList(QuizViewModel quizViewModel) {
  return Expanded(
    child: ListView.builder(
      itemCount: quizViewModel.quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizViewModel.quizzes[index];
        final isCorrect = quiz.answer == _userAnswerCache[quiz.quizzID];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () async {
              String encodedQuiz = jsonEncode(quiz);
              int? userAnswerIndex = _userAnswerCache[quiz.quizzID];

              if (encodedQuiz.isNotEmpty && userAnswerIndex != null) {
                context.push(
                  '/student/quizAnswer?quizz=$encodedQuiz&userAnswer=$userAnswerIndex',
                );
              }
            },
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Question Number
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Question Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.question,
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isCorrect ? 'Correct Answer' : 'Wrong Answer',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isCorrect ? Colors.green.shade800 : Colors.red.shade800,
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
  );
}

  // Widget _buildAnswerIcon(int index, QuizViewModel quizViewModel) {
  //   final quizId = quizViewModel.quizzes[index].quizzID!;
  //   final userAnswer = _userAnswerCache[quizId];

  //   return Icon(
  //     quizViewModel.quizzes[index].answer == userAnswer
  //         ? Icons.check_circle
  //         : Icons.cancel,
  //     color: quizViewModel.quizzes[index].answer == userAnswer
  //         ? Colors.green
  //         : Colors.red,
  //   );
  // }
}
