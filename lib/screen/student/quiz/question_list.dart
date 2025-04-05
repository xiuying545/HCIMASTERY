import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuestionListPage extends StatefulWidget {
  final String chapterID;

  const QuestionListPage({super.key, required this.chapterID});

  @override
  _QuestionListPageState createState() => _QuestionListPageState();
}

class _QuestionListPageState extends State<QuestionListPage> {
  late QuizViewModel quizViewModel;

  @override
  void initState() {
    super.initState();

    loadQuizData();
  }

  Future<void> loadQuizData() async {
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    await quizViewModel.fetchQuizData(widget.chapterID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar:  const AppBarWithBackBtn(
        title: "Question List",
      ),
      
      body: Consumer<QuizViewModel>(
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
                'No quizzes found',
                style: GoogleFonts.poppins(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            );
          } else {
           return  RefreshIndicator(
                onRefresh: () async {
                  await quizViewModel.fetchQuizData(widget.chapterID, refresh: true);
                },
                child:  Container(
              color: const Color(0xFFf5f5f5),
              child: ListView.builder(
                itemCount: quizViewModel.quizzes.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 20),
                        leading: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade700.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: const Icon(
                            Icons.question_answer,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          "${index + 1}. ${quizViewModel.quizzes[index].question}",
                          style: GoogleFonts.poppins(
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          "Tap to view details",
                          style: GoogleFonts.rubik(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () {
                          final quizListJson = jsonEncode(quizViewModel.quizzes
                              .map((quiz) => quiz.toJsonFrontend())
                              .toList());
                          GoRouter.of(context).push(
                              '/student/quiz?quizzList=${Uri.encodeComponent(quizListJson)}&index=$index');
                        },
                      ),
                    ),
                  );
                },
              ),
            ));
          }
        },
      ),
    );
  }
}
