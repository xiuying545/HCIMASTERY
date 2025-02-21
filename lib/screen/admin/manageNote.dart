import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/modelview/noteviewmodel.dart';

class ManageNotesPage extends StatefulWidget {
  final String chapterId;
  final String chapterTitle = "hey";

  const ManageNotesPage({
    Key? key,
    required this.chapterId,

  }) : super(key: key);

  @override
  _ManageNotesPageState createState() => _ManageNotesPageState();
}

class _ManageNotesPageState extends State<ManageNotesPage> {
  @override
  void initState() {
    super.initState();
    // Fetch notes for the specific chapter when the page loads
    Provider.of<NoteViewModel>(context, listen: false)
        .fetchNotesForChapter(widget.chapterId);
  }

  @override
  Widget build(BuildContext context) {
    final noteViewModel = Provider.of<NoteViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF6a5ae0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildNotesSection(context, noteViewModel),
          ],
        ),
      ),
    );
  }

  // Header section with chapter title and search bar
  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF6a5ae0),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 0,
            right: 16,
            child: Image.asset(
              'assets/bck.png', // Replace with your image path
              width: 100, // Adjust width as needed
              height: 100, // Adjust height as needed
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Text(
                  widget.chapterTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                _buildSearchBar(),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Search bar widget
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 131, 117, 240),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.search,
            color: Colors.white,
            size: 28,
          ),
          SizedBox(width: 8.0),
          Text(
            'Search notes...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Notes Section that dynamically loads notes
  Widget _buildNotesSection(BuildContext context, NoteViewModel noteViewModel) {
    return Expanded(
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFefeefb),
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notes',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.more_vert, color: Color(0xFF3f5fd7)),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: noteViewModel.isLoadingNotes
                    ? const Center(child: CircularProgressIndicator())
                    : noteViewModel.notes.isEmpty
                        ? const Center(
                            child: Text(
                              'No notes available.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black54,
                              ),
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
      ),
    );
  }

  // Build a card for each note
  Widget _buildNoteCard(Note note, NoteViewModel noteViewModel) {
    return GestureDetector(
      onTap: () {
        // Navigate to note details or edit page
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF3f5fd7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.article, color: Colors.white),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    note.content,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Color(0xFF3f5fd7)),
              onPressed: () => _showEditNoteDialog(context, noteViewModel, note),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _confirmDeleteNote(noteViewModel, note),
            ),
          ],
        ),
      ),
    );
  }

  // Show a dialog to add a new note
  void _showAddNoteDialog(BuildContext context, NoteViewModel noteViewModel) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                final newNote = Note(
                  noteID: DateTime.now().toString(), // Generate a unique ID
                  title: titleController.text,
                  content: contentController.text,
                );
                await noteViewModel.addNoteToChapter(widget.chapterId, newNote);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6a5ae0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  // Show a dialog to edit an existing note
  void _showEditNoteDialog(
      BuildContext context, NoteViewModel noteViewModel, Note note) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                final updatedNote = Note(
                  noteID: note.noteID,
                  title: titleController.text,
                  content: contentController.text,
                );
                await noteViewModel.updateNote(
                    widget.chapterId, note.noteID!, updatedNote);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6a5ae0),
                foregroundColor: Colors.white,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Confirm deletion of a note
  void _confirmDeleteNote(NoteViewModel noteViewModel, Note note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Note'),
          content: const Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await noteViewModel.deleteNote(widget.chapterId, note.noteID!);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}