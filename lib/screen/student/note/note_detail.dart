import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
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
  late NoteViewModel noteViewModel;
  List<YoutubePlayerController> _youtubeControllers = [];
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  @override
  void dispose() {
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadNote() async {
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);

    setState(() {
      currentNote = noteViewModel.notes
          .firstWhere((note) => note.noteID == widget.noteID);
    });
    
    if (currentNote.videoLink != null && currentNote.videoLink!.isNotEmpty) {
      _youtubeControllers = currentNote.videoLink!.map((link) {
        return YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId(link)!,
          flags: const YoutubePlayerFlags(
            autoPlay: false,
            mute: false,
            enableCaption: true,
          ),
        );
      }).toList();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackBtn(
        title: currentNote.title,
      ),
      body: _buildNoteContent(),
    
    );
  }

  Widget _buildNoteContent() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 5),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
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
                  // Images Section with Carousel
                  if (currentNote.images != null && currentNote.images!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: currentNote.images!.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.network(
                                        currentNote.images![index],
                                        width: double.infinity,
                                        height: 200,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
                                          if (loadingProgress == null) return child;
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: loadingProgress.expectedTotalBytes != null
                                                  ? loadingProgress.cumulativeBytesLoaded /
                                                      loadingProgress.expectedTotalBytes!
                                                  : null,
                                            ),
                                          );
                                        },
                                        errorBuilder: (context, error, stackTrace) {
                                          return Container(
                                            color: Colors.grey[200],
                                            child: const Icon(Icons.broken_image, size: 50),
                                          );
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                              // Dot indicators
                              if (currentNote.images!.length > 1)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: List.generate(
                                      currentNote.images!.length,
                                      (index) => Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(horizontal: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentPage == index
                                              ? Colors.blue.shade900
                                              : Colors.grey.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
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
                          text: currentNote.content[0], // First letter
                          style: GoogleFonts.merriweather(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown.shade800,
                          ),
                        ),
                        TextSpan(
                          text: currentNote.content.substring(1), // Rest of the content
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
          const SizedBox(height: 24),

          // YouTube Video Player Section
          if (currentNote.videoLink != null && currentNote.videoLink!.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Related Videos',
                  style: GoogleFonts.merriweather(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade800,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _youtubeControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: YoutubePlayer(
                            controller: _youtubeControllers[index],
                            showVideoProgressIndicator: true,
                            progressIndicatorColor: Colors.blue.shade900,
                            progressColors: const ProgressBarColors(
                              playedColor: Colors.blue,
                              handleColor: Colors.blueAccent,
                            ),
                            onReady: () {
                              _youtubeControllers[index].addListener(() {});
                            },
                          ),
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