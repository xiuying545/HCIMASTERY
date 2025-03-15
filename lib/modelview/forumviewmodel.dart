import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/post_service.dart';
import 'package:fyp1/services/user_service.dart';

class ForumViewModel extends ChangeNotifier {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<Post> fetchPostById(String postId) async {
    Post post = Post(
        title: "",
        creator: "",
        content: "",
        images: [],
        timeCreated: DateTime.now(),
        editStatus: false);
    try {
      post = await _postService.getPostById(postId);
      return post;
    } catch (e) {
      print('Error fetching posts by ID: $e');
    }
    return post;
  }

  Future<void> fetchPosts() async {
    _setLoading(true);
    try {
      _posts = await _postService.fetchPosts();
      Set<String> creatorIds = _posts
          .expand((post) =>
              [post.creator, ...post.replies.map((reply) => reply.creator)])
          .toSet();

      if (creatorIds.isEmpty) return;

      Map<String, Profile> userMap =
          await _userService.fetchUsersByIds(creatorIds);

      for (var post in _posts) {
        var creatorProfile = userMap[post.creator];
        post.creator = creatorProfile?.name ?? "Unknown";
        post.creatorProfileImg = creatorProfile?.profileImagePath ?? "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";

        for (var reply in post.replies) {
          var replyCreatorProfile = userMap[reply.creator];
          reply.creator = replyCreatorProfile?.name ?? "Unknown";
          reply.creatorProfileImg = replyCreatorProfile?.profileImagePath ?? "https://cdn-icons-png.flaticon.com/512/9368/9368192.png";
        }
      }
      notifyListeners();
    } catch (e) {
      print('Error fetching posts: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> checkIfPostLiked(String postID, String userId) async {
    return await _postService.isPostLikedByUser(postID, userId);
  }

  Future<void> addPost(Post post) async {
    _setLoading(true);
    try {
      await _postService.addPost(post);

      await fetchPosts();
    } catch (e) {
      print('Error adding post: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> editPost(Post post) async {
    _setLoading(true);
    try {
      await _postService.editPost(post);

      await fetchPosts();
    } catch (e) {
      print('Error editing post: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deletePost(String postID) async {
    _setLoading(true);
    try {
      await _postService.deletePost(postID);

      await fetchPosts();
    } catch (e) {
      print('Error deleting post: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> likePost(String postID, String userId) async {
    try {
      await _postService.likePost(postID, userId);

      await fetchPosts();
    } catch (e) {
      print('Error liking post: $e');
    }
  }

  Future<void> unlikePost(String postID, String userId) async {
    try {
      await _postService.unlikePost(postID, userId);

      await fetchPosts();
    } catch (e) {
      print('Error unliking post: $e');
    }
  }

  Future<void> addReplyToPost(String postID, Reply reply) async {
    try {
      await _postService.addReplyToPost(postID, reply);

      notifyListeners();
    } catch (e) {
      print('Error adding reply: $e');
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> deleteReply(String postID, int replyIndex) async {
    try {
      await _postService.deleteReply(postID, replyIndex);
      // await fetchPosts(); // Refresh the posts list after deletion
    } catch (e) {
      print('Error deleting reply: $e');
    }
  }
}
