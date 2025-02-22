import 'package:flutter/material.dart';
import 'package:fyp1/model/noteProgress.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../modelview/noteviewmodel.dart';
import '../../../model/note.dart';

class NoteListPage extends StatefulWidget {
  final String chapterId;

  const NoteListPage({super.key, required this.chapterId});

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  late NoteProgress noteProgress;
  bool isLoading = true;
  late String chapterName;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<NoteViewModel>(context, listen: false)
        .fetchNotesForChapter(widget.chapterId);

    final fetchedProgress =
        await Provider.of<NoteViewModel>(context, listen: false)
            .fetchStudentProgress("1", widget.chapterId);

    setState(() {
      noteProgress = fetchedProgress;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    chapterName = Provider.of<NoteViewModel>(context, listen: false)
        .chapters
        .firstWhere(
          (chapter) => chapter.chapterID == widget.chapterId,
        )
        .chapterName;

    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<NoteViewModel>(builder: (context, model, child) {
              final notes = model.notes;

              if (notes.isEmpty) {
                return const Center(child: Text('No notes available.'));
              }

              return Column(
                children: [
                  // Top Section (Gradient Background with Back Button)
                  Stack(
                    children: [
                      Container(
                        height: 200, // Adjust height as needed
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue.shade700,
                              Colors.blue.shade400
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 0,
                              right: 50,
                              child: Image.asset(
                                'assets/Animation/book.png',
                                width: 200,
                                height: 200,
                              ),
                            ),
                            Positioned(
                              bottom: 20,
                              left: 20,
                              child: Text(
                                chapterName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Back Button
                      Positioned(
                        top: 40, // Adjust position as needed
                        left: 20,
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(); // Navigate back
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
                        padding: const EdgeInsets.symmetric(vertical: 30.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "Course Detail",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),),
                           

                            Divider(
                              color: Colors.grey, 
                              thickness: 2, 
                              height:
                                  20, 
               
                            ),
                            SizedBox(height: 10),
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
                ],
              );
            }),
    );
  }

  Widget _buildNoteProgress({
    required Note note,
    required int index,
    required int totalNotes,
  }) {
    return 
    Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Circle
            Container(
              width: 70,
              height: 70,
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
                    NoteViewModel().addOrUpdateStudentProgress(noteProgress);
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
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        // Progress Line
        SizedBox(height: 15),
      ],
      )
    );
  }

  Widget _buildQuizProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Progress Circle
            Container(
              width: 70,
              height: 70,
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
                  NoteViewModel().addOrUpdateStudentProgress(noteProgress);
                  GoRouter.of(context).push(
                    '/student/questionlist/${widget.chapterId}',
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quiz",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _getStepIcon(String? status) {
    switch (status) {
      case "Completed":
        return const Icon(Icons.check, color: Colors.white, size: 30);
      case "In Progress":
        return const Icon(Icons.access_time, color: Colors.white, size: 30);
      case "Not Started":
      default:
        return const SizedBox.shrink();
    }
  }

  Color _getStepColor(String? status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF28a745); // Green
      case "In Progress":
        return const Color(0xFFffc107); // Yellow
      case "Not Started":
      default:
        return Colors.grey[400] ?? Colors.grey; // Grey
    }
  }
}
