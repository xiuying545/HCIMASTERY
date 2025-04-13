import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/custom_input_field.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/common/common_widget/helpers.dart';
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
  final TextEditingController _usernameController = TextEditingController();

  late String? _profileImage =
      "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";

  @override
  void initState() {
    super.initState();
    Future.microtask(() => _loadUserData());
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
            ),
          );
        },
      );

      try {
        String fileName = '${widget.userId}_profile_image';
        Reference storageRef =
            FirebaseStorage.instance.ref().child('profile_images/$fileName');
        UploadTask uploadTask = storageRef.putFile(File(image.path));
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          _profileImage = downloadUrl;
        });
      } finally {
        Navigator.of(context).pop(); // Dismiss loading indicator
      }
    }
  }

  Future<void> _loadUserData() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.loadUser(widget.userId);
    final user = userViewModel.user;

    if (user != null) {
      setState(() {
        _nameController.text = user.name;
        _phoneController.text = user.phone ?? "";
        _emailController.text = user.email;
        _profileImage = user.profileImagePath;
        _usernameController.text = user.username ?? "";
      });
    }
  }

  Future<void> _saveProfile() async {
    // Show saving indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
        );
      },
    );

    try {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      final user = Profile(
        userId: widget.userId,
        name: _nameController.text,
        phone: _phoneController.text,
        email: _emailController.text,
        profileImagePath: _profileImage,
        role: userViewModel.user!.role,
        username: _usernameController.text,
      );

      await userViewModel.saveUser(user);
      GoRouter.of(context).pop(); // Navigate back after saving
    } finally {
      Navigator.of(context).pop(); // Dismiss saving indicator
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6F1),
      appBar: const AppBarWithBackBtn(title: 'Edit Profile'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.15,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: _profileImage != null
                          ? Image.network(
                              _profileImage!,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return CircularProgressIndicator(
                                  color: AppTheme.primaryColor,
                                );
                              },
                              errorBuilder: (_, __, ___) => Icon(Icons.person,
                                  size: 60, color: AppTheme.primaryColor),
                            )
                          : Icon(Icons.person,
                              size: 60, color: AppTheme.primaryColor),
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.blue,
                      radius: 20,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt,
                            size: 18, color: Colors.white),
                        onPressed: _pickImage,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "⭐ Edit your personal details ⭐",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              const SizedBox(height: 16),
              _buildInputCard(Icons.person, "Name", _nameController),
              _buildInputCard(
                  Icons.person_outline, "Username", _usernameController),
              _buildInputCard(Icons.phone, "Phone", _phoneController),
              _buildInputCard(Icons.email, "Email", _emailController),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  buildRoundedButton(
                    icon: Icons.lock_outline,
                    label: "Password",
                    onTap: () => GoRouter.of(context).push("/editPassword"),
                    color: Color(0xffEA7A84),
                       context: context
                  ),
                  const SizedBox(width: 16),
                  buildRoundedButton(
                    icon: Icons.save,
                    label: "Save",
                    onTap: _saveProfile,
                    color: Color(0xffF79F3C),
                       context: context
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
      IconData icon, String label, TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFFDFB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: getBubbleColor(icon), // pick pastel bg based on icon type
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              color: getIconColor(icon),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    )),
                TextField(
                  controller: controller,
                  style: GoogleFonts.poppins(fontSize: 17),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
