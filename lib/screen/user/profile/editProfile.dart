import 'package:flutter/material.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
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

  late String? _profileImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserData();
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = image.path;
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
        _phoneController.text = user.phone??"";
        _emailController.text = user.email;
        _profileImage =
            user.profileImagePath; // Assuming User has a profileImage property
      });
    }
  }

  Future<void> _saveProfile() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    // Assuming User has a constructor or method to create an instance
    final user = Profile(
      userId: widget.userId,
      name: _nameController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      profileImagePath: _profileImage,
      role:"Student",
    );

    await userViewModel.saveUser(user);
    GoRouter.of(context).pop();// Navigate back after saving
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFefeefb),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).pop();
          },
        ),
        title: Text(
          "Edit Profile",
          style: GoogleFonts.rubik(fontSize: 24),
        ),
        backgroundColor: const Color(0xFF6a5ae0),
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: constraints.maxHeight * 0.08),

                  // Profile photo and upload button
                  Column(
                    children: [
                      const CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                                "https://i.postimg.cc/nz0YBQcH/Logo-light.png")
                            as ImageProvider,
                        backgroundColor: Colors.white,
                      ),
                      TextButton(
                        onPressed: _pickImage,
                        child: Text(
                          "Upload Photo",
                          style: GoogleFonts.rubik(
                            fontSize: 18,
                            color: const Color(0xFF6a5ae0),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: constraints.maxHeight * 0.05),

                  // Editable fields
                  _buildInputField("Name", _nameController, 18),
                  const SizedBox(height: 5.0),
                  _buildInputField("Phone", _phoneController, 18),
                  const SizedBox(height: 5.0),
                  _buildInputField("Email", _emailController, 18),
                  SizedBox(height: constraints.maxHeight * 0.05),

                  // Save button
                  ElevatedButton(
                    onPressed: _saveProfile,
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
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Input field widget
  Widget _buildInputField(
      String label, TextEditingController controller, double fontSize) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.rubik(fontSize: fontSize, color: Colors.black87),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.rubik(
              fontSize: fontSize - 4, color: Colors.grey[600]),
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
