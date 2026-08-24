import 'package:manage_state/domain/auth/entities/user.dart';

class AuthState {
  final bool isLoading;
  final String errorMessage;
  final User? user;
  final bool isSuccess;

  const AuthState({
    this.isLoading = false,
    this.errorMessage = '',
    this.user,
    this.isSuccess = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? errorMessage,
    User? user,
    bool? isSuccess,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      user: user ?? this.user,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
