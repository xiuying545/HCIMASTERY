import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/app_bar_with_back.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/common/common_widget/options_bottom_sheet.dart';
import 'package:fyp1/common/constant.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
  bool isLoading = true;
  late ValueNotifier<List<Reply>> repliesNotifier;
  bool isSendingReply = false;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPostDetails();
    });
  }

  Future<void> fetchPostDetails() async {
  
    try {
      await forumViewModel.fetchPostById(widget.postID);
      setState(() {
        post = forumViewModel.post;
      });
        repliesNotifier = ValueNotifier([...forumViewModel.post.replies]);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch post details: $error')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  Future<void> confirmDeleteReply(int index) async {
    await showDialog(
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
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF5E9),
      appBar: const AppBarWithBackBtn(title: 'Post Detail'),
      body: isLoading
          ? const LoadingShimmer()
          : SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPostHeader(post),
                              const SizedBox(height: 16),
                            ValueListenableBuilder<List<Reply>>(
  valueListenable: repliesNotifier,
  builder: (context, replies, _) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(
        'Replies (${replies.length})',
        style: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  },
),
                              const SizedBox(height: 8),
                              // Scrollable Replies List
                              SizedBox(
                                height: constraints.maxHeight * 0.45,
                                child: Expanded(
                                  child: 
                                  
                                  ValueListenableBuilder<List<Reply>>(
  valueListenable: repliesNotifier,
  builder: (context, replies, _) {
    return
                                  ListView.builder(
                                    itemCount: post.replies.length,
                                    itemBuilder: (context, index) {
                                      var reply = replies[index];
                                      bool isMyReply =
                                          post.replies[index].creator ==
                                              userViewModel.userId;
                                      return InkWell(
                                          onLongPress: () =>
                                              _showReplyOptionsBottomSheet(
                                                  post, index),
                                          child: Card(
                                            elevation: 2,
                                            margin: const EdgeInsets.only(
                                                bottom: 8.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            color: Colors.white,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Row(
                                                children: [
                                                  CircleAvatar(
                                                    radius: 20,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      forumViewModel
                                                              .userMap[
                                                                  reply.creator]
                                                              ?.profileImage ??
                                                          "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
                                                    ),
                                                    backgroundColor:
                                                        Colors.grey[300],
                                                  ),
                                                  const SizedBox(width: 12),
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          isMyReply
                                                              ? "${forumViewModel.userMap[reply.creator]?.name ?? "unknown"} (You)"
                                                              : forumViewModel
                                                                      .userMap[reply
                                                                          .creator]
                                                                      ?.name ??
                                                                  "unknown",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        Text(
                                                          "posted on ${DateFormat('yyyy-MM-dd').format(reply.timeCreated)}",
                                                          style: GoogleFonts
                                                              .fredoka(
                                                            fontSize: 12,
                                                            color: Colors.grey,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            height: 8),
                                                        Text(
                                                          reply.content,
                                                          style: GoogleFonts
                                                              .fredoka(
                                                                  fontSize: 14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  if (userViewModel.role ==
                                                      "admin")
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.delete),
                                                      color: const Color(
                                                          0xFF757575),
                                                      onPressed: () =>
                                                          confirmDeleteReply(
                                                              index),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ));
                                    },
                                  );
  }
                                ),
                              ),
                              )
                            ],
                          ),
                        ),
                      ),
                      // Reply Input Field (bottom pinned)
                      Padding(
                        padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                spreadRadius: 1,
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _replyController,
                                  style: GoogleFonts.poppins(fontSize: 15),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Type your reply...',
                                    hintStyle: GoogleFonts.poppins(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_replyController.text.isNotEmpty) {
                                    // if (isSendingReply) {
                                    //   return;
                                    // }
                                    // setState(() => isSendingReply = true);
                                    Reply reply = Reply(
                                      content: _replyController.text,
                                      creator: userViewModel.userId!,
                                      timeCreated: DateTime.now(),
                                    );

                                    setState(() {
                                      // post.replies.add(reply);
                                    });
                                    repliesNotifier.value = [...repliesNotifier.value, reply];

                                    forumViewModel.addReplyToPost(
                                        post.postID!, reply);
                                    _replyController.clear();
                                    // setState(() => isSendingReply = false);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text('Reply cannot be empty',
                                            style: AppTheme.snackBarText),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3f5fd7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.send,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }

  Widget _buildPostHeader(Post post) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFFFFFFFF),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  style: GoogleFonts.fredoka(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                        forumViewModel.userMap[post.creator]?.profileImage ??
                            "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
                      ),
                      backgroundColor: Colors.grey[300],
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          forumViewModel.userMap[post.creator]?.name ??
                              "unknown",
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          DateFormat('dd MMM yyyy, hh:mm a')
                              .format(post.timeCreated),
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  post.content,
                  style: GoogleFonts.fredoka(
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 10),
                if (post.images != null && post.images!.isNotEmpty)
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: post.images!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              post.images![index],
                              height: 80,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                        : null,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error,
                                    color: Colors.red);
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
        ),
      ),
    );
  }

  void _showReplyOptionsBottomSheet(Post post, int index) {
    bool isMyReply = post.replies[index].creator == userViewModel.userId;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomOptionsBottomSheet(
        options: [
          OptionItem(
            icon: Icons.share,
            label: 'Share Reply',
            color: Colors.blue.shade600,
            onTap: () async {
              try {
                final box = context.findRenderObject() as RenderBox?;
                String shareText = '${post.title}\n\n${post.replies[index]}';

                shareText += '\n\nCheck out this post in our app: HCI Mastery';

                await Share.share(
                  shareText,
                  subject: 'Check out this post: ${post.title}',
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to share: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          ),
          if (isMyReply || userViewModel.role == ROLE_ADMIN)
            OptionItem(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Reply',
              color: Colors.red.shade600,
              onTap: () {
                confirmDelete(post, index);
              },
            ),
        ],
      ),
    );
  }

  Future<void> confirmDelete(Post post, int index) async {
    showDialog(
        context: context,
        builder: (context) => CustomDialog(
              title: 'Delete Reply',
              content:
                  'Are you sure you want to delete this reply? This action cannot be undone.',
              action: 'Alert',
              onConfirm: () {
                Navigator.of(context).pop();
                repliesNotifier.value = List.from(repliesNotifier.value)..removeAt(index);
                forumViewModel.deleteReply(post.postID!, index);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Reply deleted successfully!',
                        style: AppTheme.snackBarText),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ));
  }
}
