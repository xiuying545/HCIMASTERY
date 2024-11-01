class Post {
  final int? postID; 
  final String title; 
  final int creator; 
  final String content;
  final String? images;
  final List<String> likedByUserIds;
  final List<Reply> replies; 
  final DateTime timeCreated; 

  Post({
     this.postID,
    required this.title,
    required this.creator,
    required this.content,
    this.images,
    List<String>? likedByUserIds,
    List<Reply>? replies,
    required this.timeCreated,
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
    };
  }


  factory Post.fromMap(Map<String, dynamic> map) {
    return Post(
      postID: map['postID'],
      title: map['title'],
      creator: map['creator'],
      content: map['content'],
      images: map['images'],
      likedByUserIds: List<String>.from(map['likedByUserIds'] ?? []),
      replies: List<Reply>.from(map['replies']?.map((replyMap) => Reply.fromMap(replyMap)) ?? []),
      timeCreated: DateTime.parse(map['timeCreated']), 
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
  final String userId; 
  final String content; 
  final DateTime timeCreated;

  Reply({
    required this.userId,
    required this.content,
    required this.timeCreated,
  });

 
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'content': content,
      'timeCreated': timeCreated.toIso8601String(), 
    };
  }


  factory Reply.fromMap(Map<String, dynamic> map) {
    return Reply(
      userId: map['userId'],
      content: map['content'],
      timeCreated: DateTime.parse(map['timeCreated']),
    );
  }
}
