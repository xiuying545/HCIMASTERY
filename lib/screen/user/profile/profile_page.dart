import 'package:flutter/material.dart';
import 'package:fyp1/common_widget/custom_dialog.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    try {
      await userViewModel.loadUser(userViewModel.userId!);
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> _showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
      
        title: 'Logout',
        content: 'Are you sure you want to logout?',
        action: 'Alert',
        onConfirm: () {
          Navigator.of(context).pop();
          _logout();
        },
      ),
    );
  }

  Future<void> _logout() async {
    final userViewModel = Provider.of<UserViewModel>(context, listen: false);
    await userViewModel.logout(context);
    if (mounted) {
      GoRouter.of(context).go('/signIn'); // Navigate to the sign-in page
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue.shade900,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutConfirmation, 
          ),
        ],
      ),
      body: Center(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator()),
                  if (_hasError)
                    Center(
                      child: Text(
                        "Failed to load profile. Please try again.",
                        style: GoogleFonts.poppins(
                            fontSize: 18, color: Colors.red),
                      ),
                    ),
                  if (!_isLoading &&
                      !_hasError &&
                      userViewModel.user != null) ...[
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: userViewModel.user?.profileImagePath !=
                              null
                          ? NetworkImage(userViewModel.user!.profileImagePath!)
                          : const NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/9368/9368192.png"),
                      backgroundColor: Colors.white,
                    ),
                    const SizedBox(height: 40),

                    // Name
                    _buildInfoRow(
                        Icons.person, "Name", userViewModel.user!.name),
                    const SizedBox(height: 20),

                    // Phone
                    _buildInfoRow(Icons.phone, "Phone",
                        userViewModel.user!.phone ?? "N/A"),
                    const SizedBox(height: 20),

                    // Email
                    _buildInfoRow(
                        Icons.email, "Email", userViewModel.user!.email),
                    const SizedBox(height: 35),

                    // Edit Password Button
                    _buildButton(
                      text: "Edit Password",
                      onPressed: () {
                        GoRouter.of(context).push("/editPassword");
                      },
                      icon: Icons.lock,
                      color: Colors.blue.shade400,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push("/editProfile/${userViewModel.userId!}");
        },
        backgroundColor: Colors.blue.shade900,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade50, Colors.blue.shade50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue.shade900, size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required VoidCallback onPressed,
    required IconData icon,
    Color color = Colors.blue,
  }) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 20),
        label: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }
}
