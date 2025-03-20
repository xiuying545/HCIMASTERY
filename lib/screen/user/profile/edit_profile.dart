import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  late String? _profileImage = "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";

  @override
  void initState() {
    super.initState();
     Future.microtask(() => _loadUserData());
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   _loadUserData();
    // });

    
  }
Future<void> _pickImage() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    // Upload to Firebase Storage
    String fileName = '${widget.userId}_profile_image';
    Reference storageRef = FirebaseStorage.instance.ref().child('profile_images/$fileName');
    UploadTask uploadTask = storageRef.putFile(File(image.path));

    // Get the download URL
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();

    setState(() {
      _profileImage = downloadUrl;
    });
  }
}
  Future<void> _loadUserData() async {
    print("widget:${widget.userId}");
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.loadUser(widget.userId);
    final user = userViewModel.user;

    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _phoneController.text = user.phone ?? "";
        _emailController.text = user.email;
        _profileImage = user.profileImagePath;
      });
    }
  }

  Future<void> _saveProfile() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    final user = Profile(
      userId: widget.userId,
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      profileImagePath: _profileImage,
      role: "Student",
    );

    await userViewModel.saveUser(user);
    GoRouter.of(context).pop(); // Navigate back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 2,
      ),
      body: Center(
        child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
            children: [
             

              // Profile photo and upload button
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.blue.shade900,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 60,
                      backgroundImage: 
                      _profileImage != null
                          ? NetworkImage(_profileImage!)
                          : 
                          const NetworkImage(
                              "https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.flaticon.com%2Ffree-icon%2Fuser-profile_9368192&psig=AOvVaw0ol0ZiyQOGQUYWOX-dVsRP&ust=1740583943830000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCKiphtCS34sDFQAAAAAdAAAAABAR",
                            ) as ImageProvider,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: _pickImage,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 50),

              // Editable fields
              _buildInputField(Icons.person, "Name", _nameController),
              const SizedBox(height: 30),
              _buildInputField(Icons.phone, "Phone", _phoneController),
              const SizedBox(height: 30),
              _buildInputField(Icons.email, "Email", _emailController),
              const SizedBox(height: 35),

              // Save button
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  elevation: 5,
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 40,
                  ),
                ),
                child: Text(
                  "Save Changes",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }

  // Input field widget with icons
  Widget _buildInputField(
      IconData icon, String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          prefixIcon: Icon(icon, color: Colors.blue.shade900),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
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