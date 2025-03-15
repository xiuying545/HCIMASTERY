import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/note.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _noteFuture = _loadNote();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _youtubePlayerController.dispose();
    super.dispose();
  }

  Future<Note> _loadNote() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay

    final note = Note(
      noteID: 'hci_001',
      title: 'Introduction to Human-Computer Interaction (HCI)',
      content: '''
      Human-Computer Interaction (HCI) is the study and practice of designing, evaluating, and implementing interactive computing systems that involve human users. HCI encompasses a wide range of topics, including the design of user interfaces (UI), the study of how people interact with technology, and the psychological, cognitive, and social aspects of technology use. The goal of HCI is to improve the usability, effectiveness, and accessibility of computer systems for diverse users.
      ''',
      images: [
        'assets/SplashScreen1.png',
        'assets/SplashScreen2.png',
        'assets/SplashScreen3.png'
      ],
      videoLink: [
        'https://www.youtube.com/watch?v=dSBRQUebo7g&list=PLeWkVB-3iLCW2EGSOp2EK9ZBCQjzA1YXl',
      ],
    );

    // Initialize YouTube player if videoLink is available
    if (note.videoLink != null && note.videoLink!.isNotEmpty) {
      audioUrl = note.videoLink![0];
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(note.videoLink![0])!,
        flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
      );
    }

    return note;
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Note>(
          future: _noteFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading...', style: TextStyle(color: Colors.white));
            } else if (snapshot.hasError) {
              return const Text('Error loading note', style: TextStyle(color: Colors.white));
            } else {
              return Text(
                snapshot.data!.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              );
            }
          },
        ),
        backgroundColor: Colors.blue.shade900,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade900, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
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
            return _buildNoteContent(note);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlayPause,
        backgroundColor: Colors.blue.shade900,
        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
      ),
    );
  }




Widget _buildNoteContent(Note note) {
  return Container(
    color: Colors.white, // Plain white background for the page
    padding: const EdgeInsets.all(16.0),
    child: ListView(
      children: [
        Text(
                      'Introduction to Human Computer Interaction',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade800,
                      ),
                    ),

                    const SizedBox(height: 5,),
        // Note Section (Book-Like Design)
        Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50], // Light parchment-like color
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
        // Images Section
        if (note.images != null && note.images!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
        
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: note.images!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          note.images![index],
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        const SizedBox(height: 16),
                // Header with Book Icon
                Row(
                  children: [
                    Icon(Icons.menu_book, color: Colors.brown.shade700, size: 28),
                    const SizedBox(width: 10),
                    Text(
                      'Note Content',
                      style: GoogleFonts.merriweather(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.brown.shade800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),

                // Divider (Ornamental Line)
                Divider(
                  color: Colors.brown.shade300,
                  thickness: 1,
                ),
                const SizedBox(height: 3),

                // Drop Cap for the First Letter
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: note.content[0], // First letter
                        style: GoogleFonts.merriweather(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                      TextSpan(
                        text: note.content.substring(1), // Rest of the content
                        style: GoogleFonts.merriweather(
                          fontSize: 16,
                          color: Colors.grey[800],
                          height: 1.6, // Line height for readability
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),


        // YouTube Video Player
        if (note.videoLink != null && note.videoLink!.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Video',
                style: GoogleFonts.merriweather(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: YoutubePlayer(
                    controller: _youtubePlayerController,
                    showVideoProgressIndicator: true,
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}
}