import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/common/common_widget/helpers.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:fyp1/view_model/note_view_model.dart';
import 'package:fyp1/view_model/quiz_view_model.dart';
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    StorageHelper.clearAll();
    if (userViewModel.userId != null) {
      await userViewModel.loadUser(userViewModel.userId!);
    } else {
      String errorMessage = "ID Pengguna adalah kosong";

      FirebaseCrashlytics.instance.recordError(
        Exception(errorMessage),
        StackTrace.current,
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _showLogoutConfirmation() async {
    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: 'Log Keluar',
        content: 'Adakah anda pasti ingin log keluar?',
        action: 'Amaran',
        onConfirm: () {
          _logout();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  Future<void> _logout() async {
    setState(() {
      isLoading = true;
    });
    await userViewModel.logout();
    Provider.of<NoteViewModel>(context, listen: false).clear();
    Provider.of<ForumViewModel>(context, listen: false).clear();
    Provider.of<QuizViewModel>(context, listen: false).clear();
    if (mounted) {
      GoRouter.of(context).go('/signIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF9F0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child:
              Consumer<UserViewModel>(builder: (context, userViewModel, child) {
            if (userViewModel.isLoading || isLoading) {
              return const LoadingShimmer();
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
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
                      radius: size.width * 0.15,
                      backgroundColor: Colors.grey[200],
                      backgroundImage: userViewModel.user?.profileImage != null
                          ? NetworkImage(userViewModel.user!.profileImage!)
                          : const NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/9368/9368192.png"),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        userViewModel.user != null
                            ? userViewModel.user!.name
                            : 'Pengguna',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          color: Colors.blue.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
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
                  _buildInfoCard(
                    icon: Icons.person_outline,
                    title: "Nama Pengguna",
                    value: userViewModel.user!.username == null ||
                            userViewModel.user!.username!.isEmpty
                        ? "Belum ditetapkan"
                        : userViewModel.user!.username!,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.phone,
                    title: "Nombor Telefon",
                    value: userViewModel.user!.phone == null ||
                            userViewModel.user!.phone!.isEmpty
                        ? "Belum ditetapkan"
                        : userViewModel.user!.phone!,
                  ),
                  const SizedBox(height: 16),
                  _buildInfoCard(
                    icon: Icons.email,
                    title: "Emel",
                    value: userViewModel.user!.email,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildRoundedButton(
                          icon: Icons.logout,
                          label: "Log Keluar",
                          onTap: () => _showLogoutConfirmation(),
                          color: const Color(0xffEA7A84),
                          context: context),
                      const SizedBox(width: 16),
                      buildRoundedButton(
                          icon: Icons.edit,
                          label: "Edit Profil",
                          onTap: () {
                            GoRouter.of(context)
                                .push("/editProfile/${userViewModel.userId!}");
                          },
                          color: const Color(0xffF79F3C),
                          context: context),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: getBubbleColor(icon),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: getBubbleColor(icon),
          width: 1,
        ),
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
                    fontSize: 17,
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
