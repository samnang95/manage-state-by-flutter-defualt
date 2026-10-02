import 'package:manage_state/domain/comments/entities/comment_user.dart';

class CommentUserModel extends CommentUser {
  CommentUserModel({
    required super.id,
    required super.username,
    required super.fullName,
  });

  factory CommentUserModel.fromJson(Map<String, dynamic> json) {
    return CommentUserModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      username: json['username']?.toString() ?? '',
      fullName: json['fullName']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'fullName': fullName,
    };
  }
}
