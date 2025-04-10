import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fyp1/model/user.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('User');

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
          'userId': userID,
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

  Future<String?> getUserRole(String userID) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userID).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['role'] as String?;
      }
    } catch (e) {
      print("Error retrieving user role: $e");
    }
    return null;
  }

  Future<String> getUserName(String userID) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userID).get();
      if (doc.exists) {
        return (doc.data() as Map<String, dynamic>)['name'];
      }
    } catch (e) {
      print("Error retrieving user name: $e");
    }
    return "unknown name";
  }

  Future<Map<String, Profile>> fetchUsersByIds(Set<String> userIds) async {
    try {
      const int batchSize = 10;
      Map<String, Profile> userMap = {};

      for (int i = 0; i < userIds.length; i += batchSize) {
        List<String> batch = userIds.skip(i).take(batchSize).toList();

        QuerySnapshot querySnapshot = await _usersCollection
            .where(FieldPath.documentId, whereIn: batch)
            .get();

        for (var doc in querySnapshot.docs) {
          userMap[doc.id] =
              Profile.fromJson(doc.data() as Map<String, dynamic>);
        }
      }

      return userMap;
    } catch (e) {
      print("Error fetching users by IDs: $e");
      return {};
    }
  }
}
