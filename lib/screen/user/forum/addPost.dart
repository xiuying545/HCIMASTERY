import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<File> _imageFiles = [];

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    setState(() {
      _imageFiles.addAll(pickedFiles.map((file) => File(file.path)));
    });
    }

  Future<void> _createPost() async {
    String? imageUrl;

    // Upload images to Firebase Storage and get their URLs
    List<String> imageUrls = [];
    for (var imageFile in _imageFiles) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('post_images/${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}');
      await storageRef.putFile(imageFile);
      imageUrl = await storageRef.getDownloadURL();
      imageUrls.add(imageUrl);
    }

    // Save post to Firestore
    await FirebaseFirestore.instance.collection('Forum').add({
      'title': _titleController.text,
      'content': _contentController.text,
      'images': imageUrls, // Store the list of image URLs
      'timeCreated': DateTime.now(),
    });

    // Clear fields and images
    _titleController.clear();
    _contentController.clear();
    setState(() {
      _imageFiles.clear();
    });

    Navigator.pop(context); // Go back to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _pickImages,
              child: const Text('Select Images'),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: _imageFiles.map((file) {
                return SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.file(file, fit: BoxFit.cover),
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _createPost,
              child: const Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
