import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fyp1/model/quiz.dart';
import 'package:fyp1/modelview/quizviewmodel.dart';
import 'package:image_picker/image_picker.dart'; // For image picking
import 'package:firebase_storage/firebase_storage.dart'; // For Firebase Storage
import 'dart:io'; // For File handling

class AddQuizPage extends StatefulWidget {
  final String chapterId;
  const AddQuizPage({super.key, required this.chapterId});

  @override
  _AddQuizPageState createState() => _AddQuizPageState();
}

class _AddQuizPageState extends State<AddQuizPage> {
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ]; // Start with 2 options
  int _selectedAnswer = 0; // Index of the correct answer
  late QuizViewModel quizViewModel;

  File? _image; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // For image picking
  bool _isUploading = false; // To track image upload state

  @override
  void initState() {
    super.initState();
    quizViewModel = Provider.of<QuizViewModel>(context, listen: false);
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
      String fileName = DateTime.now().millisecondsSinceEpoch.toString() +
          '_' +
          _image!.path.split('/').last;
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

  Future<void> _uploadQuiz() async {
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
      // Upload image if selected
      String? imageUrl = await _uploadImage();

      Quiz quiz = Quiz(
        chapter: widget.chapterId,
        question: _questionController.text,
        options:
            _optionControllers.map((controller) => controller.text).toList(),
        answer: _selectedAnswer,
        imageUrl: imageUrl, // Include the image URL
      );

      await quizViewModel.addQuiz(widget.chapterId, quiz);

      _questionController.clear();
      for (var controller in _optionControllers) {
        controller.clear();
      }
      setState(() {
        _selectedAnswer = 0;
        _image = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz added successfully!')),
      );

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error uploading quiz: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add quiz.')),
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
      appBar: AppBar(
        backgroundColor: themeColor,
        foregroundColor: Colors.white,
        title: Text(
          'Create Quiz',
          style: GoogleFonts.poppins(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Field
              Text(
                'Question',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
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
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Options Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Options',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
              const SizedBox(height: 4), // Spacing
              Text(
                'Tick the option to mark it as the correct answer.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30),
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
              const SizedBox(height: 8),
              if (_image != null)
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: FileImage(_image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: SizedBox(
                  width: 263,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadQuiz,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: _isUploading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            'Submit',
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
