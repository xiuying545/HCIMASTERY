import 'package:flutter/material.dart';
import 'package:fyp1/common_style/app_theme.dart';
import 'package:fyp1/common_widget/action_button.dart';
import 'package:fyp1/common_widget/app_bar_with_back.dart';
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
              // Stack(
              //   children: [
              //     Container(
              //       height: 300,
              //       width: double.infinity,
              //       decoration: BoxDecoration(
              //         gradient: LinearGradient(
              //           colors: [Colors.blue.shade700, Colors.blue.shade400],
              //           begin: Alignment.topLeft,
              //           end: Alignment.bottomRight,
              //         ),
              //       ),
              //       child: Stack(
              //         children: [
              //           Positioned(
              //             top: 50,
              //             right: 40,
              //             child: Image.asset(
              //               'assets/Animation/teacher.png',
              //               width: 300,
              //               height: 300,
              //             ),
              //           ),
              //           Positioned(
              //             bottom: 20,
              //             left: 20,
              //             child: Text("List of Notes",
              //                 style: AppTheme.h1Style
              //                     .copyWith(color: Colors.white)),
              //           ),
              //         ],
              //       ),
              //     ),
              //     // Back Button
              //     Positioned(
              //       top: 40,
              //       left: 20,
              //       child: IconButton(
              //         icon: const Icon(
              //           Icons.arrow_back,
              //           color: Colors.white,
              //           size: 30,
              //         ),
              //         onPressed: () {
              //           Navigator.of(context).pop();
              //         },
              //       ),
              //     ),
              //   ],
              // ),
              // Bottom Section (White with Rounded Corners)
              Expanded(
                // child: ClipRRect(
                //   borderRadius: const BorderRadius.only(
                //     topLeft: Radius.circular(30),
                //     topRight: Radius.circular(30),
                //   ),
                child: Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Chapter Name
                      // Padding(
                      //   padding: const EdgeInsets.only(
                      //       left: 30, top: 20, bottom: 10),
                      //   child: Text(chapterName, style: AppTheme.h1Style),
                      // ),
                      // Divider
                      // const Divider(
                      //   color: Colors.grey,
                      //   thickness: 2,
                      //   height: 0, // Remove extra space
                      // ),
                      // List of Notes
                      Expanded(
                        child: ReorderableListView.builder(
                          padding: const EdgeInsets.only(top: 10),
                          itemCount: notes.length,
                          itemBuilder: (context, index) {
                            final note = notes[index];
                            return _buildNoteRow(note, index);
                          },
                          onReorder: (int oldIndex, int newIndex) {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final Note item = notes.removeAt(oldIndex);
                            notes.insert(newIndex, item);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // ),
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

  Widget _buildNoteRow(Note note, int index) {
    return Card(
      key: Key('$index'),
      margin: const EdgeInsets.fromLTRB(20, 5, 20, 10),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => GoRouter.of(context).push('/student/note/${note.noteID}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Row(
                  children: [
            

                    // Note title
                    Expanded(
                      child: Text('⭐ ${note.title}', style: AppTheme.h4Style.copyWith(color: AppTheme.primaryColor)),
                    ),

                    // Action buttons
                    ReorderableDragStartListener(
                      index: index,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: Icon(Icons.drag_indicator_rounded,
                         color: AppTheme.primaryColor, size: 30),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit button

                    ActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      color: Colors.green.shade700,
                      onTap: () => GoRouter.of(context).push(
                          '/admin/editNote/${widget.chapterId}/${note.noteID}'),
                    ),
                    SizedBox(width: 10),

                    // Delete button

                    ActionButton(
                      icon: Icons.delete,
                      label: 'Delete',
                      color: Colors.red.shade700,
                      onTap: () => _showDeleteConfirmationDialog(note),
                    ),
                  ],
                ),
              ]),
            ],
          ),
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
