import 'package:manage_state/domain/home/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required super.authorName,
    required super.authorAvatar,
    required super.timeAgo,
    required super.content,
    required super.imageUrl,
    required super.likes,
    required super.comments,
    required super.shares,
    super.isLiked,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      authorName: json['authorName'],
      authorAvatar: json['authorAvatar'],
      timeAgo: json['timeAgo'],
      content: json['content'],
      imageUrl: json['imageUrl'],
      likes: json['likes'],
      comments: json['comments'],
      shares: json['shares'],
      isLiked: json['isLiked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'authorName': authorName,
      'authorAvatar': authorAvatar,
      'timeAgo': timeAgo,
      'content': content,
      'imageUrl': imageUrl,
      'likes': likes,
      'comments': comments,
      'shares': shares,
      'isLiked': isLiked,
    };
  }
}
