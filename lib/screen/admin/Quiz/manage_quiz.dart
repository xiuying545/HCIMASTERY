import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common_style/app_theme.dart';
import 'package:fyp1/common_widget/action_button.dart';
import 'package:fyp1/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common_widget/custom_dialog.dart';
import 'package:fyp1/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ManageQuizPage extends StatefulWidget {
  final String chapterId;

  const ManageQuizPage({super.key, required this.chapterId});

  @override
  _ManageQuizPageState createState() => _ManageQuizPageState();
}

class _ManageQuizPageState extends State<ManageQuizPage> {
  late String chapterName;
  late QuizViewModel quizViewModel;

  @override
  void initState() {
    super.initState();
    loadQuizData();
  }

  Future<void> loadQuizData() async {
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    await quizViewModel.fetchQuizzes(widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    chapterName = Provider.of<NoteViewModel>(context, listen: false)
        .chapters
        .firstWhere(
          (chapter) => chapter.chapterID == widget.chapterId,
          orElse: () => Chapter(
            chapterID: '',
            chapterName: 'Unknown Chapter',
            notes: [],
          ),
        )
        .chapterName;

    return Scaffold(
      appBar: AppBarWithBackBtn(title: chapterName),
      body: Container(
        color: Colors.grey.shade100, // Light grey background for the page
        child: Consumer<QuizViewModel>(
          builder: (context, model, child) {
            if (model.isLoading) {
              return const LoadingShimmer();
            }
            final quizzes = model.quizzes;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: quizzes.length,
                      itemBuilder: (context, index) {
                        final quiz = quizzes[index];
                        return _buildQuizCard(quiz);
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            GoRouter.of(context).push('/admin/addQuiz/${widget.chapterId}'),
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Quiz',
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildQuizCard(Quiz quiz) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          // Handle card tap
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AutoSizeText(
                      '⭐ ${quiz.question}',
                      style: AppTheme.h4Style
                          .copyWith(color: AppTheme.primaryColor),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 16,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (quiz.imageUrl != null && quiz.imageUrl!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    quiz.imageUrl!,
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: double.infinity,
                        height: 150,
                        color: Colors.grey.shade200,
                        child:
                            const Icon(Icons.broken_image, color: Colors.grey),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 8),

              // Quiz Options with Icons
              ...quiz.options.asMap().entries.map((entry) {
                final index = entry.key;
                final option = entry.value;
                final isCorrectAnswer = index == quiz.answer;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      // Option Number Icon
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: isCorrectAnswer
                              ? Colors.green.shade100
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}',
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isCorrectAnswer
                                ? Colors.green.shade900
                                : Colors.blue.shade900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Option Text
                      Expanded(
                        child: Text(
                          option,
                          style: AppTheme.h5Style,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ActionButton(
                    icon: Icons.edit,
                    label: "Edit",
                    color: Colors.green.shade800,
                    onTap: () => GoRouter.of(context).push(
                        '/admin/editQuiz/${widget.chapterId}/${quiz.quizzID}'),
                  ),
                  SizedBox(width: 8),
                  ActionButton(
                    icon: Icons.delete,
                    label: "Delete",
                    color: Colors.red.shade900,
                    onTap: () => _showDeleteConfirmationDialog(quiz),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Quiz quiz) {
    showDialog(
        context: context,
        builder: (context) => CustomDialog(

              title: 'Delete Quiz',
              content:
                  'Are you sure you want to delete this quiz? This action cannot be undone.',
              action: 'Alert',
              onConfirm: () async {
                Navigator.of(context).pop();
                //todo
                // await Provider.of<QuizViewModel>(context, listen: false)
                //     .deleteQuiz(quiz.id!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Quiz deleted successfully!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ));
  }
}
