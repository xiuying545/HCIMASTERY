import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:provider/provider.dart';

class PostDetailPage extends StatefulWidget {
  final String postID;

  const PostDetailPage({super.key, required this.postID});

  @override
  _PostDetailPageState createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  late ForumViewModel forumViewModel;
  late Post post;
  final TextEditingController _replyController = TextEditingController();
  late UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();

    fetchPostDetails();
  }

  Future<void> fetchPostDetails() async {
    try {
      userViewModel = Provider.of<UserViewModel>(context, listen: false);
      forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
      await forumViewModel.fetchPostById(widget.postID);
      setState(() {
        post = forumViewModel.post;
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
        builder: (context) => CustomDialog(
      
              title: 'Delete Reply',
              content: 'Are you sure you want to delete this reply?',
              action: 'Alert',
              onConfirm: () async {
                setState(() {
                  post.replies.removeAt(index);
                });

                forumViewModel.deleteReply(post.postID!, index);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reply deleted successfully!',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWithBackBtn(
        title: 'Post Detail',
      ),
      body: forumViewModel.isLoading
          ? const LoadingShimmer()
          : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPostHeader(post),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    'Replies (${post.replies.length})',
                      style: AppTheme.h4Style,
                  ),
                ),
                const SizedBox(height: 8),
                _buildRepliesList(post, forumViewModel),
                const SizedBox(height: 16),
                _buildReplyInputField(forumViewModel),
              ],
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
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                 CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                        forumViewModel.userMap[post.creator]?.profileImagePath ??  "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
                      ),
                  backgroundColor: Colors.grey,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                     forumViewModel.userMap[post.creator]?.name ?? "unknown" ,
                      style: const TextStyle(
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
                                value: loadingProgress.expectedTotalBytes !=
                                        null
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

  Widget _buildRepliesList(Post post, ForumViewModel forumViewModel) {
    return Expanded(
        child: ListView.builder(
            itemCount: post.replies.length,
            itemBuilder: (context, index) {
              var reply = post.replies[index];

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
                       CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage(
                           forumViewModel.userMap[reply.creator]?.profileImagePath ??  "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                             forumViewModel.userMap[reply.creator]?.name ??  "unknown",
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
            }));
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
