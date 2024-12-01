import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/note.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart'; // Import video_player package

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
  late String audioUrl;
  late YoutubePlayerController _youtubePlayerController;
  bool isVideoPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubePlayerController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (isPlaying) {
      _audioPlayer.pause();
    } else {
      _audioPlayer.play(UrlSource(audioUrl));
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _noteFuture = _loadNote();
  }

  Future<Note> _loadNote() async {
    await Future.delayed(const Duration(seconds: 1));

    final note = Note(
      noteID: 'hci_001',
      title: 'Introduction to Human-Computer Interaction (HCI)',
      content: '''
      Human-Computer Interaction (HCI) is the study and practice of designing, evaluating, and implementing interactive computing systems that involve human users. HCI encompasses a wide range of topics, including the design of user interfaces (UI), the study of how people interact with technology, and the psychological, cognitive, and social aspects of technology use. The goal of HCI is to improve the usability, effectiveness, and accessibility of computer systems for diverse users.
      ''',
      images: [
        'assets/SplashScreen1.jpg',
        'assets/SplashScreen2.jpg',
        'assets/SplashScreen3.jpg'
      ],
      videoLink: [
        'https://www.youtube.com/watch?v=dSBRQUebo7g&list=PLeWkVB-3iLCW2EGSOp2EK9ZBCQjzA1YXl',
        // Add more video links as needed
      ],
    );

    // Check if videoLink is not null and not empty, then set the first video URL
    if (note.videoLink != null && note.videoLink!.isNotEmpty) {
      audioUrl = note.videoLink![0];  // Use the first video link for audio URL
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(note.videoLink![0])!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }

    return note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Note>(
          future: _noteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('Note not found');
            } else {
              final note = snapshot.data!;
              return Text(note.title, style: const TextStyle(color: Colors.white));
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

                  // Display images dynamically
                  if (note.images != null && note.images!.isNotEmpty)
                    Column(
                      children: note.images!
                          .map((image) => Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: Image.asset(
                                  image,
                                  width: double.infinity,
                                  height: 250.0,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: 16),

                  // YouTube Video Player
                  if (note.videoLink != null && note.videoLink!.isNotEmpty)
                    YoutubePlayer(
                      controller: _youtubePlayerController,
                      showVideoProgressIndicator: true,
                    ),

                  const SizedBox(height: 16),

                  // Audio Play/Pause Button
                  if (audioUrl.isNotEmpty)
                    ElevatedButton(
                      onPressed: _togglePlayPause,
                      child: Text(isPlaying ? 'Pause Audio' : 'Play Audio'),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
