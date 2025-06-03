import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
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
  final _formKey = GlobalKey<FormState>();

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
        Navigator.of(context).pop();
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
        _profileImage = user.profileImage;
        _usernameController.text = user.username ?? "";
      });
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
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
        profileImage: _profileImage,
        role: userViewModel.user!.role,
        username: _usernameController.text,
      );

      await userViewModel.saveUser(user);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Profile edited successfully!',
              style: AppTheme.snackBarText),
          backgroundColor: Colors.green,
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFDF6F1),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).viewPadding.top -
                      MediaQuery.of(context).viewPadding.bottom,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                                      errorBuilder: (_, __, ___) => Icon(
                                          Icons.person,
                                          size: 60,
                                          color: AppTheme.primaryColor),
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
                      const SizedBox(height: 30),
                      Text(
                        "⭐ Edit your personal details ⭐",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // all your widgets including:
                            _buildInputCard(
                              Icons.person,
                              "Name",
                              _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
                                  return 'Name can only contain alphabets';
                                }
                                return null;
                              },
                            ),
                            _buildInputCard(Icons.person_outline, "Username",
                                _usernameController),
                            _buildInputCard(
                              Icons.phone,
                              "Phone",
                              _phoneController,
                              validator: (value) {
                                if (value != null) {
                                  if (value.isNotEmpty &&
                                      !RegExp(r'^[0-9]+$').hasMatch(value)) {
                                    return 'Phone can only contain numbers';
                                  }
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          buildRoundedButton(
                              icon: Icons.lock_outline,
                              label: "Password",
                              onTap: () =>
                                  GoRouter.of(context).push("/editPassword"),
                              color: const Color(0xffEA7A84),
                              context: context),
                          const SizedBox(width: 16),
                          buildRoundedButton(
                              icon: Icons.save,
                              label: "Save",
                              onTap: _saveProfile,
                              color: const Color(0xffF79F3C),
                              context: context),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () =>
                              GoRouter.of(context).push("/deleteAccount"),
                          icon: const Icon(Icons.delete_forever_outlined,
                              color: Colors.white, size: 18),
                          label: Text(
                            "Delete Account",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 243, 102, 114),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 1,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.brown, size: 28),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard(
      IconData icon, String label, TextEditingController controller,
      {String? Function(String?)? validator}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0x00fffdfb),
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
              color: getBubbleColor(icon),
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
                TextFormField(
                  validator: validator,
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
