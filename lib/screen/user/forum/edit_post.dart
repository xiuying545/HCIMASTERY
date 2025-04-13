// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/loading_dialog.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/services/post_service.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class EditPostPage extends StatefulWidget {
  final String postId;
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
  List<String>? _existingImageUrls = [];
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
       userViewModel = Provider.of<UserViewModel>(context, listen: false);
      forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
  
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
   

      await forumViewModel.fetchPostById(widget.postId);
       setState(() {
      _titleController.text = forumViewModel.post.title;
      _contentController.text = forumViewModel.post.content;
        _existingImageUrls = forumViewModel.post.images;
           });
        print('Error loading post: $_existingImageUrls');
    } catch (e) {
      print('Error loading post: $e');
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Failed to load post.')));
    }
  }

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _images.addAll(pickedFiles.map((file) => File(file.path)));
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

    LoadingDialog.show(context, "Updating your post...");
List<String> imageUrls = List.from(_existingImageUrls ?? []);

    try {
      for (File image in _images) {
        if (!image.existsSync()) continue;

        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef =
            FirebaseStorage.instance.ref().child('forum/$fileName');

        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;

        if (taskSnapshot.state == TaskState.success) {
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          imageUrls.add(downloadUrl);
        }
      }

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
        if(_existingImageUrls!=null) {
          _existingImageUrls!.clear();
        }
      });

      LoadingDialog.hide(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Post updated successfully!')),
      );
      GoRouter.of(context).pop();
    } catch (e) {
      LoadingDialog.hide(context);
      print('Error updating post: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update post.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(title: 'Edit Post'),
      backgroundColor: const Color(0xffDDF4FF),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF9F1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFB5E5F4), width: 2.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff2D7D84))),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: "Enter post title",
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF7C6F64), fontSize: 16),
                    filled: true,
                    fillColor: const Color(0xFFFFF9F1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFECE7D9), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD9CFC2), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Text('Upload post images', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff2D7D84))),
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
                        border: Border.all(color: const Color(0xff2D7D84), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/Animation/upload.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (_existingImageUrls==null && _images.isEmpty)
                  Center(child: Text('No images selected', style: GoogleFonts.poppins(color: Colors.grey)))
                else
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                          if (_existingImageUrls!=null)
                        ..._existingImageUrls!.asMap().entries.map((entry) {
                          int index = entry.key;
                          String url = entry.value;
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url, width: 100, height: 100, fit: BoxFit.cover,  loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error, color: Colors.red);
                              },),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => setState(() => _existingImageUrls!.removeAt(index)),
                                ),
                              ),
                            ],
                          );
                        }),
                        ..._images.asMap().entries.map((entry) {
                          int index = entry.key;
                          File file = entry.value;
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(file, width: 100, height: 100, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  onPressed: () => setState(() => _images.removeAt(index)),
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                const SizedBox(height: 30),
                Text('Content', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff2D7D84))),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter post content",
                    hintStyle: GoogleFonts.poppins(color: const Color(0xFF7C6F64), fontSize: 16),
                    filled: true,
                    fillColor: const Color(0xFFFFF9F1),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFECE7D9), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFD9CFC2), width: 2),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _editPost,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF58C6C),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Color(0xFFDB745A), width: 2),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
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
