import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatefulWidget {
  final int chapter;

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
    await quizViewModel.calculateScore(widget.chapter,userViewModel.userId);
    for (var quiz in quizViewModel.quizzes) {
      final quizId = quiz.quizzID!;
      final userAnswer =
          await quizViewModel.getUserAnswer(userViewModel.userId!, widget.chapter, quizId);
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
          onPressed: () {
          GoRouter.of(context).push('/studentNav');
          },
        ),
        title: Text(
          'Quiz Result',
          style: GoogleFonts.rubik(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6a5ae0),
      ),
      body: FutureBuilder<void>(
        future: _quizDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While loading data, show a loading indicator
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // If there's an error loading data, show an error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data has been loaded, build the UI
            final quizViewModel =
                Provider.of<QuizViewModel>(context, listen: false);

            return Padding(
              padding: const EdgeInsets.all(25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(widget.chapter, quizViewModel),
                  const SizedBox(height: 20),
                  Text(
                    "Your Answers",
                    style: GoogleFonts.rubik(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
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

  Widget _buildHeader(int chapter, QuizViewModel quizViewModel) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: double.infinity,
        color: const Color(0xFF6a5ae0),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chapter $chapter',
              style: GoogleFonts.rubik(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Container(
                  color: const Color(0xFFfeb3b3),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      CircularPercentIndicator(
                        radius: 45.0,
                        lineWidth: 7.0,
                        percent: quizViewModel.score / 100,
                        center: Text(
                          "${quizViewModel.score}%",
                          style: GoogleFonts.rubik(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        progressColor: Colors.white,
                        backgroundColor:
                            const Color.fromARGB(255, 190, 192, 193),
                        circularStrokeCap: CircularStrokeCap.round,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Great try, keep going up",
                          textAlign: TextAlign.center,
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
    );
  }

  Widget _buildAnswerList(QuizViewModel quizViewModel) {
    return Expanded(
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        child: Container(
          color: const Color(0xffefeefb),
          padding: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: quizViewModel.quizzes.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () async {
                  String encodedQuiz = jsonEncode(quizViewModel.quizzes[index]);
                  int? userAnswerIndex =
                      _userAnswerCache[quizViewModel.quizzes[index].quizzID];

                  // await quizViewModel.getUserAnswer(
                  //     1, widget.chapter, quizViewModel.quizzes[index].quizzID!);

                  // ignore: unnecessary_null_comparison
                  if (encodedQuiz.isNotEmpty && userAnswerIndex != null) {
                    // ignore: use_build_context_synchronously
                    context.push(
                      '/student/quizAnswer?quizz=$encodedQuiz&userAnswer=$userAnswerIndex',
                    );
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '${index + 1}. ${quizViewModel.quizzes[index].question}',
                          style: GoogleFonts.rubik(
                            fontSize: 18.0,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      _buildAnswerIcon(index, quizViewModel),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Widget _buildAnswerIcon(int index, QuizViewModel quizViewModel) {
  //   return FutureBuilder<int>(
  //     future
  //     // future: quizViewModel.getUserAnswer(
  //     //     1, widget.chapter, quizViewModel.quizzes[index].quizzID!),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return const CircularProgressIndicator();
  //       } else if (snapshot.hasError) {
  //         return const Icon(Icons.error, color: Colors.red);
  //       } else {
  //         final userAnswer = snapshot.data ?? -1;
  //         return Icon(
  //           quizViewModel.quizzes[index].answer == userAnswer
  //               ? Icons.check_circle
  //               : Icons.cancel,
  //           color: quizViewModel.quizzes[index].answer == userAnswer
  //               ? Colors.green
  //               : Colors.red,
  //         );
  //       }
  //     },
  //   );
  // }

  Widget _buildAnswerIcon(int index, QuizViewModel quizViewModel) {
    final quizId = quizViewModel.quizzes[index].quizzID!;
    final userAnswer = _userAnswerCache[quizId];

    return Icon(
      quizViewModel.quizzes[index].answer == userAnswer
          ? Icons.check_circle
          : Icons.cancel,
      color: quizViewModel.quizzes[index].answer == userAnswer
          ? Colors.green
          : Colors.red,
    );
  }
}
