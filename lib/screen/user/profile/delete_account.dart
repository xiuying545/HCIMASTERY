import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteAccountPage extends StatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  State<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends State<DeleteAccountPage> {
  final TextEditingController _passwordController = TextEditingController();
  void _onDeletePressed() async {
    if (_passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Please enter your password."),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final cred = EmailAuthProvider.credential(
        email: user.email!,
        password: _passwordController.text.trim(),
      );

      // Attempt reauthentication
      await user.reauthenticateWithCredential(cred);

      // Delete user from database
      Provider.of<NoteViewModel>(context, listen: false)
          .deleteNoteProgressForUser(user.uid);
                Provider.of<QuizViewModel>(context, listen: false)
          .deleteQuizAnswerForUser(user.uid);
      await Provider.of<UserViewModel>(context, listen: false).deleteUser();
      await user.delete();

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: const Color(0xFFFFF6E6),
          title: const Center(
            child: Text(
              "GoodBye",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF2A4F4F),
              ),
            ),
          ),
          content: const Text(
            "Your account has been deleted.\nHope to see you next time! 😊",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Color(0xFF2A4F4F),
              height: 1.5,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFF16D5D),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              onPressed: () => GoRouter.of(context).go("/signin"),
              child: const Text(
                "OK",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Incorrect password. Please try again."),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red),
        );
      } else {
        print(e.code);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Something went wrong. Please try again."),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDBE72),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.brown, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: BoxDecoration(
                color: const Color(0xffFFECB3),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Delete Account",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2A4F4F),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Image.asset("assets/Animation/sadBear.png", height: 200),
                  const SizedBox(height: 16),
                  Text(
                    "Sorry to let you go.\nHope to see you next time!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    style: const TextStyle(
                        color: Color(0xFF2A4F4F)), // Deep green text
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: const TextStyle(
                        color: Color(0xFF2A4F4F),
                        fontWeight: FontWeight.w500,
                      ),
                      filled: true,
                      fillColor: const Color(
                          0xFFFFF6E6), // Soft pastel cream background
                      prefixIcon: const Icon(Icons.lock_outline,
                          color: Color(0xFF2A4F4F)),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 18, horizontal: 16),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF2A4F4F), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                            color: Color(0xFF2A4F4F), width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _onDeletePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffF16D5D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Delete",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
