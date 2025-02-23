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

class _ForumPageState extends State<ForumPage> {
  Map<String, bool> isLikedByUser = {};
  late UserViewModel userViewModel;
  bool showMyPosts = false; // Toggle between "Posts" and "My Posts"

  @override
  void initState() {
    super.initState();
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
      ),
      body: Column(
        children: [
          // Custom Tab Buttons
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 255, 255, 255), Color.fromARGB(255, 255, 255, 255)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showMyPosts = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showMyPosts ? Colors.grey[300] : Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Posts',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: showMyPosts ? Colors.black : Colors.white,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showMyPosts = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showMyPosts ? Colors.blue.shade900 : Colors.grey[300],
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'My Posts',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: showMyPosts ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Post List
          Expanded(
            child: showMyPosts
                ? _buildMyPostsList(forumViewModel)
                : _buildPostsList(forumViewModel),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          GoRouter.of(context).push("/student/forum/addPost");
        },
        shape: const CircleBorder(),
        backgroundColor: Colors.blue.shade900,
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                post.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade900,
                ),
              ),
              SizedBox(height:10),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM yyyy, hh:mm a').format(post.timeCreated),
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Post Title
             
              const SizedBox(height: 10),
              // Post Content
              Text(
                post.content,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 10),
              // Post Image (if any)
              // if (post.imageUrl != null)
              //   Image.network(
              //     post.imageUrl!,
              //     width: double.infinity,
              //     height: 200,
              //     fit: BoxFit.cover,
              //   ),
              const SizedBox(height: 10),
              // Like, Comment, Edit, and Delete Buttons
              Row(
                children: [
                  // Like Button
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
                      fontSize: 14,
                      color: const Color(0xFF757575),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Comment Button
                  const Icon(Icons.comment, color: Color(0xFF757575)),
                  const SizedBox(width: 5),
                  Text(
                    '${forumViewModel.posts.where((p) => p.postID == post.postID).first.replies.length} comments',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: const Color(0xFF757575),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const Spacer(), // Pushes the edit and delete buttons to the right
                  // Edit and Delete Buttons (only visible for the post creator or admin)
                  if (post.creator == userViewModel.userId!)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          color: const Color(0xFF757575),
                          onPressed: () {
                            GoRouter.of(context).push("/student/forum/editPost/${post.postID}");
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: const Color(0xFF757575),
                          onPressed: () {
                            confirmDelete(post.postID!);
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
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}