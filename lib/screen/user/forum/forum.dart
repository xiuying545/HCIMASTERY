import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/custom_dialog.dart';
import 'package:fyp1/common/common_widget/loading_shimmer.dart';
import 'package:fyp1/common/common_widget/options_bottom_sheet.dart';
import 'package:fyp1/common/constant.dart';
import 'package:fyp1/model/post.dart';
import 'package:fyp1/view_model/forum_view_model.dart';
import 'package:fyp1/view_model/user_view_model.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late UserViewModel userViewModel;
  late ForumViewModel forumViewModel;
  bool showMyPosts = false;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    Future.microtask(() => loadPosts());
  }

  Future<void> loadPosts() async {
    await forumViewModel.loadForumData(userViewModel.user!);
  }

  Future<void> confirmDelete(String postID) async {
    showDialog(
        context: context,
        builder: (context) => CustomDialog(
              title: 'Delete Post',
              content:
                  'Are you sure you want to delete this post? This action cannot be undone.',
              action: 'Alert',
              onConfirm: () {
                Navigator.of(context).pop();
                forumViewModel.deletePost(postID);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Post deleted successfully!',
                        style: AppTheme.snackBarText),
                    backgroundColor: Colors.green,
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forum',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ), // Empty title to remove default behavior
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
          // child: Center(
          //   child: Text(
          //     'Forum',
          //     style: Theme.of(context).appBarTheme.titleTextStyle,
          //   ),
          // ),
        ),
      ),
      body: Column(
        children: [
          // Custom Tab Buttons
          Container(
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
                    backgroundColor:
                        showMyPosts ? Colors.grey[300] : Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
                    backgroundColor:
                        showMyPosts ? Colors.blue.shade900 : Colors.grey[300],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
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
          Consumer<ForumViewModel>(builder: (context, model, child) {
            if (model.isLoading) {
              return const LoadingShimmer();
            }
            if (model.posts.isEmpty) {
              return Expanded(
                  child: Center(
                      child:
                          Text("No Post Available", style: AppTheme.h1Style)));
            }
            return Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await model.fetchPost();
                },
                child: showMyPosts
                    ? _buildMyPostsList(model)
                    : _buildPostsList(model),
              ),
            );
          })
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
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: forumViewModel.posts.length,
      itemBuilder: (context, index) {
        return _buildPostCard(forumViewModel.posts[index], forumViewModel);
      },
    );
  }

  Widget _buildMyPostsList(ForumViewModel forumViewModel) {
    // Filter the posts to show only the user's posts
    var myPosts = forumViewModel.posts
        .where((post) => post.creator == userViewModel.userId)
        .toList();

    if (myPosts.isEmpty) {
      return Center(
          child: Text("No Post Added By You", style: AppTheme.h1Style));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: myPosts.length,
      itemBuilder: (context, index) {
        var post = myPosts[index];
        return _buildPostCard(post, forumViewModel);
      },
    );
  }

  void _showPostOptionsBottomSheet(Post post, bool isMyPost) {
    print("ismypost : ${isMyPost}");
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CustomOptionsBottomSheet(
        options: [
          if (isMyPost)
            OptionItem(
              icon: Icons.edit,
              label: 'Edit Post',
              color: Colors.blue.shade800,
              onTap: () {
                GoRouter.of(context)
                    .push("/student/forum/editPost/${post.postID}");
              },
            ),
          if (isMyPost || userViewModel.role == ROLE_ADMIN)
            OptionItem(
              icon: Icons.delete_outline_rounded,
              label: 'Delete Post',
              color: Colors.red.shade600,
              onTap: () {
                confirmDelete(post.postID!);
              },
            ),
            OptionItem(
  icon: Icons.share,
  label: 'Share Post',
  color: Colors.blue.shade600, // Changed from red to blue for consistency
  onTap: () async {
    try {
      final box = context.findRenderObject() as RenderBox?;
      String shareText = '${post.title}\n\n${post.content}';
      
     
      shareText += '\n\nCheck out this post in our app: HCI Mastery';
      
      await Share.share(
        shareText,
        subject: 'Check out this post: ${post.title}',
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
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
        ],
      ),
    );
  }

  Widget _buildPostCard(Post post, ForumViewModel forumViewModel,
    ) {
    var isLiked = forumViewModel.isLikedByUser[post.postID] ?? false;
    int index = forumViewModel.posts.indexWhere((p) => p.postID == post.postID);
    var isMyPost = post.creator == userViewModel.userId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          child: InkWell(
            onTap: () {
              if (post.postID != null) {
                GoRouter.of(context).push("/forum/postDetail/${post.postID}");
              }
            },
            onLongPress: () {
              _showPostOptionsBottomSheet(post, isMyPost);
            },
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.title, style: AppTheme.h2Style),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(
                          forumViewModel
                                  .userMap[post.creator]?.profileImagePath ??
                              "https://cdn-icons-png.flaticon.com/512/9368/9368192.png",
                        ),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            forumViewModel.userMap[post.creator]?.name ??
                                "unknown",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('dd MMM yyyy, hh:mm a')
                                .format(post.timeCreated),
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

                  const SizedBox(height: 10),
                  // Post Content
                  Text(post.content, style: AppTheme.h5Style
                      // style: GoogleFonts.poppins(
                      //   fontSize: 16,
                      //   color: Colors.grey[800],
                      // ),
                      ),
                  const SizedBox(height: 10),
                  // Post Image (if any)
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
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
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
                  const SizedBox(height: 10),
                  // Like, Comment, Edit, and Delete Buttons
                  Row(
                    children: [
                      // Like Button
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked
                              ? Colors.pinkAccent
                              : const Color(0xFF757575),
                        ),
                        onPressed: () async {
                          final postID = post.postID;
                          if (postID != null) {
                            if (isLiked) {
                              await forumViewModel.unlikePost(
                                  index, userViewModel.userId!);
                            } else {
                              await forumViewModel.likePost(
                                  index, userViewModel.userId!);
                            }
                          }
                        },
                      ),
                      Text(
                        '${forumViewModel.posts[index].likedByUserIds.length} likes',
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
                        '${forumViewModel.posts[index].replies.length} replies',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: const Color(0xFF757575),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
