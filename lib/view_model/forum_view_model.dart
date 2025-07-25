import 'package:fyp1/cache/storage_helper.dart';
import 'package:fyp1/common/constant.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/model/user.dart';
import 'package:fyp1/services/post_service.dart';
import 'package:fyp1/services/user_service.dart';
import 'package:fyp1/view_model/base_view_model.dart';

class ForumViewModel extends BaseViewModel {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  List<Post> _posts = [];
  late Post _post;
  final Map<String, bool> _isLikedByUser = {};
  Map<String, Profile> _userMap = {};
  String _userId = "";

  List<Post> get posts => _posts;
  Post get post => _post;
  Map<String, bool> get isLikedByUser => _isLikedByUser;
  Map<String, Profile> get userMap => _userMap;

  /// Fetch a post by ID from the local list (avoids unnecessary API calls)
  Future<void> fetchPostById(String postId, {bool forceRefresh = false}) async {
    await tryFunction(() async {
      if (forceRefresh == false) {
        int index = _posts.indexWhere((post) => post.postID == postId);
        _post = _posts[index];
      } else {
        _post = await _postService.getPostById(postId);
      }
    });
  }

  /// Loads forum data only if posts are empty, otherwise skips fetching
  Future<void> loadForumData(Profile newUser) async {
    if (_posts.isNotEmpty) return;
    await tryFunction(() async {
      _userId = StorageHelper.get(USER_ID)!;
      await fetchPost();
      _userMap[_userId] = newUser;
    });
  }

  /// Fetches posts and populates `_userMap` with creator information
  Future<void> fetchPost() async {
    await tryFunction(() async {
      _posts = await _postService.fetchPosts();
      Set<String> creatorIds = _posts
          .expand((post) =>
              [post.creator, ...post.replies.map((reply) => reply.creator)])
          .toSet();
      _userMap = await _userService.fetchUsersByIds(creatorIds);

      for (var post in _posts) {
        _isLikedByUser[post.postID!] = post.likedByUserIds.contains(_userId);
      }
      notifyListeners();
    });
  }

  /// Adds a new post and updates the local list
  Future<void> addPost(Post post) async {
    await tryFunction(() async {
      final postId = await _postService.addPost(post);
      post.postID = postId;
      _posts.add(post);
    });
  }

  /// Edits a post and refreshes the post list
  Future<void> editPost(Post post) async {
    await tryFunction(() async {
      await _postService.editPost(post);
      await fetchPost(); // Refresh posts after editing
    });
  }

  /// Deletes a post and removes it from the local list
  Future<void> deletePost(String postID) async {
    await tryFunction(() async {
      await _postService.deletePost(postID);
      _posts.removeWhere((post) => post.postID == postID);
    });
  }

  /// Likes a post, updates local state, and sends the request to the backend
  Future<void> likePost(int index, String userId) async {
    _isLikedByUser[_posts[index].postID!] = true;
    _posts[index].likedByUserIds.add(userId);
    notifyListeners();
    await _postService.likePost(_posts[index].postID!, userId);
  }

  /// Unlikes a post, updates local state, and sends the request to the backend
  Future<void> unlikePost(int index, String userId) async {
    _isLikedByUser[_posts[index].postID!] = false;
    _posts[index].likedByUserIds.remove(userId);
    notifyListeners();

    await _postService.unlikePost(_posts[index].postID!, userId);
  }

  /// Adds a reply to a post
  Future<void> addReplyToPost(String postID, Reply reply) async {
    await tryFunction(() async {
      await _postService.addReplyToPost(postID, reply);
      _posts.firstWhere((post) => post.postID == postID).replies.add(reply);
      notifyListeners();
    });
  }

  /// Deletes a reply from a post
  Future<void> deleteReply(String postID, int replyIndex) async {
    await tryFunction(() async {
      await _postService.deleteReply(postID, replyIndex);
      _posts
          .firstWhere((post) => post.postID == postID)
          .replies
          .removeAt(replyIndex);
      notifyListeners();
    });
  }

  void clear() {
    _posts.clear();
    _isLikedByUser.clear();
    _userMap.clear();
    _userId = "";
    notifyListeners();
  }
}
