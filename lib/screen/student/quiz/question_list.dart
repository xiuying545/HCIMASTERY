import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
import 'package:fyp1/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/quiz.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadQuizData();
    });
  }

  Future<void> loadQuizData() async {
    await quizViewModel.loadData(widget.chapterID);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFDF5),
      appBar: const AppBarWithBackBtn(
        title: "Senarai Soalan",
      ),
      body: Consumer<QuizViewModel>(
        builder: (context, quizViewModel, child) {
          if (quizViewModel.isLoading || isLoading) {
            return const LoadingShimmer();
          } else if (quizViewModel.quizzes.isEmpty) {
            return const BlankState(
              icon: Icons.quiz,
              title: 'Tiada kuiz lagi',
              subtitle: 'Sila semak semula kemudian untuk kuiz yang tersedia.',
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                await quizViewModel.fetchQuizData(widget.chapterID, refresh: true);
              },
              child: Container(
                color: const Color(0xFFf5f5f5),
                child: ListView.builder(
                  itemCount: quizViewModel.quizzes.length,
                  itemBuilder: (context, index) {
                    Quiz quiz = quizViewModel.quizzes[index];
                    int selectedIndex = quizViewModel.cachedAnswers[quiz.quizzID] ?? -1;
                    String selectedOption;
                    if (selectedIndex != -1) {
                      selectedOption = quiz.options[selectedIndex];
                    } else {
                      selectedOption = "❗Tiada jawapan";
                    }

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFD0D8E2).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                          leading: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF5E9FEF),
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
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1F2937),
                            ),
                          ),
                          subtitle: Text(
                            selectedOption,
                            style: GoogleFonts.rubik(
                              fontSize: 14.5,
                              color: const Color(0xFF6B7280),
                            ),
                          ),
                          onTap: () {
                            final quizListJson = jsonEncode(
                              quizViewModel.quizzes.map((quiz) => quiz.toJsonFrontend()).toList(),
                            );
                            GoRouter.of(context).push(
                              '/student/quiz?quizzList=${Uri.encodeComponent(quizListJson)}&index=$index',
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
