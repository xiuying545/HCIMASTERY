import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
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
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 0, 0, 0),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: quizViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color(0xFFefeefb),
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 25),
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
                              color: const Color(0xFFffffff),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 15),
                              leading: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6a5ae0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.question_answer,
                                  color: Colors.white,
                                  size: 28,
                                ),
                              ),
                              title: Text(
                               "${index+1}. ${ quizViewModel.quizzes[index].question}",
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  color: Color.fromARGB(255, 0, 0, 0),
                                  fontWeight: FontWeight.bold,
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
