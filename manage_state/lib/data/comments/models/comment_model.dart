import 'package:manage_state/domain/comments/entities/comment.dart';
import 'package:manage_state/data/comments/models/comment_user_model.dart';

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
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      body: json['body']?.toString() ?? '',
      postId: json['postId'] is int
          ? json['postId'] as int
          : int.tryParse(json['postId']?.toString() ?? '') ?? 1,
      likes: json['likes'] is int
          ? json['likes'] as int
          : int.tryParse(json['likes']?.toString() ?? '') ?? 0,
      user: json['user'] != null
          ? CommentUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : CommentUserModel(id: 0, username: 'user', fullName: 'User'),
      timeAgo: json['timeAgo']?.toString() ?? 'Just now',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'body': body,
      'postId': postId,
      'likes': likes,
      'user': (user is CommentUserModel)
          ? (user as CommentUserModel).toJson()
          : {
              'id': user.id,
              'username': user.username,
              'fullName': user.fullName,
            },
      'timeAgo': timeAgo,
    };
  }
}
