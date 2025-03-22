import 'package:flutter/material.dart';
import 'package:fyp1/common_style/app_theme.dart';
import 'package:fyp1/common_widget/custom_dialog.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../model/note.dart';
import '../../../view_model/note_view_model.dart';

class ManageNotePage extends StatefulWidget {
  final String chapterId;

  const ManageNotePage({super.key, required this.chapterId});

  @override
  _ManageNotePage createState() => _ManageNotePage();
}

class _ManageNotePage extends State<ManageNotePage> {
  late String chapterName;

  @override
  void initState() {
    super.initState();
    fetchNoteData();
  }

  Future<void> fetchNoteData() async {
    await Provider.of<NoteViewModel>(context, listen: false)
        .fetchNotesForChapter(widget.chapterId);
    setState(() {});
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
      body: Consumer<NoteViewModel>(builder: (context, model, child) {
        final notes = model.notes;
        if (model.isLoading) {
          return const Center(child: CircularProgressIndicator());
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
              // Top Section (Gradient Background with Image)
              Stack(
                children: [
                  Container(
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.blue.shade700, Colors.blue.shade400],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 50,
                          right: 40,
                          child: Image.asset(
                            'assets/Animation/teacher.png',
                            width: 300,
                            height: 300,
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Text("List of Notes",
                              style: AppTheme.h1Style
                                  .copyWith(color: Colors.white)),
                        ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Chapter Name
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 30, top: 20, bottom: 10),
                          child: Text(chapterName, style: AppTheme.h2Style),
                        ),
                        // Divider
                        const Divider(
                          color: Colors.grey,
                          thickness: 2,
                          height: 0, // Remove extra space
                        ),
                        // List of Notes
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.only(top: 10),
                            itemCount: notes.length,
                            itemBuilder: (context, index) {
                              final note = notes[index];
                              return _buildNoteRow(note);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(
          '/admin/addNote/${widget.chapterId}',
        ),
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Note',
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteRow(Note note) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
      child: GestureDetector(
        onTap: () {
          GoRouter.of(context).push('/student/note/${note.noteID}');
        },
        child: Row(
          children: [
            // Note Title
            Expanded(
              child: Text(note.title, style: AppTheme.h3Style),
            ),
            // Edit and Delete Buttons
            Row(
              children: [
                // Edit Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () => GoRouter.of(context).push(
                      '/admin/editNote/${widget.chapterId}/${note.noteID}',
                    ),
                    tooltip: 'Edit Note',
                  ),
                ),
                const SizedBox(width: 8),
                // Delete Button
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.white),
                    onPressed: () => _showDeleteConfirmationDialog(note),
                    tooltip: 'Delete Note',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,
      builder: (ctx) => CustomDialog(

        title: 'Delete Note',
        content:
            'Are you sure you want to delete this note? This action cannot be undone.',
        action: 'Alert',
        onConfirm: () async {
          Navigator.of(context).pop(); // Close the dialog
          await Provider.of<NoteViewModel>(context, listen: false)
              .deleteNote(widget.chapterId, note.noteID!);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note deleted successfully!',
                    style: AppTheme.snackBarText),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}

// Color Constants
const Color textColor = Color(0xFF2D3436);
