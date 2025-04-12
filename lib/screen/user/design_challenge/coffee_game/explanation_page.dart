import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExplanationScreen extends StatefulWidget {
  const ExplanationScreen({super.key});

  @override
  State<ExplanationScreen> createState() => _ExplanationScreenState();
}

class _ExplanationScreenState extends State<ExplanationScreen> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> slides = [
    {
      'title': '🎮 What Did You Just Do?',
      'text':
          'You participated in a fun and simple A/B testing activity! In HCI, this helps designers understand which design works better for users.',
      'image': 'assets/Animation/abtesting.png'
    },
    {
      'title': '☕ Flow A: Step-by-Step',
      'text':
          'Flow A guides users one step at a time. It helps beginners focus and reduces mistakes. Slower but safer!',
      'image': 'assets/Animation/flowa.png'
    },
    {
      'title': '⚡ Flow B: All-in-One',
      'text':
          'Flow B lets users choose everything on one screen. Fast and efficient, but might be overwhelming for some users.',
      'image': 'assets/Animation/flowb.png'
    },
    {
      'title': '💡 HCI Takeaway',
      'text':
          'There is no perfect design. Good UX depends on who the user is and what they’re trying to do. That’s the heart of HCI! 🎓',
      'image': 'assets/Animation/hci.png'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFDAC1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("📚 HCI Learning", style: TextStyle(color: Colors.brown)),
        leading: const BackButton(color: Colors.brown),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              onPageChanged: (index) => setState(() => currentIndex = index),
              itemCount: slides.length,
              itemBuilder: (context, index) {
                final slide = slides[index];
                return Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(slide['image']!, height: 220),
                      const SizedBox(height: 30),
                      Text(
                        slide['title']!,
                        style: GoogleFonts.fredoka(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown[800],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        slide['text']!,
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (currentIndex > 0)
                  TextButton(
                    onPressed: () => _controller.previousPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    child: const Text('← Back'),
                  ),
                if (currentIndex < slides.length - 1)
                  ElevatedButton(
                    onPressed: () => _controller.nextPage(
                        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA69E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Next →', style: TextStyle(fontSize: 16)),
                  )
                else
                  ElevatedButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA69E),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text('Back to Start 🔁', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
