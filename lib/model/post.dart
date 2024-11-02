import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore for Timestamp

class Post {
  final String? postID;
  final String title;
  final String creator;
  final String content;
  final List<String>? images;
  final List<String> likedByUserIds;
  final List<Reply> replies;
  final DateTime timeCreated;
  final bool editStatus;

  Post({
    this.postID,
    required this.title,
    required this.creator,
    required this.content,
    this.images,
    List<String>? likedByUserIds,
    List<Reply>? replies,
    required this.timeCreated,
    required this.editStatus,
  })  : likedByUserIds = likedByUserIds ?? [],
        replies = replies ?? [];

  Map<String, dynamic> toMap() {
    return {
      'postID': postID,
      'title': title,
      'creator': creator,
      'content': content,
      'images': images,
      'likedByUserIds': likedByUserIds,
      'replies': replies.map((reply) => reply.toMap()).toList(),
      'timeCreated': timeCreated.toIso8601String(),
      'editStatus': editStatus,
    };
  }

  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postID: map['postID'] as String?,
      title: map['title'] ?? '',
      creator: map['creator'] ?? '',
      content: map['content'] ?? '',
      images: map['images'] != null ? List<String>.from(map['images']) : [],
      likedByUserIds: map['likedByUserIds'] != null
          ? List<String>.from(map['likedByUserIds'])
          : [],
      replies: map['replies'] != null
          ? (map['replies'] as List<dynamic>)
              .map(
                  (replyMap) => Reply.fromMap(replyMap as Map<String, dynamic>))
              .toList()
          : [],
      timeCreated: map['timeCreated'] is Timestamp
          ? (map['timeCreated'] as Timestamp)
              .toDate() // Convert Timestamp to DateTime
          : DateTime.now(), // Default to now if timeCreated is missing
      editStatus: map['editStatus'] ?? false,
    );
  }

  void like(String userId) {
    if (!likedByUserIds.contains(userId)) {
      likedByUserIds.add(userId);
    }
  }

  void unlike(String userId) {
    likedByUserIds.remove(userId);
  }

  void addReply(Reply reply) {
    replies.add(reply);
  }
}

class Reply {
  final String creator;
  final String content;
  final DateTime timeCreated;

  Reply({
    required this.creator,
    required this.content,
    required this.timeCreated,
  });

  Map<String, dynamic> toMap() {
    return {
      'creator': creator,
      'content': content,
      'timeCreated': timeCreated.toIso8601String(),
    };
  }

  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      creator: map['creator'] ?? '',
      content: map['content'] ?? '',
      timeCreated: map['timeCreated'] is Timestamp
          ? (map['timeCreated'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
