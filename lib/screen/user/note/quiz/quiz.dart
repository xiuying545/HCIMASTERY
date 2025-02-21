import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final List<Quiz> quizzes;
  final int questionIndex;

  const QuizPage({super.key, required this.quizzes, required this.questionIndex});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  late int currentQuestionIndex;
   late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.questionIndex;
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    String quizId = widget.quizzes[currentQuestionIndex].quizzID ?? '-1';
    List<String> choice = ['A', 'B', 'C', 'D'];

    // Define colors
    const primaryColor = Color(0xFFF4F6F9); // Soft Purple
    const secondaryColor = Color(0xFF6a5ae0); // Soft Orange
    const backgroundColor = Color(0xFFF4F6F9); // Light Greyish-White
    const buttonColor = primaryColor;
    const buttonTextColor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: buttonTextColor),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        // title: Text(
        //   'Quiz',
        //   style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: buttonTextColor),
        // ),
      ),
      body: Container(
        color: backgroundColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Question ${currentQuestionIndex + 1}',
                        style: GoogleFonts.rubik(fontSize: 28.0, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        widget.quizzes[currentQuestionIndex].question,
                        style: GoogleFonts.rubik(fontSize: 22.0, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                      FutureBuilder<int>(
                        future: quizViewModel.getUserAnswer(
                          userViewModel.userId!,
                          widget.quizzes[currentQuestionIndex].chapter,
                          widget.quizzes[currentQuestionIndex].quizzID ?? '-1',
                        ),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text("Error: ${snapshot.error}");
                          }

                          int userAnswer = snapshot.data ?? -1;

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: widget.quizzes[currentQuestionIndex].options.length,
                            itemBuilder: (context, index) {
                              Color color = (userAnswer == index)
                                  ? const Color(0xFFFFDAB9) // Light Peach for selected option
                                  : const Color(0xFFF2F2F2); // Light Grey for unselected option

                              return Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                                child: GestureDetector(
                                  onTap: () async {
                                    await quizViewModel.saveAnswer(
                                        userViewModel.userId!,
                                        widget.quizzes[currentQuestionIndex].chapter,
                                        quizId,
                                        index);
                                    updateQuestionIndex();
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeInOut,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: color,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.1),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: secondaryColor,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            child: Text(
                                              choice[index],
                                              style: GoogleFonts.rubik(fontSize: 24.0, fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                            child: AutoSizeText(
                                              widget.quizzes[currentQuestionIndex].options[index],
                                              style: GoogleFonts.rubik(fontSize: 18.0, fontWeight: FontWeight.w400),
                                              minFontSize: 10,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: currentQuestionIndex > 0,
                            child: Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    if (currentQuestionIndex > 0) {
                                      currentQuestionIndex--;
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  elevation: 1,
                                  side: const BorderSide(color: primaryColor, width: 2),
                                  shadowColor: Colors.transparent,
                                  shape: const CircleBorder(),
                                  minimumSize: const Size(50, 50),
                                ),
                                child: const Icon(Icons.arrow_back_ios, color: Colors.black,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(1.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                elevation: 1,
                                side: const BorderSide(color: primaryColor, width: 2),
                                shadowColor: Colors.transparent,
                                shape: const CircleBorder(),
                                minimumSize: const Size(50, 50),
                              ),
                              onPressed: () {
                                setState(() {
                                  if (currentQuestionIndex < widget.quizzes.length - 1) {
                                    currentQuestionIndex++;
                                  } else {
                                    _showCompletionDialog(context);
                                  }
                                });
                              },
                              child: Icon(
                                currentQuestionIndex == widget.quizzes.length - 1
                                    ? Icons.check
                                    : Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
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

  void updateQuestionIndex() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (currentQuestionIndex < widget.quizzes.length - 1) {
          currentQuestionIndex++;
        } else {
          _showCompletionDialog(context);
        }
      });
    });
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF6a5ae0),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Quiz Completed', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'You have completed the quiz! Do you want to submit your answers?',
          style: TextStyle(color: Colors.white),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Submit', style: TextStyle(color: Colors.white)),
            onPressed: () {
              // Handle submission logic here
               GoRouter.of(context).push("/student/quizResult/${widget.quizzes[currentQuestionIndex].chapter}");
            },
          ),
          TextButton(
            child: const Text('Review', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
