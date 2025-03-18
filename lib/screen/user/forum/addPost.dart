// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<File> _images = [];
  final _picker = ImagePicker();
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
  }

  // Function to pick images from the gallery
  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  // Function to remove an image from the list
  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    List<String> imageUrls = [];

    try {
      for (File image in _images) {
        if (!image.existsSync()) {
          print('File does not exist: ${image.path}');
          continue;
        }

        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child('forum/$fileName');

        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {}).catchError((error) {
          print('Error uploading file: $error');
          throw error;
        });

        if (taskSnapshot.state == TaskState.success) {
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
          print('File uploaded successfully: $downloadUrl');
        } else {
          print('Upload failed for file: ${image.path}');
        }
      }

      Post post = Post(
        title: _titleController.text,
        content: _contentController.text,
        creator: userViewModel.userId!,
        timeCreated: DateTime.now(),
        images: imageUrls,
        editStatus: false,
      );

      await Provider.of<ForumViewModel>(context, listen: false).addPost(post);

      _titleController.clear();
      _contentController.clear();
      setState(() {
        _images.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post created successfully!')),
      );

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error uploading post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create post. Please try again.')),
      );
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
          'Create Post',
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
              // Title Field
              Text(
                'Title',
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
                      controller: _titleController,
                      style: GoogleFonts.poppins(fontSize: 16),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter post title",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Image Upload Section
              Text(
                'Upload post images',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: _pickImages,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Icon(
                      Icons.add_photo_alternate,
                      size: 40,
                      color: themeColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              _images.isNotEmpty
                  ? SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _images.length,
                        itemBuilder: (context, index) => Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                _images[index],
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close, color: Colors.red),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Center(
                      child: Text(
                        'No images selected',
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    ),
              const SizedBox(height: 30),

              // Content Field
              Text(
                'Content',
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
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: TextField(
                      controller: _contentController,
                      style: GoogleFonts.poppins(fontSize: 16),
                      maxLines: null,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter post content",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Submit Button
              Center(
                child: SizedBox(
                  width: 263,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _uploadPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
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