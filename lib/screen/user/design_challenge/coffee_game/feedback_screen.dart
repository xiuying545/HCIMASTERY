import 'package:flutter/material.dart';
import 'package:fyp1/screen/user/design_challenge/coffee_game/explanation_page.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  _FeedbackScreenState createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  String? selectedFlow;
  String feedbackText = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _feedbackController = TextEditingController();
  String? flowErrorText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFB5EAD7),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("📋 Feedback Time",
            style: TextStyle(color: Colors.brown)),
        leading: const BackButton(color: Colors.brown),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '🌈 Which flow did you like better?',
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
             

                const SizedBox(height: 20),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Flow A (Step-by-step)',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Radio<String>(
                          value: 'A',
                          groupValue: selectedFlow,
                          onChanged: (String? value) {
                            setState(() {
                              selectedFlow = value;
                            });
                          },
                        ),
                      ),
                      const Divider(height: 1, indent: 20, endIndent: 20),
                      ListTile(
                        title: Text(
                          'Flow B (All-in-one)',
                          style: GoogleFonts.fredoka(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        leading: Radio<String>(
                          value: 'B',
                          groupValue: selectedFlow,
                          onChanged: (String? value) {
                            setState(() {
                              selectedFlow = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                   if (flowErrorText != null)
                  Padding(
    padding: const EdgeInsets.only(top: 8.0, left: 8.0),
    child: Text(
      flowErrorText!,
      style: TextStyle(color: Colors.red[700], fontSize: 14),
    ),
  ),
                const SizedBox(height: 30),
                Text(
                  '💬 Why did you prefer it?',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.brown[800],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF9F4E8),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextFormField(
                      controller: _feedbackController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Share your thoughts...',
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please provide your feedback.';
                        }
                        return null;
                      },
                      onChanged: (text) {
                        feedbackText = text;
                      },
                      maxLines: 6,
                      minLines: 4,
                      keyboardType: TextInputType.multiline,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFA69E),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  onPressed: () {
  setState(() {
    flowErrorText = selectedFlow == null ? 'Please select a flow.' : null;
  });

  if (_formKey.currentState!.validate() && selectedFlow != null) {
    feedbackText = _feedbackController.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ExplanationScreen(),
      ),
    );
  }
},
                    child: const Text(
                      'Submit 🎉',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
