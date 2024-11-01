import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/services/post_service.dart';

class ForumViewModel extends ChangeNotifier {
  final PostService _postService = PostService();
  List<Post> _posts = [];
  bool _isLoading = false;

  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;


  Future<void> fetchPosts() async {
   
    _setLoading(true);
    try {
      _posts = await _postService.fetchPosts();
    } catch (e) {
      // Handle errors here (e.g., log the error)
      print('Error fetching posts: $e');
    } finally {
      _setLoading(false);
    }
  }
  Future<bool> checkIfPostLiked(int postID, int userId) async {
    return await _postService.isPostLikedByUser(postID, userId);
  }


  Future<void> addPost(Post post, File? imageFile) async {
    _setLoading(true);
    try {
      await _postService.addPost(post, imageFile);

      await fetchPosts();
    } catch (e) {
      print('Error adding post: $e');
    } finally {
      _setLoading(false);
    }
  }


  Future<void> editPost(int postID, {String? title, String? content, File? imageFile}) async {
    _setLoading(true);
    try {
      await _postService.editPost(postID, title: title, content: content, imageFile: imageFile);

      await fetchPosts();
    } catch (e) {
      print('Error editing post: $e');
    } finally {
      _setLoading(false);
    }
  }


  Future<void> deletePost(int postID) async {
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


  Future<void> likePost(int postID, int userId) async {
    try {
      await _postService.likePost(postID, userId);

      await fetchPosts();
    } catch (e) {
      print('Error liking post: $e');
    }
  }


  Future<void> unlikePost(int postID, int userId) async {
    try {
      await _postService.unlikePost(postID, userId);

      await fetchPosts();
    } catch (e) {
      print('Error unliking post: $e');
    }
  }


  Future<void> addReplyToPost(int postID, Reply reply) async {
    try {
      await _postService.addReplyToPost(postID, reply);

      await fetchPosts();
    } catch (e) {
      print('Error adding reply: $e');
    }
  }


  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners(); 
  }
}
