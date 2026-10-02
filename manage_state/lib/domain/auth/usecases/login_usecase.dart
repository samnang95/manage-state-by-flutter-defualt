import 'package:manage_state/domain/auth/entities/user.dart';
import 'package:manage_state/domain/auth/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<User> call(String email, String password) {
    return repository.login(email, password);
  }
}
