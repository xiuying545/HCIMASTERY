import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/options_bottom_sheet.dart';
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
  late NoteViewModel noteViewModel;
     bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchNoteData();
    });
    
  }

  Future<void> fetchNoteData() async {
    await noteViewModel.fetchNotesForChapter(widget.chapterId);
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
      backgroundColor: Color(0xffFDF3FA),
      appBar: AppBarWithBackBtn(
        title: chapterName,
      ),
      body: Consumer<NoteViewModel>(builder: (context, model, child) {
        if (model.isLoading||isLoading) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          );
        }

        return RefreshIndicator(
            onRefresh: () async {
              await model.fetchNotesForChapter(widget.chapterId, refresh: true);
            },
            child: Column(
              children: [
                // Notes list
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: model.notes.isEmpty
                        ? const BlankState(
                            icon: Icons.note_add,
                            title: 'No notes yet',
                            subtitle: 'Tap the + button to add a new note',
                          )
                        : ReorderableListView.builder(
                            padding: const EdgeInsets.only(top: 16, bottom: 80),
                            itemCount: model.notes.length,
                            itemBuilder: (context, index) {
                              final note = model.notes[index];
                              return _buildNoteRow(note, index);
                            },
                            onReorder: (int oldIndex, int newIndex) {
                              if (oldIndex < newIndex) {
                                newIndex -= 1;
                              }
                              final Note item = model.notes.removeAt(oldIndex);
                              model.notes.insert(newIndex, item);
                              model.updateNoteOrder(
                                  model.notes, widget.chapterId);
                            },
                          ),
                  ),
                ),
              ],
            ));
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => GoRouter.of(context).push(
          '/admin/addNote/${widget.chapterId}',
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        tooltip: 'Add Note',
        child: const Icon(Icons.add, size: 28, color: Colors.white),
      ),
    );
  }

  Widget _buildNoteRow(Note note, int index) {
    return Container(
      key: Key('$index'),
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          onLongPress: () => _showNoteOptionsBottomSheet(note),
          borderRadius: BorderRadius.circular(16),
          onTap: () =>
              GoRouter.of(context).push('/student/note/${note.noteID}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Note icon
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.article,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Note title and content preview
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            note.title,
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            note.content.length > 300
                                ? '${note.content.substring(0, 300)}...'
                                : note.content,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 6,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),

                    // Options and drag handle
                    Column(
                      children: [
                        // More options icon
                        IconButton(
                          icon: Icon(Icons.more_vert,
                              color: Colors.grey.shade500),
                          onPressed: () => _showNoteOptionsBottomSheet(note),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 24,
                        ),
                        const SizedBox(height: 8),
                        // Drag handle
                        ReorderableDragStartListener(
                          index: index,
                          child: Icon(
                            Icons.drag_handle_rounded,
                            color: Colors.grey.shade400,
                            size: 24,
                          ),
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

  void _showNoteOptionsBottomSheet(Note note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomOptionsBottomSheet(
        options: [
          OptionItem(
            icon: Icons.edit,
            label: 'Edit Note',
            color: Colors.blue.shade800,
            onTap: () {
              GoRouter.of(context)
                  .push('/admin/editNote/${widget.chapterId}/${note.noteID}');
            },
          ),
          OptionItem(
            icon: Icons.delete_outline_rounded,
            label: 'Delete Note',
            color: Colors.red.shade600,
            onTap: () {
              _showDeleteConfirmationDialog(note);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(Note note) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Delete Note',
        content:
            'Are you sure you want to delete "${note.title}"? This action cannot be undone.',
        action: 'Delete',
        onConfirm: () async {
          Navigator.of(context).pop();
          await noteViewModel.deleteNote(widget.chapterId, note.noteID!);

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Note deleted successfully!',
                    style: AppTheme.snackBarText),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
