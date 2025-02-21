import 'package:flutter/material.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);

      userViewModel.loadUser(userViewModel.userId!); 
    });
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFefeefb),
      appBar: AppBar(
        title: Text(
          "Profile",
          style: GoogleFonts.rubik(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6a5ae0),
        elevation: 2,
      ),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: constraints.maxHeight * 0.08),

                CircleAvatar(
                  radius: 60,
                  backgroundImage: userViewModel.user?.profileImagePath != null
                      ? NetworkImage(userViewModel.user!.profileImagePath!)
                      : const NetworkImage(
                          "https://i.postimg.cc/nz0YBQcH/Logo-light.png"),
                  backgroundColor: Colors.white,
                ),
                SizedBox(height: constraints.maxHeight * 0.08),

                const SizedBox(height: 25),

                if (userViewModel.user != null) ...[
                  _buildInfoCard("Name", userViewModel.user!.name),
                  const SizedBox(height: 16.0),
                  _buildInfoCard("Phone", userViewModel.user!.phone??""),
                  const SizedBox(height: 16.0),
                  _buildInfoCard("Email", userViewModel.user!.email),
                  const SizedBox(height: 16.0),
                ] else ...[
                  const Text("User not found", style: TextStyle(fontSize: 18)),
                ],

                // Edit Profile button with improved styling
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                       print("widgget:${userViewModel.user!.userId}");
                       GoRouter.of(context).push("/editProfile/${userViewModel.userId??"1"}");
                      
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
                        "Edit Profile",
                        style: GoogleFonts.rubik(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  // Widget for each profile information card
  Widget _buildInfoCard(String title, String value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$title:",
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.rubik(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
