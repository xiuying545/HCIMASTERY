import 'package:flutter/material.dart';
import 'package:fyp1/common/app_theme.dart';
import 'package:fyp1/common/common_widget/blank_page.dart';
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

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  late UserViewModel userViewModel;
  late ForumViewModel forumViewModel;
  bool showMyPosts = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userViewModel = Provider.of<UserViewModel>(context, listen: false);
    forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPosts();
    });
  }

  Future<void> loadPosts() async {
    await forumViewModel.loadForumData(userViewModel.user!);
    setState(() {
      isLoading = false;
    });
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
      backgroundColor: const Color(0xFFFFFDF5),
      body: Column(
        children: [
          const SizedBox(height: 45),
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
                        showMyPosts ? const Color(0xFFFFF6EE) : const Color(0xff6C9FF6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'Posts',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: showMyPosts ? const Color(0xff475569) : Colors.white,
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
                        showMyPosts ? const Color(0xff6C9FF6) : const Color(0xFFFFF6EE),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'My Posts',
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: showMyPosts ? Colors.white : const Color(0xff475569),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Post List
          Consumer<ForumViewModel>(builder: (context, model, child) {
            if (model.isLoading || isLoading) {
              return const Expanded(child: LoadingShimmer());
            }
            if (model.posts.isEmpty) {
              return const Expanded(
                  child: BlankState(
                icon: Icons.post_add,
                title: 'No posts yet',
                subtitle: 'Tap the + button to add a new post',
              ));
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        backgroundColor: const Color(0xFF5E9FEF),
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
      return const Expanded(
          child: BlankState(
        icon: Icons.post_add,
        title: 'No posts added by you',
        subtitle: 'Tap the + button to add a new post',
      ));
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
    print("ismypost : $isMyPost");
    if (!isMyPost && userViewModel.role != ROLE_ADMIN) {
      if (!isMyPost && userViewModel.role != ROLE_ADMIN) {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(32)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 12,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            padding: const EdgeInsets.only(top: 8, bottom: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 60,
                  height: 6,
                  margin: const EdgeInsets.only(top: 12, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),

                // Message box
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 50,
                        color: Color(0xFF9CA3AF),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Access Denied",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF0645AD),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        "You cannot edit or delete posts that are not yours.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.comicNeue(
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // OK button (styled like your cancel button)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2E7FB),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Okay',
                              style: GoogleFonts.comicNeue(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF0645AD),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    } else {
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
          ],
        ),
      );
    }
  }

  Widget _buildPostCard(
    Post post,
    ForumViewModel forumViewModel,
  ) {
    var isLiked = forumViewModel.isLikedByUser[post.postID] ?? false;
    int index = forumViewModel.posts.indexWhere((p) => p.postID == post.postID);
    var isMyPost = post.creator == userViewModel.userId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFFF7F9FC),
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
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post.title,
                    style: GoogleFonts.fredoka(
                        fontSize: 23,
                        color: Colors.blue.shade900,
                        fontWeight: FontWeight.bold),
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
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            isMyPost
                                ? '${forumViewModel.userMap[post.creator]?.name} (You)'
                                : forumViewModel.userMap[post.creator]?.name ??
                                    "Deleted User",
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

                  const SizedBox(height: 10),
                  // Post Content
                  Text(
                    post.content,
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      color: Colors.grey[800],
                    ),
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
                              ? const Color(0xffFF6B6B)
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
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: const Color(0xff94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 20),
                      // Comment Button
                      const Icon(Icons.comment, color: Color(0xFF757575)),
                      const SizedBox(width: 5),
                      Text(
                        '${forumViewModel.posts[index].replies.length} replies',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          color: const Color(0xFF757575),
                          fontWeight: FontWeight.w500,
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
