import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/data/home/models/story_model.dart';
import 'package:manage_state/data/home/models/post_model.dart';

abstract class HomeRemoteDataSource {
  Future<List<StoryModel>> getStories();
  Future<List<PostModel>> getPosts();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);
  @override
  Future<List<StoryModel>> getStories() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final data = [
      {'name': 'Sarah J.', 'avatarUrl': 'https://i.pravatar.cc/150?img=5', 'imageUrl': 'https://picsum.photos/200/300?random=1'},
      {'name': 'Mike T.', 'avatarUrl': 'https://i.pravatar.cc/150?img=8', 'imageUrl': 'https://picsum.photos/200/300?random=2'},
      {'name': 'Anna B.', 'avatarUrl': 'https://i.pravatar.cc/150?img=9', 'imageUrl': 'https://picsum.photos/200/300?random=3'},
      {'name': 'John D.', 'avatarUrl': 'https://i.pravatar.cc/150?img=13', 'imageUrl': 'https://picsum.photos/200/300?random=4'},
      {'name': 'Emma W.', 'avatarUrl': 'https://i.pravatar.cc/150?img=22', 'imageUrl': 'https://picsum.photos/200/300?random=5'},
      {'name': 'Liam K.', 'avatarUrl': 'https://i.pravatar.cc/150?img=33', 'imageUrl': 'https://picsum.photos/200/300?random=6'},
      {'name': 'Olivia P.', 'avatarUrl': 'https://i.pravatar.cc/150?img=44', 'imageUrl': 'https://picsum.photos/200/300?random=7'},
      {'name': 'Noah R.', 'avatarUrl': 'https://i.pravatar.cc/150?img=55', 'imageUrl': 'https://picsum.photos/200/300?random=8'},
      {'name': 'Ava S.', 'avatarUrl': 'https://i.pravatar.cc/150?img=47', 'imageUrl': 'https://picsum.photos/200/300?random=9'},
    ];

    return data.map((json) => StoryModel.fromJson(json)).toList();
  }

  @override
  Future<List<PostModel>> getPosts() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));

    final data = [
      {
        'authorName': 'Jessica Chen',
        'authorAvatar': 'https://i.pravatar.cc/150?img=3',
        'timeAgo': '2 hrs',
        'content': 'Just finished setting up the new workspace!\nReady to tackle the week ahead. 💻✨',
        'imageUrl': 'https://picsum.photos/600/400?random=10',
        'likes': 124,
        'comments': 23,
        'shares': 5,
        'isLiked': false,
      },
      {
        'authorName': 'David Smith',
        'authorAvatar': 'https://i.pravatar.cc/150?img=12',
        'timeAgo': '5 hrs',
        'content': 'Beautiful day for a hike! 🌲⛰️',
        'imageUrl': 'https://picsum.photos/600/400?random=15',
        'likes': 89,
        'comments': 12,
        'shares': 2,
        'isLiked': true,
      },
      {
        'authorName': 'Emily Davis',
        'authorAvatar': 'https://i.pravatar.cc/150?img=5',
        'timeAgo': '8 hrs',
        'content': 'Just baked my first sourdough bread! Smells amazing. 🍞😋',
        'imageUrl': 'https://picsum.photos/600/400?random=21',
        'likes': 210,
        'comments': 45,
        'shares': 12,
        'isLiked': false,
      },
      {
        'authorName': 'Michael Johnson',
        'authorAvatar': 'https://i.pravatar.cc/150?img=8',
        'timeAgo': 'Yesterday',
        'content': 'Great match tonight! The team played brilliantly. ⚽🔥',
        'imageUrl': 'https://picsum.photos/600/400?random=33',
        'likes': 345,
        'comments': 88,
        'shares': 40,
        'isLiked': true,
      },
      {
        'authorName': 'Sarah Wilson',
        'authorAvatar': 'https://i.pravatar.cc/150?img=20',
        'timeAgo': 'Yesterday',
        'content': 'Enjoying a quiet evening with a good book and some coffee. ☕📚',
        'imageUrl': 'https://picsum.photos/600/400?random=18',
        'likes': 112,
        'comments': 14,
        'shares': 3,
        'isLiked': false,
      },
      {
        'authorName': 'James Lee',
        'authorAvatar': 'https://i.pravatar.cc/150?img=15',
        'timeAgo': '2 days ago',
        'content': 'Throwback to the amazing trip to Kyoto. Take me back! 🌸🏯',
        'imageUrl': 'https://picsum.photos/600/400?random=45',
        'likes': 560,
        'comments': 102,
        'shares': 23,
        'isLiked': false,
      },
      {
        'authorName': 'Amanda Martinez',
        'authorAvatar': 'https://i.pravatar.cc/150?img=32',
        'timeAgo': '3 days ago',
        'content': 'New setup complete! Finally organized my desk. What do you guys think? 💻🎨',
        'imageUrl': 'https://picsum.photos/600/400?random=52',
        'likes': 420,
        'comments': 56,
        'shares': 15,
        'isLiked': true,
      },
    ];

    return data.map((json) => PostModel.fromJson(json)).toList();
  }
}
