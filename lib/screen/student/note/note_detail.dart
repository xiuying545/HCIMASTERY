import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    for (var controller in _youtubeControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
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
            forceHD: true,
            isLive: false,
            controlsVisibleAtStart: true,
            hideControls: false,
            disableDragSeek: false,
          ),
        );
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffCDE4DA),
      appBar: AppBarWithBackBtn(
        title: currentNote.title,
      ),
      body: _buildNoteContent(),
    );
  }

  Widget _buildNoteContent() {
    return Container(
      color: const Color(0xffCDE4DA),
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          const SizedBox(height: 5),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xffFDF6EC),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Images Section with Carousel
                  if (currentNote.images != null &&
                      currentNote.images!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 350,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              PageView.builder(
                                controller: _pageController,
                                itemCount: currentNote.images!.length,
                                onPageChanged: (index) {
                                  setState(() => _currentPage = index);
                                },
                                itemBuilder: (context, index) {
                                  final imageUrl = currentNote.images![index];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) => Dialog(
                                              backgroundColor: Colors.black,
                                              insetPadding: EdgeInsets.zero,
                                              child: Stack(
                                                children: [
                                                  InteractiveViewer(
                                                    panEnabled: true,
                                                    minScale: 0.5,
                                                    maxScale: 4.0,
                                                    child: Center(
                                                      child: Image.network(
                                                        imageUrl,
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    top: 40,
                                                    right: 20,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.white,
                                                        size: 30,
                                                      ),
                                                      onPressed: () =>
                                                          Navigator.of(context)
                                                              .pop(),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        child: Image.network(
                                          imageUrl,
                                          height: 350,
                                          fit: BoxFit.contain,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Container(
                                              color: Colors.grey[200],
                                              child: const Icon(
                                                Icons.broken_image,
                                                size: 50,
                                              ),
                                            );
                                          },
                                        ),
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
                                      (i) => Container(
                                        width: 8,
                                        height: 8,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _currentPage == i
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
                      const Icon(Icons.menu_book,
                          color: Color(0xff368173), size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Kandungan Nota',
                        style: GoogleFonts.merriweather(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff3B2B2F),
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
                        // TextSpan(
                        //   text: currentNote.content[0],
                        //   style: GoogleFonts.merriweather(
                        //     fontSize: 48,
                        //     fontWeight: FontWeight.bold,
                        //     color: const Color(0xff4E3C36),
                        //   ),
                        // ),
                        TextSpan(
                          text: currentNote.content,
                          style: GoogleFonts.merriweather(
                            fontSize: 16,
                            color: const Color(0xff4E3C36),
                            height: 1.6,
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
          if (currentNote.videoLink != null &&
              currentNote.videoLink!.isNotEmpty)
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
                    final videoUrl = currentNote.videoLink![index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Show Copyable Video Link
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xffF6F1E9),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.brown.shade200),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    videoUrl,
                                    style: GoogleFonts.merriweather(
                                      fontSize: 14,
                                      color: const Color(0xff4E3C36),
                                      height: 1.4,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    Clipboard.setData(
                                        ClipboardData(text: videoUrl));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text("Link copied!")),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          buildYoutubePlayer(_youtubeControllers[index]),
                        ],
                      ),
                    );
                  },
                )
              ],
            ),
        ],
      ),
    );
  }


  Widget buildYoutubePlayer(YoutubePlayerController controller) {
  return YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Colors.blue.shade700,
      progressColors: const ProgressBarColors(
        playedColor: Colors.teal,
        handleColor: Colors.tealAccent,
      ),
      onReady: () {
        controller.addListener(() {});
      },
    ),
    builder: (context, player) {
      return Container(
        width: MediaQuery.of(context).size.width,
        child: player,
      );
    },
  );
}
}
