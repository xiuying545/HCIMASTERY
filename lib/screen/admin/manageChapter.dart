import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/note.dart';
import '../../../modelview/noteviewmodel.dart';

class ChapterDetailsPage extends StatefulWidget {
  const ChapterDetailsPage({super.key});

  @override
  _ChapterDetailsPageState createState() => _ChapterDetailsPageState();
}

class _ChapterDetailsPageState extends State<ChapterDetailsPage> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Provider.of<NoteViewModel>(context, listen: false).fetchChapters();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          // Hi Admin Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Hi Admin 👋",
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // Banner Section
          _buildBanner(),
          // Chapters Heading
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Chapters",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // List of Chapters
          Expanded(
            child: isLoading
                ? _buildLoadingShimmer()
                : Consumer<NoteViewModel>(
                    builder: (context, model, child) {
                      final chapters = model.chapters;
                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: chapters.length,
                        itemBuilder: (context, index) {
                          final chapter = chapters[index];
                          return _buildChapterCard(chapter);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddChapterDialog(context),
        backgroundColor: Colors.blue.shade900,
        elevation: 6,
        icon: const Icon(Icons.add, size: 24, color: Colors.white),
        label: Text(
          "Add Chapter",
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      shadowColor: Colors.blue.shade100,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Add any action you want on card tap
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey.shade50],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with Edit and Delete Buttons
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            chapter.chapterName,
                            style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Notes Button
                              _buildActionButton(
                                icon: Icons.note,
                                label: 'Notes',
                                color: Colors.blue.shade700,
                                onTap: () => _navigateToManageNotes(chapter),
                              ),
                              const SizedBox(width: 12),
                              // Quizzes Button
                              _buildActionButton(
                                icon: Icons.quiz,
                                label: 'Quizzes',
                                color: Colors.green.shade600,
                                onTap: () => _navigateToManageQuizzes(chapter),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Vertical Edit and Delete Buttons
                    Column(
                      children: [
                        // Edit Button
                        IconButton(
                          onPressed: () =>
                              _showEditChapterDialog(context, chapter),
                          icon: Icon(Icons.edit,
                              size: 24, color: Colors.blue.shade800),
                        ),
                        // Delete Button
                        IconButton(
                          onPressed: () =>
                              _showDeleteConfirmationDialog(chapter),
                          icon: Icon(Icons.delete,
                              size: 24, color: Colors.red.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(30),
          // border: Border.all(color: color.withOpacity(0.3), width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 24, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 18,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _navigateToManageNotes(Chapter chapter) {
    GoRouter.of(context).push('/admin/manageNote/${chapter.chapterID}');
  }

  void _navigateToManageQuizzes(Chapter chapter) {
    GoRouter.of(context).push('/admin/manageQuiz/${chapter.chapterID}');
  }

  void _showAddChapterDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Chapter',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter chapter name',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final chapterName = controller.text.trim();
                        if (chapterName.isNotEmpty) {
                          final chapter = Chapter(
                           
                            chapterName: chapterName,
                            notes: [],
                          );
                          await Provider.of<NoteViewModel>(context,
                                  listen: false)
                              .addChapter(chapter);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Add',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditChapterDialog(BuildContext context, Chapter chapter) {
    final TextEditingController controller =
        TextEditingController(text: chapter.chapterName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Edit Chapter',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter new chapter name',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        final newChapterName = controller.text.trim();
                        if (newChapterName.isNotEmpty) {
                          await Provider.of<NoteViewModel>(context,
                                  listen: false)
                              .updateChapterName(
                                  chapter.chapterID!, newChapterName);
                          Navigator.of(context).pop();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(Chapter chapter) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Delete Chapter',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Are you sure you want to delete this chapter? This action cannot be undone.',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await Provider.of<NoteViewModel>(context, listen: false)
                            .deleteChapter(chapter.chapterID!);
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Delete',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [Colors.blue.shade800, Colors.blue.shade500],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade200,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Manage your notes\nthrough\nHCI Mastery",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 10),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Explore",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: -10,
            right: -20,
            child: Image.asset(
              'assets/Animation/chapter.png',
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
