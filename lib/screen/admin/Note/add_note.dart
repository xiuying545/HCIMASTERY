// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/loading_dialog.dart';
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
  final List<TextEditingController> _videoControllers = [
    TextEditingController()
  ];
  final List<File> _images = [];
  final _picker = ImagePicker();
  late NoteViewModel noteViewModel;
  bool _isTitleEmpty = false;
  bool _isContentEmpty = false;

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
      _images.addAll(pickedFiles.map((file) => File(file.path)));
    });
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _uploadNote() async {
    setState(() {
      _isTitleEmpty = _titleController.text.trim().isEmpty;
      _isContentEmpty = _contentController.text.trim().isEmpty;
    });

    if (_isTitleEmpty || _isContentEmpty) {
      return;
    }

    LoadingDialog.show(context, "Uploading your note...");

    List<String> imageUrls = [];
    List<String> videoLinks = _videoControllers
        .map((controller) => controller.text.trim())
        .where((link) => link.isNotEmpty)
        .toList();

    try {
      for (File image in _images) {
        String fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.path.split('/').last}';
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
        order: noteViewModel.notes.length,
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

      LoadingDialog.hide(context);
      GoRouter.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note added successfully!')),
      );
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
      appBar: const AppBarWithBackBtn(title: 'Create Note'),
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
                Text('Title',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2D7D84))),
                const SizedBox(height: 8),
                TextField(
                  controller: _titleController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Enter note title",
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
                      borderSide:
                          const BorderSide(color: Color(0xFFD9CFC2), width: 2),
                    ),
                  ),
                ),
                if (_isTitleEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 8),
                    child: Text(
                      "Title is required",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 30),
                Text('Upload Images',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2D7D84))),
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
                        border: Border.all(
                            color: const Color(0xff2D7D84), width: 2),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset("assets/Animation/upload.png"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                _images.isNotEmpty
                    ? SizedBox(
                        height: 150,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _images.length,
                          itemBuilder: (context, index) => Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(_images[index],
                                    height: 150, fit: BoxFit.cover),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close,
                                      color: Colors.red),
                                  onPressed: () => _removeImage(index),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : Center(
                        child: Text('No images selected',
                            style: GoogleFonts.poppins(color: Colors.grey)),
                      ),
                const SizedBox(height: 30),
                Text('Content',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2D7D84))),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  style: GoogleFonts.poppins(fontSize: 16),
                  maxLines: 15,
                  decoration: InputDecoration(
                    hintText: "Enter note content",
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
                      borderSide:
                          const BorderSide(color: Color(0xFFD9CFC2), width: 2),
                    ),
                  ),
                ),
                if (_isContentEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 4, left: 8),
                    child: Text(
                      "Content is required",
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    ),
                  ),
                const SizedBox(height: 30),
                Text('Video Links',
                    style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xff2D7D84))),
                Column(
                  children: _videoControllers.asMap().entries.map((entry) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: entry.value,
                              style: GoogleFonts.poppins(fontSize: 16),
                              decoration: InputDecoration(
                                hintText: "Enter video link",
                                hintStyle: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
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
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () => _removeVideoField(entry.key),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                Center(
                  child: ElevatedButton(
                    onPressed: _addVideoField,
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
                    child: const Text(
                      'Add Video Link',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _uploadNote,
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
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
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
