// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/modelview/noteviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class AddNotePage extends StatefulWidget {
  final chapterId;
  const AddNotePage({super.key, required this.chapterId});

  @override
  _AddNotePage createState() => _AddNotePage();
}

class _AddNotePage extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<TextEditingController> _videoControllers = [TextEditingController()];
  List<File> _images = [];
  final _picker = ImagePicker();
  late NoteViewModel noteViewModel;

  @override
  void initState() {
    super.initState();
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);
  }

  void _addVideoField() {
    setState(() {
      _videoControllers.add(TextEditingController());
    });
  }

  void _removeVideoField(int index) {
    setState(() {
      _videoControllers.removeAt(index);
    });
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

  Future<void> _uploadNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    List<String> imageUrls = [];
    List<String> videoLinks = _videoControllers
        .map((controller) => controller.text.trim())
        .where((link) => link.isNotEmpty)
        .toList();

    try {
      for (File image in _images) {
        String fileName = image.path.split('/').last;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('notes/$fileName');
        UploadTask uploadTask = storageRef.putFile(image);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        imageUrls.add(downloadUrl);
      }

      Note note = Note(
        title: _titleController.text,
        content: _contentController.text,
        images: imageUrls,
        videoLink: videoLinks,
      );

      await noteViewModel.addNoteToChapter(widget.chapterId, note);

      _titleController.clear();
      _contentController.clear();
      _videoControllers.forEach((controller) => controller.clear());
      setState(() {
        _images.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added successfully!')),
      );

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error uploading note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add note.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFefeefb),
        foregroundColor: Colors.black,
        title: Text(
          'Create Note',
          style:
              GoogleFonts.rubik(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
      ),
      backgroundColor: const Color(0xFFefeefb),
      body: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Title',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                elevation: 1,
                shadowColor: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 63,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
           color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter note's title",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Upload Images',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: IconButton(
                    iconSize: 80,
                    color: const Color(0xff4a56c1),
                    onPressed: _pickImages,
                    icon: const Icon(Icons.insert_photo),
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
                            Image.file(_images[index]),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeImage(index),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const Center(
                      child: Text('No images selected'),
                    ),
              const SizedBox(height: 30),
              const Text(
                'Content',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Material(
                elevation: 1,
            
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  height: 150, // Increase height for multiline content
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                   color:Colors.white
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: TextField(
                      controller: _contentController,
                      maxLines: null, // Allows for multiple lines
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter note's content",
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Video Links',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: _videoControllers
                    .asMap()
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Material(
                                  elevation: 1,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(4),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4),
                                      color:  Colors.white,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: TextField(
                                        controller: entry.value,
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter video link",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () => _removeVideoField(entry.key),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ),
              const SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: _addVideoField,
                  child: const Text('Add Video Link'),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: SizedBox(
                  width: 263,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _uploadNote,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                      backgroundColor: const Color(0xff4a56c1),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
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