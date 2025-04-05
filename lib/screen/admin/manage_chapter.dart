import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/action_button.dart';
import 'package:fyp1/common/common_widget/banner.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/input_dialog.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/note.dart';
import '../../view_model/note_view_model.dart';

class ChapterDetailsPage extends StatefulWidget {
  const ChapterDetailsPage({super.key});

  @override
  _ChapterDetailsPageState createState() => _ChapterDetailsPageState();
}

class _ChapterDetailsPageState extends State<ChapterDetailsPage> {
  late NoteViewModel noteViewModel;

  @override
  void initState() {
    super.initState();
    fetchChapterData();
  }

  Future<void> fetchChapterData() async {
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    await noteViewModel.setupChapterDataAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // Hi Admin Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Hi Admin 👋",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          SizedBox(height: 20,),
          // Banner Section
          CustomBanner(
            title: "Manage your notes\nthrough\nHCI Mastery",
            imagePath: 'assets/Animation/chapter.png',
            onPressed: () {
              // Handle the button press
            },
          ),
           SizedBox(height: 25,),
          // Chapters Heading
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Chapters", style: AppTheme.h2Style),
                  ElevatedButton(
                      onPressed: () => _showAddChapterDialog(context),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.add, size: 24, color: Colors.white),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            "Add Chapter",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ))
                ],
              )),
          const SizedBox(height: 10),
          // List of Chapters
          Expanded(
            child: Consumer<NoteViewModel>(
              builder: (context, model, child) {
                if (model.isLoading) {
                  return const LoadingShimmer();
                }

                final chapters = model.chapters;
                return RefreshIndicator(
                    onRefresh: () async {
                      await model.fetchChapters();
                    },
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = chapters[index];
                        return _buildChapterCard(chapter);
                      },
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.blue.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add any action you want on card tap
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Edit and Delete Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.chapterName,
                            style: GoogleFonts.poppins(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Notes Button
                              ActionButton(
                                icon: Icons.note,
                                label: 'Notes',
                                color: Colors.blue.shade700,
                                onTap: () => _navigateToManageNotes(chapter),
                              ),
                              const SizedBox(width: 12),
                              // Quizzes Button
                              ActionButton(
                                icon: Icons.quiz,
                                label: 'Quizzes',
                                color: Colors.green.shade600,
                                onTap: () => _navigateToManageQuizzes(chapter),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Vertical Edit and Delete Buttons
                    Column(
                      children: [
                        // Edit Button
                        IconButton(
                          onPressed: () =>
                              _showEditChapterDialog(context, chapter),
                          icon: Icon(Icons.edit,
                              size: 24, color: Colors.blue.shade800),
                        ),
                        // Delete Button
                        IconButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(chapter),
                          icon: Icon(Icons.delete,
                              size: 24, color: Colors.red.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToManageNotes(Chapter chapter) {
    GoRouter.of(context).push('/admin/manageNote/${chapter.chapterID}');
  }

  void _navigateToManageQuizzes(Chapter chapter) {
    GoRouter.of(context).push('/admin/manageQuiz/${chapter.chapterID}');
  }

  void _showAddChapterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InputDialog(
            title: 'Add Chapter',
            hintText: 'Enter  chapter name',
            onSave: (chapterName) async {
              if (chapterName.isNotEmpty) {
                final chapter = Chapter(
                  chapterName: chapterName,
                  notes: [],
                );
                await Provider.of<NoteViewModel>(context, listen: false)
                    .addChapter(chapter);
              }
            });
      },
    );
  }

  void _showEditChapterDialog(BuildContext context, Chapter chapter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return InputDialog(
          title: 'Edit Chapter',
          initialValue: chapter.chapterName,
          hintText: 'Enter new chapter name',
          onSave: (newChapterName) async {
            await Provider.of<NoteViewModel>(context, listen: false)
                .updateChapterName(chapter.chapterID!, newChapterName);
          },
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Chapter chapter) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Delete Chapter',
        content:
            'Are you sure you want to delete this chapter? This action cannot be undone.',
        action: 'Alert',
        onConfirm: () async {
          await Provider.of<NoteViewModel>(context, listen: false)
              .deleteChapter(chapter.chapterID!);
          Navigator.of(context).pop();

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Chapter deleted successfully!',
                    style: AppTheme.snackBarText),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Manage your notes\nthrough\nHCI Mastery",
                    style: AppTheme.h3Style.copyWith(
                      color: Colors.white,
                      height: 1.3,
                    )),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Explore",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: -20,
            child: Image.asset(
              'assets/Animation/chapter.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
