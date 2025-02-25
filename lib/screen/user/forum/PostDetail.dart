import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/modelview/userviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class PostDetailPage extends StatefulWidget {
  final String postID;

  const PostDetailPage({super.key, required this.postID});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post post = Post(
    content: "",
    title: "",
    creator: "",
    timeCreated: DateTime.now(),
    editStatus: false,
    replies: [],
  );
  final TextEditingController _replyController = TextEditingController();
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    _fetchPostDetails();
  }

  Future<void> _fetchPostDetails() async {
    try {
      final forumViewModel =
          Provider.of<ForumViewModel>(context, listen: false);
      final fetchedPost = await forumViewModel.fetchPostById(widget.postID);
      setState(() {
        post = fetchedPost;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch post details: $error')),
      );
    }
  }

  void confirmDeleteReply(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Reply"),
          content: const Text("Are you sure you want to delete this reply?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  post.replies.removeAt(index);
                });
                Provider.of<ForumViewModel>(context, listen: false)
                    .deleteReply(post.postID!, index);
                Navigator.of(context).pop();
              },
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ForumViewModel forumViewModel = Provider.of<ForumViewModel>(context);

    if (post.title.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Post Details'),
          backgroundColor: const Color(0xFFefeefb),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white,),
            onPressed: () => GoRouter.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title:  Text('Post Details',    style: GoogleFonts.poppins(
          color:Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),),
        backgroundColor: const Color(0xFFefeefb),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.blue.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back,color: Colors.white,),
          onPressed: () => GoRouter.of(context).pop(),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFefeefb), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPostHeader(post),
              const SizedBox(height: 16),
              _buildRepliesHeader(post),
              const SizedBox(height: 8),
              _buildRepliesList(post, forumViewModel),
              const SizedBox(height: 16),
              _buildReplyInputField(forumViewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostHeader(Post post) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style:  TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg",
                  ),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Wong Xiu Ying",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      !post.editStatus
                          ? "posted on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}"
                          : "edited on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              post.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 12),
              if (post.images != null && post.images!.isNotEmpty)
                SizedBox(
                  height: 80, // Adjust height as needed
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post.images!.length,

                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            post.images![index], // Firebase Storage URL
                          
                            height: 80,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.error, color: Colors.red);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepliesHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'Replies (${post.replies.length})',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildRepliesList(Post post, ForumViewModel forumViewModel) {
    return Expanded(
      child: ListView.builder(
        itemCount: post.replies.length,
        itemBuilder: (context, index) {
          var reply = post.replies[index];
          return FutureBuilder<String>(
            future: userViewModel.getUsername(reply.creator),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                String username = snapshot.data ?? 'Unknown User';
                return _buildReplyCard(reply, username, index);
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildReplyCard(Reply reply, String username, int index) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(
                "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg",
              ),
              backgroundColor: Colors.grey,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    "posted on ${DateFormat('yyyy-MM-dd').format(reply.timeCreated)}",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    reply.content,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            if (userViewModel.role == "admin")
              IconButton(
                icon: const Icon(Icons.delete),
                color: const Color(0xFF757575),
                onPressed: () => confirmDeleteReply(index),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildReplyInputField(ForumViewModel forumViewModel) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Type your reply...',
                hintStyle: TextStyle(color: Colors.grey),
                contentPadding: EdgeInsets.symmetric(vertical: 2.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF3f5fd7)),
            onPressed: () {
              if (_replyController.text.isNotEmpty) {
                Reply reply = Reply(
                  content: _replyController.text,
                  creator: userViewModel.userId!,
                  timeCreated: DateTime.now(),
                );

                setState(() {
                  post.replies.add(reply);
                });

                forumViewModel.addReplyToPost(post.postID!, reply);
                _replyController.clear();
              }
            },
          ),
        ],
      ),
    );
  }
}