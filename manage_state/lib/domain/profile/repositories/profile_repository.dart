import 'package:manage_state/domain/profile/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<UserProfile> getUserProfile();
}
