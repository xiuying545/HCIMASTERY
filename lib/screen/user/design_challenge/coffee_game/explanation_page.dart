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
      'title': '🎮 Apa yang anda baru lakukan?',
      'text':
          'Anda telah menyertai aktiviti ujian A/B yang mudah dan menyeronokkan! Dalam HCI, ini membantu pereka bentuk memahami reka bentuk mana yang lebih sesuai untuk pengguna.',
      'image': 'assets/Animation/abtesting.png'
    },
    {
      'title': '☕ Aliran A: Langkah demi langkah',
      'text':
          'Aliran A membimbing pengguna satu langkah pada satu masa. Ia membantu pengguna baru untuk fokus dan mengurangkan kesilapan. Lebih perlahan tetapi lebih selamat!',
      'image': 'assets/Animation/flowa.png'
    },
    {
      'title': '⚡ Aliran B: Semua dalam satu',
      'text':
          'Aliran B membenarkan pengguna membuat semua pilihan dalam satu skrin. Cepat dan cekap, tetapi mungkin mengelirukan bagi sesetengah pengguna.',
      'image': 'assets/Animation/flowb.png'
    },
    {
      'title': '💡 Pengajaran HCI',
      'text':
          'Tiada reka bentuk yang sempurna. UX yang baik bergantung kepada siapa penggunanya dan apa yang mereka cuba lakukan. Itulah intipati HCI! 🎓',
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
        title: const Text("📚 Pembelajaran HCI", style: TextStyle(color: Colors.brown)),
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
                    child: const Text('← Kembali'),
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
                    child: const Text('Seterusnya →', style: TextStyle(fontSize: 16)),
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
                    child: const Text('Kembali ke Mula 🔁', style: TextStyle(fontSize: 16)),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
