import 'package:manage_state/domain/reels/entities/reel_item.dart';

class ReelItemModel extends ReelItem {
  const ReelItemModel({
    required super.id,
    required super.videoUrl,
    required super.thumbnailUrl,
    required super.authorName,
    required super.authorAvatarUrl,
    required super.description,
    required super.likesCount,
    required super.commentsCount,
    required super.sharesCount,
    required super.savesCount,
    super.isFollowing = false,
  });

  factory ReelItemModel.fromJson(Map<String, dynamic> json) {
    return ReelItemModel(
      id: json['id'],
      videoUrl: json['videoUrl'],
      thumbnailUrl: json['thumbnailUrl'],
      authorName: json['authorName'],
      authorAvatarUrl: json['authorAvatarUrl'],
      description: json['description'],
      likesCount: json['likesCount'],
      commentsCount: json['commentsCount'],
      sharesCount: json['sharesCount'],
      savesCount: json['savesCount'],
      isFollowing: json['isFollowing'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'authorName': authorName,
      'authorAvatarUrl': authorAvatarUrl,
      'description': description,
      'likesCount': likesCount,
      'commentsCount': commentsCount,
      'sharesCount': sharesCount,
      'savesCount': savesCount,
      'isFollowing': isFollowing,
    };
  }
}
