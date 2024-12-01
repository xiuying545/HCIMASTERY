import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Map<String, bool> isLikedByUser = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    loadPosts();
  }

  void loadPosts() async {
    final forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    await forumViewModel.fetchPosts();

    for (var post in forumViewModel.posts) {
      if (post.postID != null) {
        isLikedByUser[post.postID!] =
            await forumViewModel.checkIfPostLiked(post.postID!, "1");
      }
    }
  }

  Future<void> confirmDelete(String postID) async {
    final forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this post?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await forumViewModel.deletePost(postID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final forumViewModel = Provider.of<ForumViewModel>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Empty title to remove default behavior
        backgroundColor: const Color(0xFFefeefb),
        elevation: 0,
        flexibleSpace: Center(
          child: Text(
            'Forum',
            style: GoogleFonts.rubik(
                fontSize: 24, fontWeight: FontWeight.bold), // Larger font size
          ),
        ),

        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              child: Text(
                'Posts',
                style: GoogleFonts.rubik(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Tab(
              child: Text(
                'My Posts',
                style: GoogleFonts.rubik(
                    fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
          ],
          indicatorColor: const Color(0xFF3f5fd7),
          labelColor: const Color(0xFF3f5fd7),
          unselectedLabelColor: Colors.black,
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
    // Filter the posts to show only the user's posts (assuming "1" is the user ID)
    var myPosts =
        forumViewModel.posts.where((post) => post.creator == "1").toList();

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
          GoRouter.of(context).push("/student/forum/postDetail/${post.postID}");
        }
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Card(
          elevation: 5, // Added elevation for shadow
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                  child: Text(
                    post.title,
                    style: const TextStyle(
                      fontSize: 21, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3f5fd7),
                    ),
                  ),
                ),
                const Divider(
                  height: 20,
                  thickness: 0.5,
                  color: Color(0xFF3f5fd7),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundImage: const NetworkImage(
                          "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg",
                        ),
                        backgroundColor: Colors.grey.shade300,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Wong Xiu Ying",
                          style: TextStyle(
                            fontSize: 16, // Increased font size
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          !post.editStatus
                              ? "posted on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}"
                              : "edited on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromARGB(255, 98, 98, 98),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8.0),
                  child: Text(
                    post.content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFECEFF1),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite),
                            color: isLiked
                                ? Colors.pinkAccent
                                : const Color(0xFF757575),
                            onPressed: () async {
                              final postID = post.postID;
                              if (postID != null) {
                                if (isLiked) {
                                  await forumViewModel.unlikePost(postID, "1");
                                  setState(() {
                                    isLikedByUser[postID] = false;
                                  });
                                } else {
                                  await forumViewModel.likePost(postID, "1");
                                  setState(() {
                                    isLikedByUser[postID] = true;
                                  });
                                }
                              }
                            },
                          ),
                          Text(
                            '${post.likedByUserIds.length} likes',
                            style: const TextStyle(
                              color: Color(0xFF757575),
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '${forumViewModel.posts.where((p) => p.postID == post.postID).first.replies.length} replies',
                        style: const TextStyle(
                          color: Color(0xFF757575),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      post.creator == "1"
                          ? Row(
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
                                    GoRouter.of(context).push(
                                        "/student/forum/editPost/${post.postID}");
                                  },
                                ),
                              ],
                            )
                          : Container(
                              child: const SizedBox(
                              width: 100,
                            )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
