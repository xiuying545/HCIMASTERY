import 'package:flutter/material.dart';
import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/constant.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/Animation/error.png',
                height: 200,
              ),
              const SizedBox(height: 20),
              const Text(
                'Something went wrong.',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'ComicNeue', // Use a fun font
                ),
              ),
              const SizedBox(height: 15),
            
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[400],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  if (StorageHelper.get("STATUS") == STATUS_LOGIN) {
                    if (StorageHelper.get("ROLE") == ROLE_STUDENT){
                    GoRouter.of(context).go('/studentNav');
                    }
                    else if(StorageHelper.get("ROLE") == ROLE_ADMIN){
                      GoRouter.of(context).go('/adminNav');
                    }
                    
                  } else {
                    GoRouter.of(context).go('/signin');
                  }
                },
                child: const Text(
                  'Go Back Home',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontFamily: 'ComicNeue',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
