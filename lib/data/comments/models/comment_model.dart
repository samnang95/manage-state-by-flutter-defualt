import 'package:manage_state/domain/comments/entities/comment.dart';

class CommentUserModel extends CommentUser {
  CommentUserModel({
    required super.id,
    required super.username,
    required super.fullName,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'],
      username: json['username'],
      fullName: json['fullName'],
    );
  }
}

class CommentModel extends Comment {
  CommentModel({
    required super.id,
    required super.body,
    required super.postId,
    required super.likes,
    required super.user,
    super.timeAgo,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      body: json['body'],
      postId: json['postId'],
      likes: json['likes'] ?? 0,
      user: CommentUserModel.fromJson(json['user']),
      timeAgo: json['timeAgo'],
    );
  }
}
