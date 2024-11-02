import 'dart:io'; // For handling File
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart'; // Import the image picker package

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController =
      TextEditingController(text: "John Doe");
  final TextEditingController _phoneController =
      TextEditingController(text: "+1 234 567 890");
  final TextEditingController _emailController =
      TextEditingController(text: "john.doe@example.com");

  File? _profileImage; // Variable to store the profile image
  final ImagePicker _picker = ImagePicker(); // Instance of ImagePicker

  // Function to pick image from gallery
  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFefeefb),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/student/profile");
          },
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.rubik(fontSize: 24),
        ),
        backgroundColor: const Color(0xFF6a5ae0),
        foregroundColor: Colors.white,
      ),
      body: Center(
        // Center the entire content vertically and horizontally
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          child: Column(
            mainAxisAlignment:
                MainAxisAlignment.center, // Center content vertically
            children: [
              // Profile photo and upload button
              Column(
                children: [
                  CircleAvatar(
                    radius: 70, // Slightly larger radius for profile photo
                    backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!) // Display picked image
                        : const NetworkImage(
                                "https://i.postimg.cc/nz0YBQcH/Logo-light.png")
                            as ImageProvider,
                    backgroundColor: Colors.white,
                  ),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text(
                      "Upload Photo",
                      style: GoogleFonts.rubik(
                        fontSize: 20, // Increased font size for upload button
                        color: const Color(0xFF6a5ae0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40.0),

              // Editable fields
              _buildInputField("Name", _nameController, 20),
              const SizedBox(height: 20.0),
              _buildInputField("Phone", _phoneController, 20),
              const SizedBox(height: 20.0),
              _buildInputField("Email", _emailController, 20),
              const SizedBox(height: 40.0),

              // Save button
              ElevatedButton(
                onPressed: () {
                  // Save the edited details logic here
                },
                style: ElevatedButton.styleFrom(
                  elevation: 2,
                  backgroundColor: const Color(0xFF6a5ae0),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 12.0, horizontal: 24.0),
                  child: Text(
                    "Save Changes",
                    style: GoogleFonts.rubik(
                      fontSize: 22, // Increased font size for save button
                      fontWeight: FontWeight.w600,
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

  // Helper method to create input fields
  Widget _buildInputField(
      String label, TextEditingController controller, double fontSize) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.rubik(fontSize: fontSize, color: Colors.black87),
      decoration: InputDecoration(
        labelText: label,
        labelStyle:
            GoogleFonts.rubik(fontSize: fontSize - 4, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
