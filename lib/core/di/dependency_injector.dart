// Auth
import 'package:manage_state/presentation/auth/controllers/auth_controller.dart';
import 'package:manage_state/domain/auth/usecases/login_usecase.dart';
import 'package:manage_state/data/auth/repositories/auth_repository_impl.dart';
import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';

// Home
import 'package:manage_state/data/home/datasources/home_remote_datasource.dart';
import 'package:manage_state/data/home/repositories/home_repository_impl.dart';
import 'package:manage_state/domain/home/repositories/home_repository.dart';
import 'package:manage_state/domain/home/usecases/get_posts_usecase.dart';
import 'package:manage_state/domain/home/usecases/get_stories_usecase.dart';
import 'package:manage_state/presentation/home/controllers/home_controller.dart';

// Friends
import 'package:manage_state/data/friends/datasources/friends_remote_datasource.dart';
import 'package:manage_state/data/friends/repositories/friends_repository_impl.dart';
import 'package:manage_state/domain/friends/repositories/friends_repository.dart';
import 'package:manage_state/domain/friends/usecases/get_friend_requests_usecase.dart';
import 'package:manage_state/presentation/friends/controllers/friends_controller.dart';

// Marketplace
import 'package:manage_state/data/marketplace/datasources/marketplace_remote_datasource.dart';
import 'package:manage_state/data/marketplace/repositories/marketplace_repository_impl.dart';
import 'package:manage_state/domain/marketplace/repositories/marketplace_repository.dart';
import 'package:manage_state/domain/marketplace/usecases/get_marketplace_items_usecase.dart';
import 'package:manage_state/presentation/marketplace/controllers/marketplace_controller.dart';

// Notifications
import 'package:manage_state/data/notifications/datasources/notifications_remote_datasource.dart';
import 'package:manage_state/data/notifications/repositories/notifications_repository_impl.dart';
import 'package:manage_state/domain/notifications/repositories/notifications_repository.dart';
import 'package:manage_state/domain/notifications/usecases/get_notifications_usecase.dart';
import 'package:manage_state/presentation/notifications/controllers/notifications_controller.dart';

// Reels
import 'package:manage_state/data/reels/datasources/reels_remote_datasource.dart';
import 'package:manage_state/data/reels/repositories/reels_repository_impl.dart';
import 'package:manage_state/domain/reels/repositories/reels_repository.dart';
import 'package:manage_state/domain/reels/usecases/get_reels_usecase.dart';
import 'package:manage_state/presentation/reels/controllers/reels_controller.dart';

// Profile
import 'package:manage_state/data/profile/datasources/profile_remote_datasource.dart';
import 'package:manage_state/data/profile/repositories/profile_repository_impl.dart';
import 'package:manage_state/domain/profile/repositories/profile_repository.dart';
import 'package:manage_state/domain/profile/usecases/get_user_profile_usecase.dart';
import 'package:manage_state/presentation/profile/controllers/profile_controller.dart';

// Comments
import 'package:manage_state/data/comments/datasources/comments_remote_datasource.dart';
import 'package:manage_state/data/comments/repositories/comments_repository_impl.dart';
import 'package:manage_state/domain/comments/repositories/comments_repository.dart';
import 'package:manage_state/domain/comments/usecases/get_comments_usecase.dart';
import 'package:manage_state/presentation/comments/controllers/comments_controller.dart';

import 'package:manage_state/core/network/api_client.dart';
import 'package:manage_state/core/network/token_manager.dart';
import 'package:manage_state/core/network/env_config.dart';

class DependencyInjector {
  // Singleton instance
  static final DependencyInjector _instance = DependencyInjector._internal();
  static DependencyInjector get instance => _instance;

  DependencyInjector._internal();

  // 1. Core Services
  late final TokenManager tokenManager = InMemoryTokenManager();
  
  late final ApiClient apiClient = ApiClient(
    baseUrl: EnvConfig.baseUrl,
    tokenManager: tokenManager,
    onRefreshToken: () async {
      // Mock Refresh Token Logic
      final currentRefreshToken = tokenManager.refreshToken;
      if (currentRefreshToken == null) return false;

      // Simulate API call to refresh token
      await Future.delayed(const Duration(seconds: 1));
      
      // Save new mocked tokens
      await tokenManager.saveTokens(
        accessToken: 'new_access_token_mock',
        refreshToken: 'new_refresh_token_mock',
      );
      
      return true;
    },
  );

