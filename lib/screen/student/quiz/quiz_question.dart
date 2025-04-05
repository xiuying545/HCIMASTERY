import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QuizPage extends StatefulWidget {
  final List<Quiz> quizzes;
  final int questionIndex;

  const QuizPage({
    super.key,
    required this.quizzes,
    required this.questionIndex,
  });

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  late UserViewModel userViewModel;
  late QuizViewModel quizViewModel;

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.questionIndex;
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    setUpInitialData();
  }

  Future<void> setUpInitialData() async {
    await quizViewModel.loadData(
        userViewModel.userId!, widget.quizzes[0].chapter);
  }

  @override
  Widget build(BuildContext context) {
    final quiz = widget.quizzes[currentQuestionIndex];
    final quizId = widget.quizzes[currentQuestionIndex].quizzID;
    final choices = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.blue.shade700.withOpacity(0.9)),
          onPressed: () async {
            await quizViewModel.saveAllAnswersToFirestore();
            if (context.mounted) {
              GoRouter.of(context).pop();
            }
          },
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          '${currentQuestionIndex + 1} Of ${widget.quizzes.length} Question',
          style: GoogleFonts.poppins(
            fontSize: 18.0,
            fontWeight: FontWeight.w900,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // Progress Bar
            Container(
              width: double.infinity,
              padding: EdgeInsets.zero,
              child: SizedBox(
                height: 8,
                child: LinearProgressIndicator(
                  value: (currentQuestionIndex + 1) / widget.quizzes.length,
                  backgroundColor: Colors.blue.shade700.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.blue.shade700.withOpacity(0.9)),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    // Quiz Image
                    quiz.imageUrl != null
                        ? Image.network(
                            quiz.imageUrl!,
                            width: 400,
                            height: 200,
                          )
                        : const SizedBox.shrink(),
                    const SizedBox(height: 20),
                    // Question Text
                    Text(
                      quiz.question,
                      style: GoogleFonts.poppins(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 20),
                    // Options List

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: quiz.options.length,
                      itemBuilder: (context, index) {
                        final isSelected =
                            quizViewModel.cachedAnswers[quizId] == index;
                        final backgroundColor = isSelected
                            ? Colors.blue.shade400.withOpacity(0.9)
                            : Colors.white;
                        final textColor =
                            isSelected ? Colors.white : Colors.transparent;

                        return Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 5, 15),
                          child: GestureDetector(
                            onTap: () async {
                              await quizViewModel.saveAnswerLocally(
                                  quizId!, index);

                              updateQuestionIndex();
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeInOut,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: backgroundColor,
                                border: Border.all(
                                  color: Colors.blue.shade400.withOpacity(0.9),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 5,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(10, 5, 5, 5),
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: textColor,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 12),
                                        child: Text(
                                          choices[index],
                                          style: GoogleFonts.poppins(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 10),
                                        child: AutoSizeText(
                                          quiz.options[index],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500,
                                            color: isSelected
                                                ? Colors.white
                                                : Colors.black,
                                          ),
                                          minFontSize: 10,
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (currentQuestionIndex > 0)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  currentQuestionIndex--;
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Colors.blue.shade700.withOpacity(0.9),
                                elevation: 4,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(15),
                              ),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Colors.blue.shade700.withOpacity(0.9),
                              elevation: 4,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(15),
                            ),
                            onPressed: () {
                              setState(() {
                                if (currentQuestionIndex <
                                    widget.quizzes.length - 1) {
                                  currentQuestionIndex++;
                                } else {
                                  _showCompletionDialog(context);
                                }
                              });
                            },
                            child: Icon(
                              currentQuestionIndex == widget.quizzes.length - 1
                                  ? Icons.check
                                  : Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateQuestionIndex() {
    setState(() {
      if (currentQuestionIndex < widget.quizzes.length - 1) {
        currentQuestionIndex++;
      } else {
        completeQuiz();
      }
    });
  }

  Future<void> completeQuiz() async {
    await quizViewModel.saveAllAnswersToFirestore();
    _showCompletionDialog(context);
  }

  void _showCompletionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(

        title: 'Quiz Completed!',
        content:
            'You have completed the quiz! Do you want to submit your answers?',
        action: 'Completion',
        onConfirm: () {
          GoRouter.of(context).push(
              "/student/quizResult/${widget.quizzes[currentQuestionIndex].chapter}");
        },
      ),
    );
  }
}
