import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/services/post_service.dart';

class ForumViewModel extends ChangeNotifier {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;

  Future<Post> fetchPostById(String postId) async {
    Post post = Post(
        title: "",
        creator: "",
        content: "",
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
    //_postService.createPredefinedPosts();
    _setLoading(true);
    try {
      // await _postService.createPredefinedPosts();
      _posts = await _postService.fetchPosts();
      notifyListeners();
    } catch (e) {
      // Handle errors here (e.g., log the error)
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
}
