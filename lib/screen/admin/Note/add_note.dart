import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common_widget/app_bar_with_back.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
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
  final List<TextEditingController> _videoControllers = [TextEditingController()];
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
        String fileName = '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
        Reference storageRef = FirebaseStorage.instance.ref().child('notes/$fileName');
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
      for (var controller in _videoControllers) {
        controller.clear();
      }
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
    final themeColor = Colors.blue.shade900;

    return Scaffold(
     appBar: const AppBarWithBackBtn(
        title: 'Create Note',
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
                        hintText: "Enter note title",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Image Upload Section
              Text(
                'Upload Images',
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
                        hintText: "Enter note content",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Video Links Section
              Text(
                'Video Links',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: _videoControllers
                    .asMap()
                    .entries
                    .map((entry) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              Expanded(
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
                                      child: TextField(
                                        controller: entry.value,
                                        style: GoogleFonts.poppins(fontSize: 16),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Enter video link",
                                          hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.remove_circle, color: Colors.red),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    'Add Video Link',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
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
                    onPressed: _uploadNote,
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