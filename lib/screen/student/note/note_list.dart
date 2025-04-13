import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
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
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              // Bottom Section (White with Rounded Corners)
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        await model.fetchNotesForChapter(widget.chapterId,
                            refresh: true);
                      },
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Text(
                                style: AppTheme.h3Style
                                    .copyWith(color: AppTheme.textColor),
                               chapter.chapterName,
                              ),
                            ),
                            SizedBox(height:10
                            ),
                            const Divider(
                              color: Colors.grey,
                              thickness: 2,
                              height: 20,
                            ),
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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              // Progress Circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStepColor(noteProgress.progress[note.noteID]),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: _getStepIcon(noteProgress.progress[note.noteID]),
                ),
              ),
              const SizedBox(width: 16),
              // Note Title and Status
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    if (note.noteID != null) {
                      GoRouter.of(context).push('/student/note/${note.noteID}');
                      noteProgress.progress[note.noteID!] = "Completed";
                      noteViewModel.updateNoteProgress(noteProgress);
                    } else {
                      print('Error: noteID is null');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          style: AppTheme.h4Style,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget _buildQuizProgress() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Row(
            children: [
              // Progress Circle
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getStepColor(noteProgress.progress["quiz"]),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.quiz, color: Colors.white, size: 30),
                ),
              ),
              const SizedBox(width: 16),
              // Quiz Title and Status
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    noteProgress.progress["quiz"] = "In Progress";
                    noteViewModel.updateNoteProgress(noteProgress);
                    GoRouter.of(context).push(
                      '/student/questionlist/${widget.chapterId}',
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Quiz",
                          style: AppTheme.h4Style,
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getStepIcon(String? status) {
    switch (status) {
      case "Completed":
        return const Icon(Icons.check_rounded, color: Colors.white, size: 30);
      case "In Progress":
        return const Icon(Icons.access_time, color: Colors.white, size: 30);
      case "Not Started":
        return const Icon(Icons.play_circle_filled,
            color: Colors.white, size: 30);
      default:
        return const SizedBox.shrink();
    }
  }

  Color _getStepColor(String? status) {
    switch (status) {
      case "Completed":
        return secondaryColor; // Mint Green
      case "In Progress":
        return accentColor; // Soft Yellow
      case "Not Started":
        return backgroundColor; // Light Grey
      default:
        return Colors.grey[400] ?? Colors.grey; // Grey
    }
  }
}

// Color Constants
const Color primaryColor = Color(0xFF6C5CE7); // Soft Purple
const Color secondaryColor = Color(0xFF00B894); // Mint Green
const Color accentColor = Color(0xFFFDCB6E); // Soft Yellow
const Color backgroundColor = Color.fromARGB(255, 216, 215, 215); // Light Grey
const Color textColor = Color(0xFF2D3436); // Dark Grey
