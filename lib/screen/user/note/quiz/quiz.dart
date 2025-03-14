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

  const QuizPage({
    super.key,
    required this.quizzes,
    required this.questionIndex,
  });

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
    final quiz = widget.quizzes[currentQuestionIndex];
    final quizId = quiz.quizzID ?? '-1';
    final choices = ['A', 'B', 'C', 'D'];

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(quizViewModel, quiz, quizId, choices),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.blue.shade700.withOpacity(0.9)),
        onPressed: () => GoRouter.of(context).pop(),
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
    );
  }

  Widget _buildBody(QuizViewModel quizViewModel, Quiz quiz, String quizId, List<String> choices) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          _buildProgressBar(),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _buildQuizImage(),
                  const SizedBox(height: 20),
                  _buildQuestionText(quiz.question),
                  const SizedBox(height: 20),
                  _buildOptionsList(quizViewModel, quiz, quizId, choices),
                  const SizedBox(height: 20),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 8,
        child: LinearProgressIndicator(
          value: (currentQuestionIndex + 1) / widget.quizzes.length,
          backgroundColor: Colors.blue.shade700.withOpacity(0.2),
          valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade700.withOpacity(0.9)),
        ),
      ),
    );
  }

  Widget _buildQuizImage() {
    return Image.asset(
      'assets/Animation/book.png',
      width: 400,
      height: 200,
    );
  }

  Widget _buildQuestionText(String question) {
    return Text(
      question,
      style: GoogleFonts.poppins(
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildOptionsList(QuizViewModel quizViewModel, Quiz quiz, String quizId, List<String> choices) {
    return FutureBuilder<int>(
      future: quizViewModel.getUserAnswer(
        userViewModel.userId!,
        quiz.chapter,
        quizId,
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
          itemCount: quiz.options.length,
          itemBuilder: (context, index) {
            return _buildOptionItem(quizViewModel, quiz, quizId, choices, index, userAnswer);
          },
        );
      },
    );
  }

  Widget _buildOptionItem(QuizViewModel quizViewModel, Quiz quiz, String quizId, List<String> choices, int index, int userAnswer) {
    final isSelected = userAnswer == index;
    final backgroundColor = isSelected ? Colors.blue.shade400.withOpacity(0.9) : Colors.white;
    final textColor = isSelected ? Colors.white : Colors.transparent;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 5, 5, 15),
      child: GestureDetector(
        onTap: () async {
          await quizViewModel.saveAnswer(userViewModel.userId!, quiz.chapter, quizId, index);
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
            padding:EdgeInsets.fromLTRB(10, 5, 5, 5),
            child:Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: textColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
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
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: AutoSizeText(
                    quiz.options[index],
                    style: GoogleFonts.poppins(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                      color: isSelected?Colors.white:Colors.black,
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
  }

  Widget _buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: currentQuestionIndex > 0,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  if (currentQuestionIndex > 0) {
                    currentQuestionIndex--;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700.withOpacity(0.9),
                elevation: 4,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(15),
              ),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700.withOpacity(0.9),
              elevation: 4,
              shape: const CircleBorder(),
              padding: const EdgeInsets.all(15),
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
              currentQuestionIndex == widget.quizzes.length - 1 ? Icons.check : Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
    builder: (ctx) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Rounded corners
      ),
      elevation: 10, // Add shadow for depth
      backgroundColor: Colors.white, // Light background for contrast
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Fit content
          children: [
            // Icon and Title
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade700, // Green for success
                  size: 32,
                ),
                const SizedBox(width: 12),
                Text(
                  'Quiz Completed!',
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Message
            Text(
              'You have completed the quiz! Do you want to submit your answers?',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Review Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(); // Close the dialog
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    side: BorderSide(color: Colors.grey.shade400),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Review',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ),

                // Submit Button
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context).push("/student/quizResult/${widget.quizzes[currentQuestionIndex].chapter}");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: Colors.green.shade700, // Green for primary action
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Submit',
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
    ),
  );
}
}