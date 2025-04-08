import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/banner.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
import 'package:fyp1/common/common_widget/course_tile.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late NoteViewModel noteViewModel;
  late UserViewModel userViewModel;
  Map<String, double> progressMap = {};
     bool isLoading = true; 
  @override
  void initState() {
        noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
    loadInitialData();
      });
  }

  Future<void> loadInitialData() async {

    await noteViewModel.setupChapterData(userViewModel.userId!);
    setState(()  {
          progressMap =  noteViewModel.calculateProgressByChapter();
          isLoading=false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          _buildHeader(),

          CustomBanner(
            title: "Explore, Learn,\nand Master HCI\nusing HCI Mastery",
            imagePath: 'assets/Animation/child.png',
            onPressed: () {
              // Handle the button press
            },
          ),
          const SizedBox(height: 20),
          Expanded(child: _buildCoursesSection()),
        ],
      ),
    );
  }

 
  // Header with greeting and search bar
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hi, Evelyn 👋',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Let\'s start learning!',
            style: GoogleFonts.poppins(
                color: Colors.black, fontSize: 16, fontWeight: FontWeight.w400),
          ),
          // const SizedBox(height: 20),
          // _buildSearchBar(),
        ],
      ),
    );
  }

  Widget _buildCoursesSection() {
    return Consumer<NoteViewModel>(
      builder: (context, viewModel, _) {
        if (viewModel.isLoading||isLoading) {
          return const LoadingShimmer();
        }

        if (viewModel.chapters.isEmpty) {
          return   const BlankState(
                    icon: Icons.menu_book_outlined,
                    title: 'No chapters yet',
                    subtitle: 'Please check back later for available chapters.',
                  );
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📚 Courses',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: viewModel.chapters.length,
                  itemBuilder: (context, index) {
                    Chapter chapter = viewModel.chapters[index];
                    return CourseTile(
                      icon: Icons.book,
                      title: chapter.chapterName,
                      subtitle: "${chapter.notes?.length} lessons",
                      chapterId: chapter.chapterID!,
                      progress: progressMap[chapter.chapterID] ?? 0.0,
                      color: Colors.blue.shade400,
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

