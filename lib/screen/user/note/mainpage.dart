import 'package:flutter/material.dart';
import 'package:fyp1/modelview/noteviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<NoteViewModel>(context, listen: false);

    // Fetch chapters when the page is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      viewModel.fetchChapters();
      viewModel.calculateAllProgress();
    });

    return Scaffold(
      backgroundColor: const Color(0xFF6a5ae0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildExercisesSection(context),
          ],
        ),
      ),
    );
  }

  // Header section with user greeting and search bar
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
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.0),
                        Text(
                          'Hi, Evelyn',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.0),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5.0),
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
            'What are you looking for?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  // Exercises Section that dynamically loads chapters
  Widget _buildExercisesSection(BuildContext context) {
    return Expanded(
      child: Consumer<NoteViewModel>(
        builder: (context, viewModel, _) {
          if (viewModel.isLoadingChapters) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.hasError) {
            return Center(
              child: Text(
                viewModel.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (viewModel.chapters.isEmpty) {
            return const Center(
              child: Text(
                'No chapters found.',
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return Container(
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
                          'Courses',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  Expanded(
                    child: ListView.builder(
                      itemCount: viewModel.chapters.length,
                      itemBuilder: (context, index) {
                        final chapter = viewModel.chapters[index];
                        return ExerciseTitle(
                          icon: Icons.book,
                          title: chapter.chapterName,
                          subtitle: "${chapter.notes.length} lessons",
                          chapterId: chapter.chapterID!,
                          progress: viewModel.progressMap[chapter.chapterID] ?? 0.0,
                          color: Colors.lightBlueAccent,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Widget to represent each exercise (course) in the list
class ExerciseTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String chapterId;
  final String subtitle;
  final double progress;
  final Color color;

  const ExerciseTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.chapterId,
    required this.subtitle,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => GoRouter.of(context).push('/student/notelist/$chapterId'),
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
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}