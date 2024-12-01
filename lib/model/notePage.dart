import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import 'package:fyp1/model/note.dart';

class NotePage extends StatefulWidget {
  final String noteID;

  const NotePage({super.key, required this.noteID});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Future<Note> _noteFuture;
  late AudioPlayer _audioPlayer;
  bool isPlaying = false;

  @override
  void initState() {
    super.initState();
    // Hardcoded note for testing purposes
    _noteFuture = _loadNote();
  }

  Future<Note> _loadNote() async {
    // Hardcoded Note for testing purposes
    // Replace this with dynamic fetching once ready
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    return Note(
      noteID: 'hci_001',
      title: 'Introduction to Human-Computer Interaction (HCI)',
      content: '''
Human-Computer Interaction (HCI) is the study and practice of designing, evaluating, and implementing interactive computing systems that involve human users. HCI encompasses a wide range of topics, including the design of user interfaces (UI), the study of how people interact with technology, and the psychological, cognitive, and social aspects of technology use. The goal of HCI is to improve the usability, effectiveness, and accessibility of computer systems for diverse users.


''',
      images: 'assets/sample_image.png',
      videoLink: 'https://www.example.com/video.mp4',
    );

    // Original Soft Code (commented out):
    // final noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    // return noteViewModel.notes.firstWhere(
    //   (note) => note.noteID == widget.noteID,
    //   orElse: () => Note(
    //     noteID: 'not-found',
    //     title: 'Note not found',
    //     content: 'Content not available.',
    //     images: '',
    //     videoLink: '',
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Note>(
          future: _noteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loading indicator while waiting for the note
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Note not found');
            } else {
              final note = snapshot.data!;
              return Text(note.title, style: TextStyle(color: Colors.white));
            }
          },
        ),
        backgroundColor: const Color(0xFF6a5ae0),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<Note>(
        future: _noteFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('Note not found'));
          } else {
            final note = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  Text(
                    note.content,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Image
                  if (note.images.isNotEmpty)
                    Image.asset(
                      note.images,
                      width: double.infinity,
                      height: 250.0,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 16),

                  // Video Link
                  if (note.videoLink.isNotEmpty)
                    ElevatedButton(
                      onPressed: () {
                        _launchURL(note.videoLink);
                      },
                      style: ElevatedButton.styleFrom(
                        iconColor: const Color(0xFF6a5ae0),
                      ),
                      child: const Text('Watch Video'),
                    ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  void _launchURL(String url) {
    // You can use a package like url_launcher to open the URL
    // For this example, we assume you will handle URL launching.
    print('Launch URL: $url'); // Here, replace with actual URL launch logic.
  }
}
