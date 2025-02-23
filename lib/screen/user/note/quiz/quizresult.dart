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
                    "Your Answers",
                    style: GoogleFonts.rubik(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
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

  Widget _buildHeader(int chapter, QuizViewModel quizViewModel) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF6a5ae0),
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
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.all(15),
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
                  backgroundColor: Colors.white.withOpacity(0.3),
                  circularStrokeCap: CircularStrokeCap.round,
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    "Great try, keep going up!",
                    style: GoogleFonts.rubik(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
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
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 5),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ListTile(
              onTap: () async {
                String encodedQuiz = jsonEncode(quizViewModel.quizzes[index]);
                int? userAnswerIndex =
                    _userAnswerCache[quizViewModel.quizzes[index].quizzID];

                if (encodedQuiz.isNotEmpty && userAnswerIndex != null) {
                  context.push(
                    '/student/quizAnswer?quizz=$encodedQuiz&userAnswer=$userAnswerIndex',
                  );
                }
              },
              title: Text(
                '${index + 1}. ${quizViewModel.quizzes[index].question}',
                style: GoogleFonts.rubik(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              trailing: _buildAnswerIcon(index, quizViewModel),
            ),
          );
        },
      ),
    );
  }

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