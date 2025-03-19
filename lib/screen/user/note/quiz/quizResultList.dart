import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

class QuizResultPage extends StatefulWidget {
  final String chapterID;

  const QuizResultPage({super.key, required this.chapterID});

  @override
  _QuizResultPageState createState() => _QuizResultPageState();
}

class _QuizResultPageState extends State<QuizResultPage> {
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
      // todo Set user ID (example)
    Provider.of<UserViewModel>(context, listen: false)
        .setUserId("fYD79MVprcRdfvTktnzEbbDued23");
   await quizViewModel.loadData(userViewModel.userId!, widget.chapterID);
    await quizViewModel.calculateScore(widget.chapterID, userViewModel.userId!);
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
        backgroundColor: Colors.blue.shade800,
      ),
      body:  
      
      Consumer<QuizViewModel>(
        builder: (context, quizViewModel, child) {
          if (quizViewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6a5ae0)),
              ),
            );
          } else if (quizViewModel.quizzes.isEmpty) {
            return Center(
              child: Text(
                'No quizzes available.',
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          } else {
           return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
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
                  _buildAnswerList(),
                ],
              ),
            );
          }
        }
      )
    );}

            
      
    
  Widget _buildHeader() {
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
                              "${quizViewModel.score }",
                      
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
Widget _buildAnswerList() {
  return Expanded(
    child: ListView.builder(
      itemCount: quizViewModel.quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizViewModel.quizzes[index];
        final isCorrect = quiz.answer == quizViewModel.cachedAnswers[quiz.quizzID];

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: InkWell(
            onTap: () async {
              String encodedQuiz = jsonEncode(quiz);
              int? userAnswerIndex = quizViewModel.cachedAnswers[quiz.quizzID];

              if (encodedQuiz.isNotEmpty && userAnswerIndex != null) {
                 GoRouter.of(context).push(
                          "/student/quizAnswer?quizzID=${quiz.quizzID}");
         
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
