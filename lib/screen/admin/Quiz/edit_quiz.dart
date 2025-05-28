import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class EditQuizPage extends StatefulWidget {
  final String chapterId;
  final String quizId;

  const EditQuizPage(
      {super.key, required this.chapterId, required this.quizId});

  @override
  _EditQuizPageState createState() => _EditQuizPageState();
}

class _EditQuizPageState extends State<EditQuizPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  int _selectedAnswer = 0;
  late QuizViewModel quizViewModel;

  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  String? _currentImageUrl;
  bool isLoading = true;
  bool _isQuestionEmpty = false;
  List<bool> _isOptionEmpty = [];

  Future<void> _fetchQuiz() async {
    Quiz quiz =
        await quizViewModel.getQuizById(widget.chapterId, widget.quizId);

    if (mounted) {
      setState(() {
        _questionController.text = quiz.question;
        _selectedAnswer = quiz.answer;
        _optionControllers.clear();
        for (var option in quiz.options) {
          _optionControllers.add(TextEditingController(text: option));
        }
        _currentImageUrl = quiz.imageUrl;
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchQuiz();
    });
  }

  void _addOption() {
    if (_optionControllers.length < 4) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 4 options allowed.'), backgroundColor: Colors.red),
      );
    }
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers.removeAt(index);
        if (_selectedAnswer >= _optionControllers.length) {
          _selectedAnswer = _optionControllers.length - 1;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Minimum of 2 options required.'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;
    setState(() {
      _isUploading = true;
    });

    try {
      String fileName =
          '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot taskSnapshot = await uploadTask;

      if (taskSnapshot.state == TaskState.success) {
        return await taskSnapshot.ref.getDownloadURL();
      } else {
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _updateQuiz() async {
    setState(() {
      _isQuestionEmpty = _questionController.text.trim().isEmpty;
      _isOptionEmpty =
          _optionControllers.map((c) => c.text.trim().isEmpty).toList();
    });

    if (_isQuestionEmpty || _isOptionEmpty.contains(true)) {
      return;
    }
    setState(() {
      _isUploading = true;
    });

    try {
      String? imageUrl = _currentImageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage();
      }

      Quiz updatedQuiz = Quiz(
        chapter: widget.chapterId,
        question: _questionController.text,
        options: _optionControllers.map((c) => c.text).toList(),
        answer: _selectedAnswer,
        imageUrl: imageUrl,
      );

      await quizViewModel.updateQuiz(
          widget.chapterId, widget.quizId, updatedQuiz);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz updated successfully!'), backgroundColor: Colors.green),
      );
      GoRouter.of(context).pop();
    } catch (e) {
      print('Error updating quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update quiz.'), backgroundColor: Colors.red,),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(title: 'Edit Quiz'),
      backgroundColor: const Color(0xffDDF4FF),
      body: isLoading
          ? const LoadingShimmer()
          : Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9F1),
                    borderRadius: BorderRadius.circular(18),
                    border:
                        Border.all(color: const Color(0xFFB5E5F4), width: 2.5),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Question',
                          style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xff2D7D84))),
                      const SizedBox(height: 8),
                      TextField(
                        maxLines: 2,
                        controller: _questionController,
                        style: GoogleFonts.poppins(fontSize: 16),
                        decoration: InputDecoration(
                          hintText: "Enter quiz question",
                          hintStyle: GoogleFonts.poppins(
                              color: const Color(0xFF7C6F64), fontSize: 16),
                          filled: true,
                          fillColor: const Color(0xFFFFF9F1),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFECE7D9), width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xFFD9CFC2), width: 2),
                          ),
                        ),
                      ),
                      if (_isQuestionEmpty)
                        const Padding(
                          padding: EdgeInsets.only(top: 4, left: 8),
                          child: Text(
                            "Question is required",
                            style: TextStyle(color: Colors.red, fontSize: 13),
                          ),
                        ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Options',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2D7D84))),
                          ElevatedButton(
                            onPressed: _addOption,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF58C6C),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                    color: Color(0xFFDB745A), width: 2),
                              ),
                            ),
                            child: const Text('Add Option',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ...List.generate(_optionControllers.length, (index) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextField(
                                          maxLines: 2,
                                          controller: _optionControllers[index],
                                          style:
                                              GoogleFonts.poppins(fontSize: 16),
                                          decoration: InputDecoration(
                                            hintText: "Option ${index + 1}",
                                            hintStyle: GoogleFonts.poppins(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.w500),
                                            filled: true,
                                            fillColor: const Color(0xFFFFF9F1),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 12),
                                            enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFECE7D9),
                                                  width: 1.5),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              borderSide: const BorderSide(
                                                  color: Color(0xFFD9CFC2),
                                                  width: 2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle,
                                            color: Colors.red),
                                        onPressed: () => _removeOption(index),
                                      ),
                                      Radio<int>(
                                        value: index,
                                        groupValue: _selectedAnswer,
                                        onChanged: (value) => setState(
                                            () => _selectedAnswer = value!),
                                        activeColor: const Color(0xff2D7D84),
                                      ),
                                    ],
                                  ),
                                  if (_isOptionEmpty.length > index &&
                                      _isOptionEmpty[index])
                                    const Padding(
                                      padding: EdgeInsets.only(top: 4, left: 8),
                                      child: Text(
                                        "Option can not be blank",
                                        style: TextStyle(
                                            color: Colors.red, fontSize: 13),
                                      ),
                                    ),
                                ]));
                      }),
                      const SizedBox(height: 4),
                      Text('Tick the option to mark it as the correct answer.',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.grey[600])),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Image (Optional)',
                              style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xff2D7D84))),
                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF58C6C),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: const BorderSide(
                                    color: Color(0xFFDB745A), width: 2),
                              ),
                            ),
                            child: Text(
                              _image == null ? 'Add Image' : 'Change Image',
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (_currentImageUrl != null || _image != null)
                        Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: _image != null
                                  ? FileImage(_image!)
                                  : NetworkImage(_currentImageUrl!)
                                      as ImageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _updateQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF58C6C),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(
                                  color: Color(0xFFDB745A), width: 2),
                            ),
                          ),
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : const Text('Update',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
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
