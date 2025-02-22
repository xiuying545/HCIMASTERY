import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/modelview/noteviewmodel.dart';

class ManageNotesPage extends StatefulWidget {
  final String chapterId;

  const ManageNotesPage({
    Key? key,
    required this.chapterId,
  }) : super(key: key);

  @override
  _ManageNotesPageState createState() => _ManageNotesPageState();
}

class _ManageNotesPageState extends State<ManageNotesPage> {
  String chapterName = "loading";

  @override
  void initState() {
    super.initState();
    Provider.of<NoteViewModel>(context, listen: false)
        .fetchNotesForChapter(widget.chapterId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chapter = Provider.of<NoteViewModel>(context, listen: false)
          .chapters
          .firstWhere(
            (chapter) => chapter.chapterID == widget.chapterId,
            orElse: () => Chapter(
                chapterID: '', chapterName: 'Unknown Chapter', notes: []),
          );

      setState(() {
        chapterName = chapter.chapterName;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          chapterName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Correct way to set text color
          ),
        ),
        backgroundColor: const Color(0xFF3f5fd7),
      ),
      backgroundColor: const Color(0xFFECF0F1),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: noteViewModel.isLoadingNotes
                  ? const Center(child: CircularProgressIndicator())
                  : noteViewModel.notes.isEmpty
                      ? const Center(
                          child: Text(
                            'No notes available.',
                            style:
                                TextStyle(fontSize: 18, color: Colors.black54),
                          ),
                        )
                      : ListView.builder(
                          itemCount: noteViewModel.notes.length,
                          itemBuilder: (context, index) {
                            final note = noteViewModel.notes[index];
                            return _buildNoteCard(note, noteViewModel);
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
         onPressed: () => GoRouter.of(context).push(
                '/admin/addNote/${widget.chapterId}',
              ),
        backgroundColor: const Color(0xFF2980B9),
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteCard(Note note, NoteViewModel noteViewModel) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFF3f5fd7),
          child: const Icon(Icons.article, color: Colors.white),
        ),
        title: Text(
          note.title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF2980B9)),
              onPressed: () => GoRouter.of(context).push(
                '/admin/editNote/${widget.chapterId}/${note.noteID}',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.redAccent),
              onPressed: () => {},
            ),
          ],
        ),
      ),
    );
  }
}
