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
      appBar: AppBar(
        title: Text(chapterName, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF6a5ae0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<NoteViewModel>(builder: (context, model, child) {
              final notes = model.notes;

              if (notes.isEmpty) {
                return const Center(child: Text('No notes available.'));
              }

              return Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                  ));
            }),
    );
  }

Widget _buildNoteProgress(
      {required Note note, required int index, required int totalNotes}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
            // Note Title and Status Removed Card Design
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
                          fontSize: 18, // Bigger font size
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
        Container(
          margin: const EdgeInsets.fromLTRB(34, 0, 0, 0),
          width: 5,
          height: 35,
          color: _getStepColor(noteProgress.progress[note.noteID]),
        ),
      ],
    );
  }

  // Method to return icons based on progress status
  Widget _getStepIcon(String? status) {
    switch (status) {
      case "Completed":
        return const Icon(Icons.check, color: Colors.white, size: 30); // Check icon for completed
      case "In Progress":
        return const Icon(Icons.access_time, color: Colors.white, size: 30); // Progress icon for in progress
      case "Not Started":
      default:
        return const SizedBox.shrink(); // No icon for not started
    }
  }
  Widget _buildQuizProgress() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Center align the row
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: _getStepColor(noteProgress.progress["quiz"]),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.quiz,
                    color: Colors.white, size: 30), // Bigger icon
              ),
            ),
            const SizedBox(width: 16),
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
                          fontSize: 20, // Bigger font size
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
