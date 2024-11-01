import 'package:flutter/material.dart';
import 'package:fyp1/modelview/forumviewmodel.dart';
import 'package:provider/provider.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  _ForumPageState createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  @override
  void initState() {
    super.initState();
     loadPosts();
  }

  void loadPosts() async {
    final forumViewModel = Provider.of<ForumViewModel>(context, listen: false);
    await forumViewModel.fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    final forumViewModel = Provider.of<ForumViewModel>(context);

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
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Card(
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
                          forumViewModel.posts[index].title,
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
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "post on ${forumViewModel.posts[index].timeCreated}",
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
                          forumViewModel.posts[index].content,
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
                                FutureBuilder<bool>(
                                  future: forumViewModel.checkIfPostLiked(
                                      forumViewModel.posts[index].postID!,
                                      1),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const CircularProgressIndicator();
                                    } else if (snapshot.hasError) {
                                      return const Icon(Icons.error);
                                    } else {
                                      final isLiked = snapshot.data ?? false;
                                      return IconButton(
                                        icon: const Icon(Icons.favorite),
                                        color: isLiked
                                            ? Colors.pinkAccent
                                            : Colors.white,
                                        onPressed: () {
                                          if (isLiked) {
                                            forumViewModel.unlikePost(
                                                forumViewModel.posts[index]
                                                    .postID!,
                                                1);
                                          } else {
                                            forumViewModel.likePost(
                                                forumViewModel.posts[index]
                                                    .postID!,
                                                1);
                                          }
                                        },
                                      );
                                    }
                                  },
                                ),
                                Text(
                                  '${forumViewModel.posts[index].likedByUserIds.length} likes',
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
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  color: const Color(0xFF3f5fd7),
                                  onPressed: () {
                                    // Implement edit functionality
                                  },
                                  padding: EdgeInsets.zero,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  color: const Color(0xFF3f5fd7),
                                  onPressed: () {
                                    // Implement delete functionality
                                  },
                                  padding: EdgeInsets.zero,
                                ),
                              ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Define the action for adding a new post
        },
        shape: const CircleBorder(),
        backgroundColor: const Color(0xFF3f5fd7),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
