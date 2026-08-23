import 'package:manage_state/domain/profile/entities/user_profile.dart';
import 'package:manage_state/domain/profile/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<UserProfile> call() {
    return repository.getUserProfile();
  }
}
