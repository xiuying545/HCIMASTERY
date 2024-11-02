import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fyp1/model/post.dart';

class PostService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createPredefinedPosts() async {
    final List<Post> predefinedPosts = [
      Post(
        
        title: 'Flutter Basics',
        content: 'Discussion about the basics of Flutter.',
        creator: "1",
        timeCreated: DateTime.now(),
      ),
      Post(
      
        title: 'State Management',
        content: 'Best practices for state management in Flutter.',
        creator: "1",
        timeCreated: DateTime.now(),
      ),
      Post(
    
        title: 'Networking in Flutter',
        content: 'How to make API calls in Flutter.',
        creator: "1",
        timeCreated: DateTime.now(),
      ),
      Post(
  
        title: 'Flutter vs React Native',
        content: 'Comparison of Flutter and React Native.',
        creator: "1",
        timeCreated: DateTime.now(),
      ),
      Post(
    
        title: 'Best Flutter Packages',
        content: 'A list of the best packages for Flutter development.',
        creator: "2",
        timeCreated: DateTime.now(),
      ),
    ];

    for (var post in predefinedPosts) {
      await _firestore.collection('Forum').add({
        'title': post.title,
        'content': post.content,
        'creator': post.creator,
        'image': null, // Assuming no image for predefined posts
        'likes': [], // Initialize likes as an empty map
        'replies': [], // Initialize replies as an empty list
        'timeCreated': post.timeCreated,
      });
    }
  }

  Future<List<Post>> fetchPosts() async {
    final snapshot = await _firestore.collection('Forum').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Post(
         postID: doc.id,
        title: data['title'],
        creator: data['creator'],
        content: data['content'],
        timeCreated: data['timeCreated'].toDate(),
        likedByUserIds: List<String>.from(data['likes'] ?? []),
      );
    }).toList();
  }

  // Method to add a new post
  Future<void> addPost(Post post, File? imageFile) async {
    String? imageUrl;

    // Check if an image file was provided
    if (imageFile != null) {
      // Create a reference for the image in Firebase Storage
      final storageRef = _storage.ref().child('post_images/${post.postID}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile); // Upload the file
      imageUrl = await storageRef.getDownloadURL(); // Get the URL of the uploaded image
    }

    // Save the post to Firestore
    await _firestore.collection('Forum').doc(post.postID.toString()).set({
      'title': post.title,
      'content': post.content,
      'creator': post.creator,
      'image': imageUrl, // Save the image URL if uploaded
      'likes': [], // Initialize likes as an empty map
      'replies': [], // Initialize replies as an empty list
      'timeCreated': post.timeCreated,
    });
  }

  // Method to edit an existing post
Future<void> editPost(String postID, {String? title, String? content, File? imageFile}) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());

    String? imageUrl;

    if (imageFile != null) {
      // Upload the image to Firebase Storage
      final storageRef = _storage.ref().child('post_images/${postID}_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(imageFile);
      imageUrl = await storageRef.getDownloadURL(); // Get the URL of the uploaded image
    }

    await postRef.update({
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (imageUrl != null) 'image': imageUrl, // Update the image URL if uploaded
    });
  }

  // Method to delete a post
  Future<void> deletePost(String postID) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());
    await postRef.delete();
  }

  // Method to like a post
  Future<void> likePost(String postID, String userId) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());
    await postRef.update({
      'likes': FieldValue.arrayUnion([userId]),
    });
  }

  // Method to unlike a post
  Future<void> unlikePost(String postID, String userId) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());
    await postRef.update({
      'likes': FieldValue.arrayRemove([userId]),
    });
  }

  // Method to add a reply to a post
  Future<void> addReplyToPost(String postID, Reply reply) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());
    await postRef.update({
      'replies': FieldValue.arrayUnion([
        {
          'userId': reply.userId,
          'content': reply.content,
          'timeCreated': reply.timeCreated,
        }
      ]),
    });
  }

Future<bool> isPostLikedByUser(String postID, String userId) async {
  final postRef = _firestore.collection('Forum').doc(postID.toString());
  final postSnapshot = await postRef.get();

  if (postSnapshot.exists) {
    final data = postSnapshot.data()!;

    // Check if 'likes' exists and is a list
    final likes = data['likes'];

    if (likes is List<dynamic>) {
      // If it's a list, check if userId is in it
      return likes.contains(userId);
    } else if (likes is Map<String, dynamic>) {
      // If it's a map, convert it to a list of keys (user IDs)
      return likes.keys.map(int.parse).contains(userId);
    } else {
      // If 'likes' is neither a list nor a map, handle it accordingly
      return false;
    }
  }

  return false; // If the post doesn't exist
}
}
