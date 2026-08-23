import 'package:manage_state/data/profile/datasources/profile_remote_datasource.dart';
import 'package:manage_state/domain/profile/entities/user_profile.dart';
import 'package:manage_state/domain/profile/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserProfile> getUserProfile() async {
    try {
      return await remoteDataSource.getUserProfile();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
