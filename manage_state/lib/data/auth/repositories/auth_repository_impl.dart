import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';
import 'package:manage_state/domain/auth/entities/user.dart';
import 'package:manage_state/domain/auth/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      return userModel; 
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
