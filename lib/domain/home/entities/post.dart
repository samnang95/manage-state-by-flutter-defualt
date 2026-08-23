class Post {
  final String authorName;
  final String authorAvatar;
  final String timeAgo;
  final String content;
  final String imageUrl;
  int likes;
  final int comments;
  final int shares;
  bool isLiked;

  Post({
    required this.authorName,
    required this.authorAvatar,
    required this.timeAgo,
    required this.content,
    required this.imageUrl,
    required this.likes,
    required this.comments,
    required this.shares,
    this.isLiked = false,
  });
}
