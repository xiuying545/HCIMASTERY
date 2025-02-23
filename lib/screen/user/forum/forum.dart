import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, bool> isLikedByUser = {};
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    loadPosts();
  }

  Future<void> loadPosts() async {
    try {
      final forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
      await forumViewModel.fetchPosts();

      for (var post in forumViewModel.posts) {
        if (post.postID != null && userViewModel.userId != null) {
          isLikedByUser[post.postID!] = await forumViewModel.checkIfPostLiked(
              post.postID!, userViewModel.userId!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load posts: $e')),
      );
    }
  }

  Future<void> confirmDelete(String postID) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Confirm Deletion',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this post?',
          style: GoogleFonts.poppins(
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      try {
        final forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
        await forumViewModel.deletePost(postID);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete post: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final forumViewModel = Provider.of<ForumViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Empty title to remove default behavior
        backgroundColor: const Color(0xFFefeefb),
        elevation: 2, // Slight elevation for shadow
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Text(
              'Forum',
              style: GoogleFonts.poppins(
                fontSize: 26, // Adjusted font size
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for contrast
              ),
            ),
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Posts',
                style: GoogleFonts.poppins(
                  fontSize: 16, // Adjusted font size
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Tab(
              child: Text(
                'My Posts',
                style: GoogleFonts.poppins(
                  fontSize: 16, // Adjusted font size
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
          indicatorColor: Colors.white, // White indicator for contrast
          labelColor: Colors.white, // White text for selected tab
          unselectedLabelColor: Colors.white.withOpacity(0.7), // Slightly transparent for unselected
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPostsList(forumViewModel), // For "Posts"
          _buildMyPostsList(forumViewModel), // For "My Posts"
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push("/student/forum/addPost");
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3f5fd7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildPostsList(ForumViewModel forumViewModel) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFefeefb)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: forumViewModel.posts.length,
        itemBuilder: (context, index) {
          var post = forumViewModel.posts[index];
          return _buildPostCard(post, forumViewModel);
        },
      ),
    );
  }

  Widget _buildMyPostsList(ForumViewModel forumViewModel) {
    // Filter the posts to show only the user's posts
    var myPosts = forumViewModel.posts
        .where((post) => post.creator == userViewModel.userId)
        .toList();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white, Color(0xFFefeefb)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: myPosts.length,
        itemBuilder: (context, index) {
          var post = myPosts[index];
          return _buildPostCard(post, forumViewModel);
        },
      ),
    );
  }

  Widget _buildPostCard(Post post, ForumViewModel forumViewModel) {
    var isLiked = isLikedByUser[post.postID] ?? false;

    return GestureDetector(
      onTap: () {
        if (post.postID != null) {
          GoRouter.of(context).push("/forum/postDetail/${post.postID}");
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          elevation: 5, // Increased elevation for more depth
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // More rounded corners
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, const Color(0xFFefeefb).withOpacity(0.5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostHeader(post),
                _buildPostContent(post),
                _buildPostActions(post, forumViewModel, isLiked),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.title,
            style: GoogleFonts.poppins(
              fontSize: 20, // Adjusted font size
              fontWeight: FontWeight.bold,
              color: const Color(0xFF3f5fd7),
            ),
          ),
          const Divider(
            height: 20,
            thickness: 1,
            color: Color(0xFF3f5fd7),
          ),
          Row(
            children: [
              const CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                  "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg",
                ),
                backgroundColor: Colors.grey,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Wong Xiu Ying",
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Adjusted font size
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    !post.editStatus
                        ? "posted on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}"
                        : "edited on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}",
                    style: GoogleFonts.poppins(
                      fontSize: 14, // Adjusted font size
                      fontWeight: FontWeight.w400,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(Post post) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Text(
        post.content,
        style: GoogleFonts.poppins(
          fontSize: 16, // Adjusted font size
          color: Colors.grey[800],
        ),
        maxLines: 3, // Limit to 3 lines
        overflow: TextOverflow.ellipsis, // Add ellipsis for overflow
      ),
    );
  }

  Widget _buildPostActions(Post post, ForumViewModel forumViewModel, bool isLiked) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.pinkAccent : const Color(0xFF757575),
                ),
                onPressed: () async {
                  final postID = post.postID;
                  if (postID != null) {
                    if (isLiked) {
                      await forumViewModel.unlikePost(postID, userViewModel.userId!);
                      setState(() {
                        isLikedByUser[postID] = false;
                      });
                    } else {
                      await forumViewModel.likePost(postID, userViewModel.userId!);
                      setState(() {
                        isLikedByUser[postID] = true;
                      });
                    }
                  }
                },
              ),
              Text(
                '${post.likedByUserIds.length} likes',
                style: GoogleFonts.poppins(
                  fontSize: 14, // Adjusted font size
                  color: const Color(0xFF757575),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          Text(
            '${forumViewModel.posts.where((p) => p.postID == post.postID).first.replies.length} replies',
            style: GoogleFonts.poppins(
              fontSize: 14, // Adjusted font size
              color: const Color(0xFF757575),
              fontWeight: FontWeight.w400,
            ),
          ),
          if (post.creator == userViewModel.userId!)
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: const Color(0xFF757575),
                  onPressed: () {
                    confirmDelete(post.postID!);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: const Color(0xFF757575),
                  onPressed: () {
                    GoRouter.of(context).push("/student/forum/editPost/${post.postID}");
                  },
                ),
              ],
            )
          else if (userViewModel.role == "admin")
            IconButton(
              icon: const Icon(Icons.delete),
              color: const Color(0xFF757575),
              onPressed: () {
                confirmDelete(post.postID!);
              },
            )
          else
            const SizedBox(width: 100),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}