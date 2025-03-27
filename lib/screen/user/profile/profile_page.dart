import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/common_style/app_theme.dart';
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
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    if (userViewModel.userId != null) {
      await userViewModel.loadUser(userViewModel.userId!);
    } else {
      print("nulll valueee");
      String errorMessage = "User ID is null";

      // Log error in Firebase Crashlytics
      FirebaseCrashlytics.instance.recordError(
        Exception(errorMessage),
        StackTrace.current,
      );
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
    await userViewModel.logout();
    if (mounted) {
      GoRouter.of(context).go('/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue[30],
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppTheme.primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // When is fetching the profile data
                if (userViewModel.isLoading)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.primaryColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Loading your profile...",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      )
                    ],
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: size.width * 0.18,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userViewModel.user?.profileImagePath !=
                            null
                        ? NetworkImage(userViewModel.user!.profileImagePath!)
                        : const NetworkImage(
                            "https://cdn-icons-png.flaticon.com/512/9368/9368192.png"),
                  ),
                ),

                const SizedBox(height: 16),

                // Name with Star Decoration
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // const Icon(Icons.star, color: Colors.amber, size: 20),
                    // const SizedBox(width: 8),
                    Text( userViewModel.user != null ? userViewModel.user!.name : 'User', style: AppTheme.h2Style),

                    // const SizedBox(width: 8),
                    // const Icon(Icons.star, color: Colors.amber, size: 20),
                  ],
                ),

                const SizedBox(height: 8),

                // Email with Mail Icon
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mail_outline,
                        color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      userViewModel.user!.email,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
                _buildChildInfoCard(
                  icon: Icons.school,
                  title: "Username",
                  value: userViewModel.user!.username ?? "Not set yet",
                  color: Colors.blue,
                ),

                const SizedBox(height: 16),

                _buildChildInfoCard(
                  icon: Icons.phone,
                  title: "Phone Number",
                  value: userViewModel.user!.phone ?? "Not set yet",
                  color: Colors.green,
                ),

                const SizedBox(height: 16),

                _buildChildInfoCard(
                  icon: Icons.email_rounded,
                  title: "Email",
                  value: userViewModel.user!.email ??
                      "Not set yet", // Replace with actual data
                  color: Colors.purple,
                ),

                const SizedBox(height: 24),

                // Edit Button with Fun Shape
                ElevatedButton(
                  onPressed: () {
                    GoRouter.of(context)
                        .push("/editProfile/${userViewModel.userId!}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 4,
                    shadowColor: Colors.blue.withOpacity(0.3),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.edit, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Edit My Profile',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
