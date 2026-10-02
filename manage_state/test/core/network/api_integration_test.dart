import 'package:flutter_test/flutter_test.dart';
import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';
import 'package:manage_state/data/home/datasources/home_remote_datasource.dart';
import 'package:manage_state/data/profile/datasources/profile_remote_datasource.dart';
import 'package:manage_state/data/comments/datasources/get_comments_remote_datasource.dart';
import 'package:manage_state/data/friends/datasources/friends_remote_datasource.dart';
import 'package:manage_state/data/marketplace/datasources/marketplace_remote_datasource.dart';
import 'package:manage_state/data/notifications/datasources/notifications_remote_datasource.dart';
import 'package:manage_state/data/reels/datasources/reels_remote_datasource.dart';

import 'package:manage_state/core/network/env_config.dart';

void main() {
  group('Live API Integration Tests', () {
    late ApiClient apiClient;

    setUp(() {
      apiClient = ApiClient(baseUrl: EnvConfig.baseUrl);
    });

    test('1. Auth login returns user and sets tokens', () async {
      final authDs = AuthRemoteDataSourceImpl(apiClient);
      final user = await authDs.login('jane@example.com', 'password123');
      expect(user.name, equals('Jane Doe'));
      expect(user.email, equals('jane@example.com'));
    });

    test('2. Home remote datasource fetches stories and posts', () async {
      final homeDs = HomeRemoteDataSourceImpl(apiClient);
      final stories = await homeDs.getStories();
      final posts = await homeDs.getPosts();

      expect(stories, isNotEmpty);
      expect(posts, isNotEmpty);
      expect(stories.first.name, isNotEmpty);
      expect(posts.first.authorName, isNotEmpty);
    });

    test('3. Profile remote datasource fetches profile', () async {
      final profileDs = ProfileRemoteDataSourceImpl(apiClient);
      final profile = await profileDs.getUserProfile();

      expect(profile.name, equals('Jane Doe'));
      expect(profile.location, equals('Phnom Penh'));
    });

    test('4. Comments remote datasource fetches comments', () async {
      final commentsDs = GetCommentsRemoteDataSourceImpl(apiClient);
      final comments = await commentsDs.getComments();

      expect(comments, isNotEmpty);
    });

    test('5. Friends remote datasource fetches friend requests', () async {
      final friendsDs = FriendsRemoteDataSourceImpl(apiClient);
      final requests = await friendsDs.getFriendRequests();

      expect(requests, isNotEmpty);
      expect(requests.first.name, equals('Key Som'));
    });

    test('6. Marketplace remote datasource fetches items', () async {
      final marketDs = MarketplaceRemoteDataSourceImpl(apiClient);
      final items = await marketDs.getItems();

      expect(items, isNotEmpty);
      expect(items.first.title, contains('Sony'));
    });

    test('7. Notifications remote datasource fetches new and today notifications', () async {
      final notifDs = NotificationsRemoteDataSourceImpl(apiClient);
      final newNotifs = await notifDs.getNewNotifications();
      final todayNotifs = await notifDs.getTodayNotifications();

      expect(newNotifs, isNotEmpty);
      expect(todayNotifs, isNotEmpty);
    });

    test('8. Reels remote datasource fetches reels', () async {
      final reelsDs = ReelsRemoteDataSourceImpl(apiClient);
      final reels = await reelsDs.getReels();

      expect(reels, isNotEmpty);
      expect(reels.first.authorName, equals('Shadow Project'));
    });
  });
}
