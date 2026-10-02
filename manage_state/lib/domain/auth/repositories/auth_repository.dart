import 'package:manage_state/domain/auth/entities/user.dart';

abstract class AuthRepository {
  Future<User> login(String email, String password);
}
