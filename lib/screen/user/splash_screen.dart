import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/constant.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  List<Map<String, String>> splashData = [
    {
      "text": "Welcome to HCIMastery! Empower your learning journey.",
      "image": "assets/SplashScreen1.png"
    },
    {
      "text": "Access notes anytime, anywhere to strengthen your knowledge.",
      "image": "assets/SplashScreen2.png"
    },
    {
      "text":
          "Test your skills with quizzes and learn collaboratively in our forum.",
      "image": "assets/SplashScreen3.png"
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
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
              const SizedBox(height: 20),
              // Dots Indicator
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  splashData.length,
                  (index) => buildDot(index: index, themeColor: themeColor),
                ),
              ),
              const SizedBox(height: 40),
              // Get Started Button
              ElevatedButton(
                onPressed: () {
                  Future.delayed(const Duration(milliseconds: 500), () {
                    checkLoginStatus();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: themeColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                  elevation: 5,
                  shadowColor: themeColor.withOpacity(0.3),
                ),
                child: Text(
                  "Get Started",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
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
    );
  }

  Future<void> checkLoginStatus() async {
    final loginStatus = StorageHelper.get(STATUS);
    final role = StorageHelper.get(ROLE);

    if (loginStatus == STATUS_LOGIN) {
      if (role == ROLE_STUDENT) {
        GoRouter.of(context).go("/studentNav");
      } else if (role == ROLE_ADMIN) {
        GoRouter.of(context).go("/adminNav");
      } else {
        GoRouter.of(context).go("/signin");
      }
    } else {
      // Not logged in
      GoRouter.of(context).go("/signin");
    }
  }

  AnimatedContainer buildDot({required int index, required Color themeColor}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.only(right: 8),
      height: 8,
      width: currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: currentPage == index ? themeColor : const Color(0xFFD8D8D8),
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
    final themeColor = Colors.blue.shade900;

    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "HCI Mastery",
            style: GoogleFonts.poppins(
              fontSize: 42, // Increased font size
              fontWeight: FontWeight.bold,
              color: themeColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            text ?? '',
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 20, // Increased font size
              color: Colors.grey[900],
              fontWeight: FontWeight.w400,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          // Image Container
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              // Center the image
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: image != null
                    ? Image.asset(
                        image!,
                        fit: BoxFit
                            .contain, // Use BoxFit.contain to ensure the image fits within the container
                      )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
