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
  bool _isLoading = false;

  List<Post> get posts => _posts;
  Post get post => _post;
  Map<String, bool> get isLikedByUser => _isLikedByUser;
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


  Future<void> loadForumData(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _posts = await _postService.fetchPosts();
      Set<String> creatorIds = _posts
          .expand((post) =>
              [post.creator, ...post.replies.map((reply) => reply.creator)])
          .toSet();

      Map<String, Profile> userMap =
          await _userService.fetchUsersByIds(creatorIds);

      for (var post in _posts) {
        _isLikedByUser[post.postID!] = post.likedByUserIds.contains(userId);

        var creatorProfile = userMap[post.creator];
        post.creator = creatorProfile?.name ?? "Unknown";
        post.creatorProfileImg = creatorProfile?.profileImagePath ??
            "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";

        for (var reply in post.replies) {
          var replyCreatorProfile = userMap[reply.creator];
          reply.creator = replyCreatorProfile?.name ?? "Unknown";
          print("replyCreatorProfile ${replyCreatorProfile?.name}");
          reply.creatorProfileImg = replyCreatorProfile?.profileImagePath ??
              "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";
        }
      }
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
    } catch (e) {
      print('Error deleting post: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> likePost(String postID, String userId) async {
    _isLikedByUser[postID] = true;

    notifyListeners();
    try {
      await _postService.likePost(postID, userId);
      int index = posts.indexWhere((post) => post.postID == postID);
      posts[index].likedByUserIds.add(userId);
    } catch (e) {
      print('Error liking post: $e');
    }
    notifyListeners();
  }

  Future<void> unlikePost(String postID, String userId) async {
    _isLikedByUser[postID] = false;
    notifyListeners();
    try {
      await _postService.unlikePost(postID, userId);
            int index = posts.indexWhere((post) => post.postID == postID);
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
