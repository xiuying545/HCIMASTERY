// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:fyp1/services/post_service.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditPostPage extends StatefulWidget {
  final String postId; // Pass the post ID to edit
  const EditPostPage({super.key, required this.postId});

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
    late ForumViewModel forumViewModel;
      late UserViewModel userViewModel;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<File> _images = [];
  final _picker = ImagePicker();


  @override
  void initState() {
    super.initState();
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
        userViewModel = Provider.of<UserViewModel>(context, listen: false);
    forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    
    
      await forumViewModel.fetchPostById(widget.postId);
      _titleController.text =   forumViewModel.post.title;
      _contentController.text = forumViewModel.post.content;
    } catch (e) {
      print('Error loading post: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to load post.')));
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _editPost() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }
    List<String> imageUrls = [];

    try {
      for (File image in _images) {
        String fileName = image.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('book_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      // Create the updated Post object
      Post post = Post(
        postID: widget.postId,
        title: _titleController.text,
        content: _contentController.text,
        creator: forumViewModel.post.creator,
        timeCreated: DateTime.now(),
        images: imageUrls,
        editStatus: true,
      );

      await PostService().editPost(post);

      _titleController.clear();
      _contentController.clear();
      setState(() {
        _images.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Post updated successfully!')));
      GoRouter.of(context).pop();
    } catch (e) {
      print('Error updating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update post.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Colors.blue.shade900;

    return Scaffold(
      appBar: const AppBarWithBackBtn(
        title: 'Edit Post',
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
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w500),
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
                                icon:
                                    const Icon(Icons.close, color: Colors.red),
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
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey, fontWeight: FontWeight.w500),
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
                    onPressed: _editPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: themeColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
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
