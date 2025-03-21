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
        editStatus: false,
        timeCreated: DateTime.now(),
      ),
      Post(
        title: 'State Management',
        content: 'Best practices for state management in Flutter.',
        creator: "1",
        editStatus: false,
        timeCreated: DateTime.now(),
      ),
      Post(
        title: 'Networking in Flutter',
        content: 'How to make API calls in Flutter.',
        creator: "1",
        editStatus: false,
        timeCreated: DateTime.now(),
      ),
      Post(
        title: 'Flutter vs React Native',
        content: 'Comparison of Flutter and React Native.',
        creator: "1",
        editStatus: false,
        timeCreated: DateTime.now(),
      ),
      Post(
        title: 'Best Flutter Packages',
        content: 'A list of the best packages for Flutter development.',
        creator: "2",
        editStatus: true,
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

  Future<Post> getPostById(String postId) async {
    DocumentSnapshot doc =
        await _firestore.collection('Forum').doc(postId).get();

    if (doc.exists) {
      // Retrieve data and add the document ID as 'postID'
      final data = doc.data() as Map<String, dynamic>;
      data['postID'] = doc.id; // Set the document ID as 'postID'

      return Post.fromMap(data);
    } else {
      throw Exception('Post not found');
    }
  }

  Future<List<Post>> fetchPosts() async {
    final snapshot = await _firestore.collection('Forum').get();

    return snapshot.docs
        .map((doc) {
          final data = doc.data();

          if (data['title'] != null &&
              data['content'] != null &&
              data['creator'] != null) {
            return Post(
                postID: doc.id,
                title: data['title'],
                creator: data['creator'],
                images: (data['images'] as List<dynamic>?)
                    ?.map((e) => e.toString())
                    .toList(),
                content: data['content'],
                editStatus: data['editStatus'] ?? false,
                timeCreated: data['timeCreated'].toDate(),
                likedByUserIds: List<String>.from(data['likes'] ?? []),
                replies: List<Reply>.from((data['replies'] ?? [])
                    .map((replyData) => Reply.fromMap(replyData))));
          } else {
            return null;
          }
        })
        .where((post) => post != null)
        .cast<Post>()
        .toList();
  }

  // Method to add a new post
  Future<void> addPost(Post post) async {
    // Save the post to Firestore and get the document reference
    DocumentReference docRef = await _firestore.collection('Forum').add({
      'title': post.title,
      'content': post.content,
      'creator': post.creator,
      'images': post.images,
      'likes': [],
      'replies': [],
      'editStatus': false,
      'timeCreated': post.timeCreated,
    });
  }

  // Method to edit an existing post
  Future<void> editPost(Post post) async {
    final postRef = _firestore.collection('Forum').doc(post.postID.toString());

    try {
      await postRef.update({
        'title': post.title,
        'content': post.content,
        'creator': post.creator,
        'timeCreated': post.timeCreated,
        'images': post.images,
        'editStatus': post.editStatus,
      });
    } catch (e) {
      print('Error updating post: $e');
      throw Exception(
          'Failed to update post'); // Rethrow or handle the error as needed
    }
  }

  // Method to delete a post
  Future<void> deletePost(String postID) async {
    final postRef = _firestore.collection('Forum').doc(postID.toString());
    await postRef.delete();
  }

  // Method to like a post
  Future<void> likePost(String postID, String userId) async {
    final postRef = _firestore.collection('Forum').doc(postID);
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
          'creator': reply.creator,
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

  Future<void> deleteReply(String postID, int replyIndex) async {
    final postRef = _firestore.collection('Forum').doc(postID);
    final postSnapshot = await postRef.get();

    if (postSnapshot.exists) {
      final data = postSnapshot.data() as Map<String, dynamic>;
      final replies = List<Map<String, dynamic>>.from(data['replies'] ?? []);

      if (replyIndex >= 0 && replyIndex < replies.length) {
        replies.removeAt(replyIndex);

        await postRef.update({'replies': replies});
      } else {
        throw Exception('Reply index out of range');
      }
    } else {
      throw Exception('Post not found');
    }
  }
}
