import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  Future<void> loadInitialData() async {
    await quizViewModel.calculateScore(widget.chapterID, userViewModel.userId!);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(
        title: 'Quiz Result',
        route: '/studentNav',
      ),
      backgroundColor: const Color(0xFFFFFDF5),
      body: Consumer<QuizViewModel>(builder: (context, quizViewModel, child) {
        if (quizViewModel.isLoading || isLoading) {
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
      }),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF54A2E3),
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: AssetImage("assets/Animation/congratulation.png"),fit:BoxFit.contain)
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Container(
        
        
        child:Center(
        child: Column(
          children: [
            Text(
              'Congratulations, you had scored',
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 22.0,
                
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2773C8),
                borderRadius: BorderRadius.circular(80),
              ),
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  Text(
                    "${quizViewModel.score}",
                    style: GoogleFonts.rubik(
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
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
            )
          ],
        ),
      ),
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

          return 
          GestureDetector(
            onTap:   ()  {
              String? quizzID = quiz.quizzID;
         

     
                context.push(
                  '/student/quizAnswer?quizzID=${quizzID}',
                );
            
            },
          child:Container(
      
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          quiz.question,
                          style: GoogleFonts.rubik(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          isCorrect ? 'Correct Answer' : 'Wrong Answer',
                          style: GoogleFonts.rubik(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ));
        },
      ),
    );
  }
}
