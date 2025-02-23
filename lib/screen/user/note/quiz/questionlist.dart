import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
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

  
  @override
  void initState() {
    super.initState();
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    if (quizViewModel.quizzes.isEmpty) {
      quizViewModel.fetchQuizzes(1);
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context);

    // Debugging output for the length of quizzes
    print('Fetched quizzes: ${quizViewModel.quizzes.length}');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Question List',
          style: GoogleFonts.rubik(
            fontSize: 22.0,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700, // Primary color
        elevation: 4, // Add shadow
        iconTheme:
            const IconThemeData(color: Colors.white), // Back button color
      ),
      body: quizViewModel.isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6a5ae0)),
              ),
            )
          : Container(
              color: const Color(0xFFf5f5f5), // Light background color
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20),
                  Expanded(
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
                                // child: Image.asset(
                                //   'assets/Animation/quiz.png',
                                //   width: 28,
                                //   height: 28,
                                // ),
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
                                final quizListJson = jsonEncode(quizViewModel
                                    .quizzes
                                    .map((quiz) => quiz.toJson())
                                    .toList());
                                GoRouter.of(context).push(
                                    '/student/quiz?quizzList=${Uri.encodeComponent(quizListJson)}&index=$index');

                                print(
                                    "quiz22:${Uri.encodeComponent(quizListJson)}&index=$index')");
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
