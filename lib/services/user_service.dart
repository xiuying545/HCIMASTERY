import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection = FirebaseFirestore.instance.collection('User');

  // Adds or updates a user in Firestore
  Future<void> addOrUpdateUser(Profile user) async {
    try {
      await _usersCollection.doc(user.userId).set(user.toJson());
    } catch (e) {
      print("Error adding/updating user: $e");
    }
  }

  
Future<Profile?> getUserById(String userID) async {
  try {
    DocumentSnapshot doc = await _usersCollection.doc(userID).get();
    if (doc.exists) {
 
     
      
      // Create a User instance from Firestore data and add the userID
      return Profile.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'userID': userID,
      });
    }
  } catch (e) {
    print("Error retrieving user: $e");
  }
  return null;
}

  // Deletes a user by userID
  Future<void> deleteUser(String userID) async {
    try {
      await _usersCollection.doc(userID).delete();
    } catch (e) {
      print("Error deleting user: $e");
    }
  }

  // Retrieves all users (for displaying lists or managing multiple users)
  Future<List<Profile>> getAllUsers() async {
    try {
      QuerySnapshot querySnapshot = await _usersCollection.get();
      return querySnapshot.docs.map((doc) {
        return Profile.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      print("Error retrieving all users: $e");
      return [];
    }
  }
}
