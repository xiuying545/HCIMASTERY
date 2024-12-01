import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;

  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to EduConnect! Empower your learning journey.",
      "image": "assets/SplashScreen1.jpg"
    },
    {
      "text": "Access notes anytime, anywhere to strengthen your knowledge.",
      "image": "assets/SplashScreen2.jpg"
    },
    {
      "text": "Test your skills with quizzes and learn collaboratively in our forum.",
      "image": "assets/SplashScreen3.jpg"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFefeefb),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0,vertical: 70),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                SizedBox(
                  height: 350, // Fixed height for the PageView
                  child: PageView.builder(
                    onPageChanged: (value) {
                      setState(() {
                        currentPage = value;
                      });
                    },
                    itemCount: splashData.length,
                    itemBuilder: (context, index) => SplashContent(
                      image: splashData[index]["image"],
                      text: splashData[index]["text"],
                    ),
                  ),
                ),
                const SizedBox(height: 20), // Spacing between PageView and dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    splashData.length,
                    (index) => buildDot(index: index),
                  ),
                ),
                const SizedBox(height: 70), 
                ElevatedButton(
                  onPressed: () {              
                    context.go("/signin");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6a5ae0),
                   
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal:40 ,vertical: 15),
                    elevation: 3,
                  ),
                  child: Text(
                    "Get Started",
                    style: GoogleFonts.rubik(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20), 
              ],
            ),
          ),
        ),
      ),
    );
  }

  AnimatedContainer buildDot({required int index}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentPage == index
            ? const Color(0xFF4C6EF5)
            : const Color(0xFFD8D8D8),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class SplashContent extends StatelessWidget {
  final String? text, image;

  const SplashContent({
    super.key,
    this.text,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          const Spacer(),
          Text(
            "HCI Mastery", // Changed to match your branding
            style: GoogleFonts.poppins(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6a5ae0),
            ),
          ),
          const SizedBox(height: 30),
          Text(
            text ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.rubik(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16), // Added some spacing
          // Handling both network and local images
          SizedBox(
            width: 200, // Set fixed width
            height: 150, // Set fixed height
            child: image != null
                ? (image!.startsWith('http')
                    ? Image.network(
                        image!,
                        fit: BoxFit.cover, // Changed to cover to fill the space
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.error);
                        },
                      )
                    : Image.asset(
                        image!,
                        fit: BoxFit.cover, // Changed to cover to fill the space
                      ))
                : const SizedBox(), // Fallback for null images
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class NextScreen extends StatelessWidget {
  const NextScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Next Screen")),
      body: const Center(child: Text("Welcome to the next screen!")),
    );
  }
}
