import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/helpers.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late NoteViewModel noteViewModel;
  bool isLoading = true;

  final List<IconData> icons = [
    Icons.play_circle_fill_rounded,
    Icons.book_outlined,
    Icons.lightbulb_outline,
    Icons.auto_awesome,
    Icons.menu_book,
  ];



  @override
  void initState() {
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await noteViewModel.setupChapterData();
      await noteViewModel.calculateProgressByChapter();
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3EFFF),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          CustomBanner(
            title: "Explore, Learn,\nand Master HCI",
            imagePath: 'assets/Animation/child.png',
            onPressed: () {
              // Handle banner tap
            },
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildCoursesSection()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, Evelyn 👋',
            style: GoogleFonts.fredoka(
              color: const Color(0xff2c2c2c),
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let us learn HCI together!',
            style: GoogleFonts.poppins(
              color: const Color(0xff2c2c2c),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Consumer<NoteViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading || isLoading) {
          return const LoadingShimmer();
        }

        if (viewModel.chapters.isEmpty) {
          return const BlankState(
            icon: Icons.menu_book_outlined,
            title: 'No chapters yet',
            subtitle: 'Please check back later for available chapters.',
          );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📚 Courses',
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff2c2c2c),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.chapters.length,
                  itemBuilder: (context, index) {
                    Chapter chapter = viewModel.chapters[index];
                    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/student/notelist/${chapter.chapterID}'),
      child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xffFDF7FA),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: pastelColors[index % pastelColors.length]
                                 ,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              icons[index % icons.length],
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  chapter.chapterName,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff2c2c2c),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${viewModel.noteCount[chapter.chapterID]} lessons',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: viewModel.progressMap[
                                            chapter.chapterID] ??
                                        0,
                                    backgroundColor: Colors.grey[200],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      pastelColors[
                                          index % pastelColors.length],
                                    ),
                                    minHeight: 8,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
class CustomBanner extends StatelessWidget {
  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const CustomBanner({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFF5D9CFA),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 28,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: onPressed,
                  child: Text(
                    "Explore",
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1565C0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            right: -10,
            child: Image.asset(
              imagePath,
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}