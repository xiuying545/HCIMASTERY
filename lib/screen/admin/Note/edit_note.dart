// ignore_for_file: use_build_context_synchronously

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/note.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

import 'package:provider/provider.dart';

class EditNotePage extends StatefulWidget {
  final String noteId;
  final String chapterId;
  const EditNotePage({super.key, required this.noteId, required this.chapterId});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  List<TextEditingController> _videoControllers = [TextEditingController()];
  List<File> _images = [];
  List<String> _existingImageUrls = [];
  final _picker = ImagePicker();
  late NoteViewModel noteViewModel;
  Note? _existingNote;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    noteViewModel = Provider.of<NoteViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchNoteData();
    });
  }

  Future<void> _fetchNoteData() async {
    try {
      Note? fetchedNote = await noteViewModel.getNoteById(widget.chapterId, widget.noteId);
      if (fetchedNote != null) {
        setState(() {
          _existingNote = fetchedNote;
          _titleController.text = fetchedNote.title;
          _contentController.text = fetchedNote.content;
          _videoControllers = fetchedNote.videoLink?.map((link) => TextEditingController(text: link)).toList() ?? [];
          _existingImageUrls = fetchedNote.images ?? [];
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching note data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load note data.')),
      );
    }
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

  void _removeExistingImage(int index) {
    setState(() {
      if(_existingImageUrls.isNotEmpty) {
        _existingImageUrls.removeAt(index);
      }
    });
  }

  Future<void> _uploadNote() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all the fields.')),
      );
      return;
    }

    List<String> imageUrls =  List.from(_existingImageUrls);
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

      Note updatedNote = Note(
        noteID: widget.noteId,
        title: _titleController.text,
        content: _contentController.text,
        images: imageUrls,
        videoLink: videoLinks,
        order: _existingNote!.order,
      );

      await noteViewModel.updateNote(widget.chapterId, updatedNote);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note updated successfully!')),
      );

      GoRouter.of(context).pop();
    } catch (e) {
      print('Error updating note: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update note.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(title: 'Edit Note'),
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
                        decoration: InputDecoration(
                          hintText: "Enter note title",
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
                      Text('Upload Images', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff2D7D84))),
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
                      if (_existingImageUrls.isNotEmpty || _images.isNotEmpty)
                
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: [
                              if(_existingImageUrls.isNotEmpty)
                              ..._existingImageUrls.asMap().entries.map((entry) {
                                int index = entry.key;
                                String url = entry.value;
                                return Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (context, child, loadingProgress) {
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
                                        },
                                      ),
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.close, color: Colors.red),
                                        onPressed: () => _removeExistingImage(index),
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
                                        onPressed: () => _removeImage(index),
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
                        maxLines: 15,
                        decoration: InputDecoration(
                          hintText: "Enter note content",
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
                      Text('Video Links', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xff2D7D84))),
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
                                      hintStyle: GoogleFonts.poppins(color: Colors.grey, fontWeight: FontWeight.w500),
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
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle, color: Colors.red),
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
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Color(0xFFDB745A), width: 2),
                            ),
                          ),
                          child: const Text(
                            'Add Video Link',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Center(
                        child: ElevatedButton(
                          onPressed: _uploadNote,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFF58C6C),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Color(0xFFDB745A), width: 2),
                            ),
                          ),
                          child: const Text(
                            'Update Note',
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