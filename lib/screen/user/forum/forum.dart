import 'package:flutter/material.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  Map<String, bool> isLikedByUser = {};

  @override
  void initState() {
    super.initState();
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
        title: const Text('Forum'),
        backgroundColor: const Color(0xFFefeefb),
        elevation: 0,
      ),
      body: Container(
        color: const Color(0xFFefeefb),
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: forumViewModel.posts.length,
          itemBuilder: (context, index) {
            var post = forumViewModel.posts[index];
            var isLiked = isLikedByUser[post.postID] ?? false;

            return GestureDetector(
              onTap: () {
                if (post.postID != null) {
                  context.go("/student/forum/postDetail/${post.postID}");
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Card(
                  color:Colors.white,
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3f5fd7)),
                          ),
                        ),
                        const Divider(
                          height: 25,
                          thickness: 0.5,
                          color: Color(0xFF3f5fd7),
                          indent: 0,
                          endIndent: 0,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  !post.editStatus
                                      ? "posted on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}"
                                      : "edited on ${DateFormat('yyyy-MM-dd').format(post.timeCreated)}",
                                  style: const TextStyle(
                                    fontSize: 16,
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
                            color: Color.fromARGB(85, 209, 207, 207),
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
                                        : Colors.white,
                                    onPressed: () async {
                                      final postID = post.postID;
                                      if (postID != null) {
                                        if (isLiked) {
                                          await forumViewModel.unlikePost(
                                              postID, "1");
                                          setState(() {
                                            isLikedByUser[postID] = false;
                                          });
                                        } else {
                                          await forumViewModel.likePost(
                                              postID, "1");
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
                                      color: Color.fromARGB(255, 98, 98, 98),
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                              Text(

                                '${forumViewModel.posts[index].replies.length} replies',
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 98, 98, 98),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              post.creator == "1"
                                  ? Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit_outlined),
                                          color: const Color(0xFF3f5fd7),
                                          onPressed: () {
                                            context.go(
                                                "/student/forum/editPost/${post.postID}");
                                          },
                                          padding: EdgeInsets.zero,
                                        ),
                                        IconButton(
                                          icon:
                                              const Icon(Icons.delete_outline),
                                          color: const Color(0xFF3f5fd7),
                                          onPressed: () {
                                            if (post.postID != null) {
                                              confirmDelete(post.postID!);
                                            }
                                          },
                                          padding: EdgeInsets.zero,
                                        ),
                                      ],
                                    )
                                  : const SizedBox(width: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go("/student/forum/addPost");
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3f5fd7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
