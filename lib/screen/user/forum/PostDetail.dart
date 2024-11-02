import 'package:flutter/material.dart';
import 'package:fyp1/model/post.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:provider/provider.dart';

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
      replies: []); // Ensure replies are initialized
  final TextEditingController _replyController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchPostDetails();
  }

  Future<void> _fetchPostDetails() async {
    try {
      final ForumViewModel forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
      final fetchedPost = await forumViewModel.fetchPostById(widget.postID);
      setState(() {
        post = fetchedPost;
      });
    } catch (error) {
      print('Error fetching post details: $error');
    }
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
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.go("/student/forum"),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: const Color(0xFFefeefb),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go("/student/forum"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          post.title,
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF3f5fd7)),
                        ),
                      ),
                      const Divider(
                          height: 25, thickness: 0.5, color: Color(0xFF3f5fd7)),
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
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
                          style: const TextStyle(fontSize: 16, height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
              child: Text(
                'Replies (${post.replies.length})',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            // Replies List
            Expanded(
              child: ListView.builder(
                itemCount: post.replies.length,
                itemBuilder: (context, index) {
                  var reply = post.replies[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage: const NetworkImage(
                                "https://www.profilebakery.com/wp-content/uploads/2024/05/Profile-picture-created-with-ai.jpeg",
                              ),
                              backgroundColor: Colors.grey.shade300,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reply.creator,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    "posted on ${DateFormat('yyyy-MM-dd').format(reply.timeCreated)}",
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.grey),
                                  ),
                                  Text(
                                    reply.content,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _replyController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: 'Type your reply',
                          labelStyle: const TextStyle(color: Colors.grey),
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 2.0),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.send,
                                color: Color(0xFF3f5fd7)),
                            onPressed: () {
                              if (_replyController.text.isNotEmpty) {
                                Reply reply = Reply(
                                  content: _replyController.text,
                                  creator: "1", // Replace with actual user ID
                                  timeCreated: DateTime.now(),
                                );

                                // Add reply locally to the post before sending to server
                                setState(() {
                                  post.replies.add(reply);
                                });

                                forumViewModel.addReplyToPost(post.postID!, reply);
                                _replyController.clear();
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
