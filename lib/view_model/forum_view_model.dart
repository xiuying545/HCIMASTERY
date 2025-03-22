import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/post_service.dart';
import 'package:fyp1/services/user_service.dart';

class ForumViewModel extends ChangeNotifier {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<Post> _posts = [];
  late Post _post;
  final Map<String, bool> _isLikedByUser = {};
  Map<String, Profile> _userMap = {};
  bool _isLoading = false;

  List<Post> get posts => _posts;
  Post get post => _post;
  Map<String, bool> get isLikedByUser => _isLikedByUser;
  Map<String, Profile> get userMap => _userMap;
  bool get isLoading => _isLoading;

  Future<void> fetchPostById(String postId) async {
    _isLoading = true;
    notifyListeners();
    try {
      int index = posts.indexWhere((post) => post.postID == postId);
      _post = _posts[index];
    } catch (e) {
      print('Error fetching posts by ID: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadForumData(Profile newUser) async {
    _isLoading = true;
    notifyListeners();
    try {
      await fetchPost();

      _userMap[newUser.userId!] = newUser;

// pass in indexrectly
      for (var post in _posts) {
        _isLikedByUser[post.postID!] = post.likedByUserIds.contains(newUser.userId);
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchPost() async {
    _isLoading = true;
    notifyListeners();
    try {
      _posts = await _postService.fetchPosts();
      Set<String> creatorIds = _posts
          .expand((post) =>
              [post.creator, ...post.replies.map((reply) => reply.creator)])
          .toSet();
      _userMap = await _userService.fetchUsersByIds(creatorIds);
    } catch (e) {
      print('Error fetching posts: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addPost(Post post) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _postService.addPost(post);
      _posts.add(post);
    } catch (e) {
      print('Error adding post: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> editPost(Post post) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _postService.editPost(post);
      fetchPost();
    } catch (e) {
      print('Error editing post: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> deletePost(String postID) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _postService.deletePost(postID);
      int index = posts.indexWhere((post) => post.postID == postID);
      _posts.removeAt(index);
    } catch (e) {
      print('Error deleting post: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> likePost(int index, String userId) async {
    _isLikedByUser[_posts[index].postID!] = true;

    notifyListeners();
    try {
      await _postService.likePost(_posts[index].postID!, userId);

      posts[index].likedByUserIds.add(userId);
    } catch (e) {
      print('Error liking post: $e');
    }
    notifyListeners();
  }

  Future<void> unlikePost(int index, String userId) async {
    _isLikedByUser[_posts[index].postID!] = false;
    notifyListeners();
    try {
      await _postService.unlikePost(_posts[index].postID!, userId);
      posts[index].likedByUserIds.remove(userId);
    } catch (e) {
      print('Error unliking post: $e');
    }
    notifyListeners();
  }

  Future<void> addReplyToPost(String postID, Reply reply) async {
    try {
      await _postService.addReplyToPost(postID, reply);
      int index = posts.indexWhere((post) => post.postID == postID);
      posts[index].replies.add(reply);
    } catch (e) {
      print('Error adding reply: $e');
    }
    notifyListeners();
  }

  Future<void> deleteReply(String postID, int replyIndex) async {
    try {
      await _postService.deleteReply(postID, replyIndex);
      int index = posts.indexWhere((post) => post.postID == postID);
      posts[index].replies.removeAt(replyIndex);
    } catch (e) {
      print('Error deleting reply: $e');
    }
    notifyListeners();
  }
}
