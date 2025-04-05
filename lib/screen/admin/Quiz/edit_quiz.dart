import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'dart:io'; // For File handling

class EditQuizPage extends StatefulWidget {
  final String chapterId;
  final String quizId;

  const EditQuizPage({
    super.key,
    required this.chapterId,
    required this.quizId,
  });

  @override
  _EditQuizPageState createState() => _EditQuizPageState();
}

class _EditQuizPageState extends State<EditQuizPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [];
  int _selectedAnswer = 0;
  late QuizViewModel quizViewModel;
  bool _isLoading = true;

  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // For image picking
  bool _isUploading = false; // To track image upload state
  String? _currentImageUrl; // To store the current image URL

  Future<void> _fetchQuiz() async {
    Quiz quiz = await quizViewModel.getQuizById(widget.chapterId, widget.quizId);


    if (mounted) {
      setState(() {
        _questionController.text = quiz.question;
        _selectedAnswer = quiz.answer;
        _optionControllers.clear();
        for (var option in quiz.options) {
          _optionControllers.add(TextEditingController(text: option));
        }
        _currentImageUrl = quiz.imageUrl; // Set the current image URL
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
    _fetchQuiz();
  }

  void _addOption() {
    if (_optionControllers.length < 4) {
      setState(() {
        _optionControllers.add(TextEditingController());
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum of 4 options allowed.')),
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
        const SnackBar(content: Text('Minimum of 2 options required.')),
      );
    }
  }

  // Pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Upload image to Firebase Storage
  Future<String?> _uploadImage() async {
    if (_image == null) return null;

    setState(() {
      _isUploading = true;
    });

    try {
      String fileName = '${DateTime.now().millisecondsSinceEpoch}_${_image!.path.split('/').last}';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);

      print('Uploading file: ${_image!.path}');
      print('File size: ${_image!.lengthSync()} bytes');
      print('File name: $fileName');

      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot taskSnapshot =
          await uploadTask.whenComplete(() {}).catchError((error) {
        print('Error uploading file: $error');
        throw error;
      });

      if (taskSnapshot.state == TaskState.success) {
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        print('File uploaded successfully: $downloadUrl');
        return downloadUrl;
      } else {
        print('Upload failed for file: ${_image!.path}');
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
    if (_questionController.text.isEmpty ||
        _optionControllers.any((controller) => controller.text.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      // Upload new image if selected
      String? imageUrl = _currentImageUrl;
      if (_image != null) {
        imageUrl = await _uploadImage();
      }

      Quiz updatedQuiz = Quiz(
        chapter: widget.chapterId,
        question: _questionController.text,
        options:
            _optionControllers.map((controller) => controller.text).toList(),
        answer: _selectedAnswer,
        imageUrl: imageUrl, // Include the image URL
      );

      await quizViewModel.updateQuiz(
          widget.chapterId, widget.quizId, updatedQuiz);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz updated successfully!')),
      );

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error updating quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update quiz.')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;

    return Scaffold(
   appBar: const AppBarWithBackBtn(
        title: 'Edit Quiz',
      ),
      backgroundColor: Colors.grey.shade100,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(22.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Field
                    Text(
                      'Question',
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      elevation: 4,
                      shadowColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        height: 63,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            controller: _questionController,
                            style: GoogleFonts.poppins(fontSize: 16),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter quiz question",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // Options Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Options',
                          style: GoogleFonts.poppins(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ElevatedButton(
                          onPressed: _addOption,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            'Add Option',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    ...List.generate(_optionControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Material(
                          elevation: 4,
                          shadowColor: Colors.grey.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _optionControllers[index],
                                      style: GoogleFonts.poppins(fontSize: 16),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Option ${index + 1}",
                                        hintStyle: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w500),
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
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAnswer = value!;
                                      });
                                    },
                                    activeColor: themeColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 4),
                    Text(
                      'Tick the option to mark it as the correct answer.',
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 40),
                    // Image Upload Section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Image (Optional)',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: _pickImage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                          ),
                          child: Text(
                            _image == null ? 'Add Image' : 'Change Image',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (_currentImageUrl != null || _image != null)
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: _image != null
                                ? FileImage(_image!) // Show selected image
                                : NetworkImage(_currentImageUrl!)
                                    as ImageProvider, // Show current image
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    const SizedBox(height: 40),
                    // Update Button
                    Center(
                      child: SizedBox(
                        width: 263,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isUploading ? null : _updateQuiz,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: themeColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: _isUploading
                              ? const CircularProgressIndicator(
                                  color: Colors.white)
                              : Text(
                                  'Update',
                                  style: GoogleFonts.poppins(
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