  // ==========================================
  // Auth Feature
  // ==========================================
  late final AuthRemoteDataSource _authDataSource = AuthRemoteDataSourceImpl(apiClient);
  late final _authRepository = AuthRepositoryImpl(_authDataSource);
  late final _loginUseCase = LoginUseCase(_authRepository);

  late final AuthController _authController = AuthController(loginUseCase: _loginUseCase);

  AuthController getAuthController() => _authController;

  // ==========================================
  // Home Feature
  // ==========================================
  late final HomeRemoteDataSource _homeDataSource = HomeRemoteDataSourceImpl(apiClient);
  late final HomeRepository _homeRepository = HomeRepositoryImpl(_homeDataSource);
  late final GetStoriesUseCase _getStoriesUseCase = GetStoriesUseCase(_homeRepository);
  late final GetPostsUseCase _getPostsUseCase = GetPostsUseCase(_homeRepository);

  HomeController getHomeController() => HomeController(getStoriesUseCase: _getStoriesUseCase, getPostsUseCase: _getPostsUseCase);

  // ==========================================
  // Friends Feature
  // ==========================================
  late final FriendsRemoteDataSource _friendsDataSource = FriendsRemoteDataSourceImpl(apiClient);
  late final FriendsRepository _friendsRepository = FriendsRepositoryImpl(_friendsDataSource);
  late final GetFriendRequestsUseCase _getFriendRequestsUseCase = GetFriendRequestsUseCase(_friendsRepository);

  FriendsController getFriendsController() => FriendsController(getFriendRequestsUseCase: _getFriendRequestsUseCase);

  // ==========================================
  // Marketplace Feature
  // ==========================================
  late final MarketplaceRemoteDataSource _marketplaceDataSource = MarketplaceRemoteDataSourceImpl(apiClient);
  late final MarketplaceRepository _marketplaceRepository = MarketplaceRepositoryImpl(_marketplaceDataSource);
  late final GetMarketplaceItemsUseCase _getMarketplaceItemsUseCase = GetMarketplaceItemsUseCase(_marketplaceRepository);

  MarketplaceController getMarketplaceController() => MarketplaceController(getItemsUseCase: _getMarketplaceItemsUseCase);

  // ==========================================
  // Notifications Feature
  // ==========================================
  late final NotificationsRemoteDataSource _notificationsDataSource = NotificationsRemoteDataSourceImpl(apiClient);
  late final NotificationsRepository _notificationsRepository = NotificationsRepositoryImpl(_notificationsDataSource);
  late final GetNotificationsUseCase _getNotificationsUseCase = GetNotificationsUseCase(_notificationsRepository);

  NotificationsController getNotificationsController() => NotificationsController(getNotificationsUseCase: _getNotificationsUseCase);

  // ==========================================
  // Reels Feature
  // ==========================================
  late final ReelsRemoteDataSource _reelsDataSource = ReelsRemoteDataSourceImpl(apiClient);
  late final ReelsRepository _reelsRepository = ReelsRepositoryImpl(_reelsDataSource);
  late final GetReelsUseCase _getReelsUseCase = GetReelsUseCase(_reelsRepository);

  ReelsController getReelsController() => ReelsController(getReelsUseCase: _getReelsUseCase);

  // ==========================================
  // Profile Feature
  // ==========================================
  late final ProfileRemoteDataSource _profileDataSource = ProfileRemoteDataSourceImpl(apiClient);
  late final ProfileRepository _profileRepository = ProfileRepositoryImpl(_profileDataSource);
  late final GetUserProfileUseCase _getUserProfileUseCase = GetUserProfileUseCase(_profileRepository);

  ProfileController getProfileController() => ProfileController(getUserProfileUseCase: _getUserProfileUseCase);

  // ==========================================
  // Comments Feature
  // ==========================================
  late final CommentsRemoteDataSource _commentsDataSource = CommentsRemoteDataSourceImpl(apiClient);
  late final CommentsRepository _commentsRepository = CommentsRepositoryImpl(_commentsDataSource);
  late final GetCommentsUseCase _getCommentsUseCase = GetCommentsUseCase(_commentsRepository);

  CommentsController getCommentsController() => CommentsController(getCommentsUseCase: _getCommentsUseCase);

  // Initialize method for potential async setup in the future
  Future<void> init() async {
    // We can do any async pre-caching here if needed.
  }
}
