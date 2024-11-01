import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class QuizAnswerPage extends StatefulWidget {
  final Quiz quiz;
  final int userAnswer;

  const QuizAnswerPage({
    super.key,
    required this.quiz,
    required this.userAnswer,
  });

  @override
  _QuizAnswerPage createState() => _QuizAnswerPage();
}

class _QuizAnswerPage extends State<QuizAnswerPage> {
  @override
  Widget build(BuildContext context) {
    List<String> choice = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6a5ae0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF6a5ae0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Quiz',
                        style: GoogleFonts.rubik(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.quiz.question,
                        style: GoogleFonts.rubik(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: widget.quiz.options.length,
                          itemBuilder: (context, index) {
                            Color optionColor;

                            
                            if ((index == widget.quiz.answer)) {
                              optionColor = Colors.green; // Correct answer selected
                            } else if ((index == widget.userAnswer) && (index != widget.quiz.answer)) {
                              optionColor = Colors.red; // Incorrect answer selected
                            } else {
                              optionColor = const Color(0xFFfeb3b3); // Default option color
                            }

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: optionColor,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                  child: Row(
                                    children: [
                                      // Option letter
                                      Padding(
                                        padding: const EdgeInsets.only(right: 10), // Spacing between letter and text
                                        child: Text(
                                          choice[index],
                                          style: GoogleFonts.rubik(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      // Option text
                                      Expanded(
                                        child: AutoSizeText(
                                          widget.quiz.options[index],
                                          style: GoogleFonts.rubik(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w400),
                                          minFontSize: 10,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
