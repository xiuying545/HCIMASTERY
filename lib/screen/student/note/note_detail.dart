import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class NotePage extends StatefulWidget {
  final String noteID;

  const NotePage({super.key, required this.noteID});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late Note currentNote;
  late AudioPlayer _audioPlayer;
  late NoteViewModel noteViewModel;
  bool isPlaying = false;
  late String audioUrl;
  List<YoutubePlayerController> _youtubeControllers = [];

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _loadNote();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadNote() async {
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);

    setState(() {
      currentNote = noteViewModel.notes.firstWhere((note) => note.noteID == widget.noteID);
    });
    // Initialize YouTube player if videoLink is available
    if (currentNote.videoLink != null && currentNote.videoLink!.isNotEmpty) {
      _youtubeControllers = currentNote.videoLink!.map((link) {
        return YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(link)!,
          flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
        );
      }).toList();
    }
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
   appBar:  AppBarWithBackBtn(
        title: currentNote.title,
      ),
      body: _buildNoteContent(),
      floatingActionButton: FloatingActionButton(
        onPressed: _togglePlayPause,
        backgroundColor: Colors.blue.shade900,
        child: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white),
      ),
    );
  }

  Widget _buildNoteContent() {
    return Container(
      color: Colors.white, // Plain white background for the page
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(
            height: 5,
          ),
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
                  if (currentNote.images != null &&
                      currentNote.images!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: currentNote.images!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.asset(
                                    currentNote.images![index],
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
                      Icon(Icons.menu_book,
                          color: Colors.brown.shade700, size: 28),
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
                          text: currentNote.content[0], // First letter
                          style: GoogleFonts.merriweather(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        TextSpan(
                          text: currentNote.content
                              .substring(1), // Rest of the content
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
          if (currentNote.videoLink != null &&
              currentNote.videoLink!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Videos',
                  style: GoogleFonts.merriweather(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _youtubeControllers.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: YoutubePlayer(
                          controller: _youtubeControllers[index],
                          showVideoProgressIndicator: true,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }
}
