import 'package:manage_state/domain/comments/entities/comment_user.dart';

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
