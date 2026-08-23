class ReelItem {
  final String id;
  final String videoUrl;
  final String thumbnailUrl;
  final String authorName;
  final String authorAvatarUrl;
  final String description;
  final String likesCount;
  final String commentsCount;
  final String sharesCount;
  final String savesCount;
  final bool isFollowing;

  const ReelItem({
    required this.id,
    required this.videoUrl,
    required this.thumbnailUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.description,
    required this.likesCount,
    required this.commentsCount,
    required this.sharesCount,
    required this.savesCount,
    this.isFollowing = false,
  });
}
