import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/noteviewmodel.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/services/chapter_service.dart';
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
  bool isLoading = true;
  late String chapterName;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<QuizViewModel>(context, listen: false)
        .fetchQuizzes(widget.chapterId);
    setState(() {
      isLoading = false;
    });
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
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade900],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.grey.shade100, // Light grey background for the page
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Consumer<QuizViewModel>(
                builder: (context, model, child) {
                  final quizzes = model.quizzes;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapterName,
                          style: GoogleFonts.comicNeue(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                        const SizedBox(height: 16),
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
            // Quiz Question with Edit and Delete Icons
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: AutoSizeText(
                    '⭐ ${quiz.question}',
                    style: GoogleFonts.comicNeue(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.blue.shade900,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 16,
                  ),
                ),
                const SizedBox(width: 8),
                // Edit Button with Circular Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue.shade700),
                    iconSize: 24,
                    onPressed: () => GoRouter.of(context).push('/admin/editQuiz/${widget.chapterId}/${quiz.quizzID}'),
                    tooltip: 'Edit Quiz',
                  ),
                ),
                const SizedBox(width: 8),
                // Delete Button with Circular Background
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade700),
                    iconSize: 24,
                    onPressed: () => _showDeleteConfirmationDialog(quiz),
                    tooltip: 'Delete Quiz',
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
                      child: const Icon(Icons.broken_image, color: Colors.grey),
                    );
                  },
                ),
              ),
            const SizedBox(height: 12),

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
                        color: isCorrectAnswer ? Colors.green.shade100 : Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isCorrectAnswer ? Colors.green.shade900 : Colors.blue.shade900,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Option Text
                    Expanded(
                      child: Text(
                        option,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}

  void _showDeleteConfirmationDialog(Quiz quiz) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Delete Quiz',
            style: GoogleFonts.comicNeue(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blue.shade900,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this quiz? This action cannot be undone.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.grey.shade700,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
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
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}