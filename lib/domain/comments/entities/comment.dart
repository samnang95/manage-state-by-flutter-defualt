class CommentUser {
  final int id;
  final String username;
  final String fullName;

  CommentUser({
    required this.id,
    required this.username,
    required this.fullName,
  });
}

class Comment {
  final int id;
  final String body;
  final int postId;
  final int likes;
  final CommentUser user;
  final String? timeAgo; 

  Comment({
    required this.id,
    required this.body,
    required this.postId,
    required this.likes,
    required this.user,
    this.timeAgo,
  });
}
