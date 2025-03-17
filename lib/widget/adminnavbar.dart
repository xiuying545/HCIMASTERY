import 'package:flutter/material.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:fyp1/screen/admin/manageChapter.dart';
import 'package:fyp1/screen/user/forum/forum.dart';
import 'package:fyp1/screen/user/note/mainpage.dart';
import 'package:fyp1/screen/user/practicalExercise/exercise.dart';
import 'package:fyp1/screen/user/profile/profile.dart';
import 'package:provider/provider.dart';

class AdminNavBar extends StatefulWidget {
  final int bottomIndex;
  const AdminNavBar({super.key, this.bottomIndex = 0});

  @override
  _AdminNavBar createState() => _AdminNavBar();
}

class _AdminNavBar extends State<AdminNavBar> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.bottomIndex;

    //todo

    Provider.of<UserViewModel>(context, listen: false)
        .setUserId("0ZSgmWUYGOOzncPO3oiitqaekTM2");
    Provider.of<UserViewModel>(context, listen: false).role = "admin";
  }

  @override
  Widget build(BuildContext context) {
    Widget getBodyWidget(int index) {
      switch (index) {
        case 0:
          // return const ManageNotePage(chapterId:"1tVIMjWSBHWuKDGQLWIA");
          return const ChapterDetailsPage();
        case 1:
          return const ForumPage();
        case 2:
          return const DesignChallengesPage();
        case 3:
          return const ProfilePage();

        default:
          return const MainPage();
      }
    }
 return Scaffold(
      body: getBodyWidget(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8), // Padding around the icon
                  child: const Icon(Icons.home_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.home),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.forum_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.forum),
                ),
                label: 'Forum',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.build_outlined),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.build),
                ),
                label: 'Exercise',
              ),
              BottomNavigationBarItem(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.person_outline),
                ),
                activeIcon: Container(
                  padding: const EdgeInsets.all(8),
                  child: const Icon(Icons.person),
                ),
                label: 'Me',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue.shade900, // Vibrant orange
            unselectedItemColor: Colors.grey.shade600, // Soft grey
            iconSize: 30,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            onTap: _onItemTapped,
            backgroundColor: Colors.white, // White background
            elevation: 10, // Add elevation for a floating effect
          ),
        ),
      ),
    );
  }
}
