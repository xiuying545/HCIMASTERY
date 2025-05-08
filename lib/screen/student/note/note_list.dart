import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
import 'package:fyp1/common/common_widget/helpers.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/note_progress.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../view_model/note_view_model.dart';
import '../../../model/note.dart';

class NoteListPage extends StatefulWidget {
  final String chapterId;

  const NoteListPage({super.key, required this.chapterId});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late NoteViewModel noteViewModel;
  late UserViewModel userViewModel;
  bool isLoading = true;
  late Chapter chapter;

  late NoteProgress noteProgress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  Future<void> _fetchData() async {
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await noteViewModel.fetchNotesForChapter(widget.chapterId);
    setState(() {
      chapter = noteViewModel.chapters.firstWhere(
        (chapter) => chapter.chapterID == widget.chapterId,
      );

      noteProgress = noteViewModel.studentProgress.firstWhere(
        (studentProgress) => studentProgress.chapterID == widget.chapterId,
        orElse: () => NoteProgress(
          studentID: userViewModel.userId!,
          chapterID: widget.chapterId,
          progress: {},
        ),
      );
      print("chapter $chapter, noteprogress $noteProgress");
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NoteViewModel>(builder: (context, model, child) {
        if (model.isLoading || isLoading) {
          return const LoadingShimmer();
        }

        var notes = model.notes;

        if (notes.isEmpty) {
          return Stack(children: [
            const BlankState(
              icon: Icons.sticky_note_2_outlined,
              title: 'No notes yet',
              subtitle: 'Please check back later for available notes.',
            ),
            Positioned(
              top: 40,
              left: 10,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ]);
        }

        return Container(
          decoration: const BoxDecoration(
            // gradient: LinearGradient(
            //   colors: [Colors.blue.shade700, Colors.blue.shade400],
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            // ),
            image: DecorationImage(
              image: AssetImage("assets/Animation/notelistbackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              // Top Section (Gradient Background with Back Button)
              Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    // decoration: BoxDecoration(
                    //                image: DecorationImage(
                    // image: AssetImage('assets/Animation/book.png'),
                    // fit: BoxFit.cover,
                    //                ),
                    // gradient: LinearGradient(
                    //   colors: [Colors.blue.shade700, Colors.blue.shade400],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                    // ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          right: 50,
                          child: Image.asset(
                            'assets/Animation/book.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                        // Positioned(
                        //   bottom: 20,
                        //   left: 20,
                        //   child: SizedBox(
                        //     width: MediaQuery.of(context).size.width * 0.6,
                        //     child: Text(
                        //       chapter.chapterName,
                        //       style: AppTheme.h1Style
                        //           .copyWith(color: Colors.white),
                        //       maxLines: 2,
                        //       overflow: TextOverflow.ellipsis,
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    style: AppTheme.h3Style.copyWith(color: AppTheme.textColor),
                    chapter.chapterName,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await model.fetchNotesForChapter(widget.chapterId,
                          refresh: true);
                    },
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),

                          const SizedBox(height: 10),
                          // Step Indicator for Notes
                          ...List.generate(
                            notes.length,
                            (index) => _buildNoteProgress(
                              note: notes[index],
                              index: index,
                              totalNotes: notes.length,
                            ),
                          ),
                          _buildQuizProgress(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildNoteProgress({
    required Note note,
    required int index,
    required int totalNotes,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDF9F1), // very light beige
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getStepColor(noteProgress.progress[note.noteID]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: _getStepIcon(noteProgress.progress[note.noteID]),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (note.noteID != null) {
                    GoRouter.of(context).push('/student/note/${note.noteID}');
                    noteProgress.progress[note.noteID!] = "Completed";
                    noteViewModel.updateNoteProgress(noteProgress);
                  }
                },
                child: Text(
                  note.title,
                  style: AppTheme.h4Style.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFDF9F1),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getStepColor(noteProgress.progress["quiz"]),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.quiz, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  noteProgress.progress["quiz"] = "In Progress";
                  noteViewModel.updateNoteProgress(noteProgress);
                  GoRouter.of(context)
                      .push('/student/questionlist/${widget.chapterId}');
                },
                child: Text(
                  "Quiz",
                  style: AppTheme.h4Style.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Widget _getStepIcon(String? status) {
  switch (status) {
    case "Completed":
      return const Icon(Icons.check_circle_rounded, color: Colors.white, size: 28);
    case "In Progress":
      return const Icon(Icons.hourglass_bottom_rounded, color: Colors.white, size: 26);

    default:
        return const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 28);

  }
}
 Color _getStepColor(String? status) {
  switch (status) {
    case "Completed":
      return const Color(0xFFB7E4C7); // Soft mint green
    case "In Progress":
      return const Color(0xFFFFE7A0); // Soft pastel yellow
    default:
      return const Color(0xFFD7D7D7); // fallback neutral pastel grey
  }
}
}

// Color Constants
const Color primaryColor = Color(0xFF6C5CE7); // Soft Purple
const Color secondaryColor = Color(0xFF00B894); // Mint Green
const Color accentColor = Color(0xFFFDCB6E); // Soft Yellow
const Color backgroundColor = Color.fromARGB(255, 216, 215, 215); // Light Grey
const Color textColor = Color(0xFF2D3436); // Dark Grey
