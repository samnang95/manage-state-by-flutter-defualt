import 'package:manage_state/core/network/api_client.dart';

import 'package:manage_state/data/reels/models/reel_item_model.dart';

abstract class ReelsRemoteDataSource {
  Future<List<ReelItemModel>> getReels();
}

class ReelsRemoteDataSourceImpl implements ReelsRemoteDataSource {
  final ApiClient apiClient;

  ReelsRemoteDataSourceImpl(this.apiClient);

  @override
  Future<List<ReelItemModel>> getReels() async {
    await Future.delayed(const Duration(milliseconds: 500));
    final data = [
      { 'id': '1', 'videoUrl': '', 'thumbnailUrl': 'https://picsum.photos/seed/reel1/400/800', 'authorName': 'Shadow Project', 'authorAvatarUrl': 'https://i.pravatar.cc/150?img=11', 'description': 'អ្នកខ្សោយបេះដូងហាមស្តាប់ | បងឆេង | S... more', 'likesCount': '36k', 'commentsCount': '617', 'sharesCount': '4.6k', 'savesCount': '4.6k', 'isFollowing': false, },
      { 'id': '2', 'videoUrl': '', 'thumbnailUrl': 'https://picsum.photos/seed/reel2/400/800', 'authorName': 'Funny Cats', 'authorAvatarUrl': 'https://i.pravatar.cc/150?img=12', 'description': 'Cute cats doing funny things! 😂 #cats #funny', 'likesCount': '120k', 'commentsCount': '1.2k', 'sharesCount': '15k', 'savesCount': '20k', 'isFollowing': true, },
      { 'id': '3', 'videoUrl': '', 'thumbnailUrl': 'https://picsum.photos/seed/reel3/400/800', 'authorName': 'Tech News Today', 'authorAvatarUrl': 'https://i.pravatar.cc/150?img=13', 'description': 'New iPhone 16 leaks! 📱 #apple #tech', 'likesCount': '45k', 'commentsCount': '800', 'sharesCount': '2.1k', 'savesCount': '5k', 'isFollowing': false, },
    ];

    return data.map((json) => ReelItemModel.fromJson(json)).toList();
  }
}
