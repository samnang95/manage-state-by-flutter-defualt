import 'package:flutter/material.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/auth/usecases/login_usecase.dart';
import 'package:manage_state/data/auth/repositories/auth_repository_impl.dart';
import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';
import 'package:manage_state/presentation/auth/intents/auth_intent.dart';
import 'package:manage_state/presentation/auth/states/auth_state.dart';
import 'package:manage_state/core/services/native_auth_service.dart';
import 'package:manage_state/domain/auth/entities/user.dart';

import 'package:manage_state/core/di/dependency_injector.dart';

class AuthController extends MviController<AuthIntent, AuthState> {
  final LoginUseCase _loginUseCase;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final NativeAuthService _nativeAuthService = NativeAuthService();

  AuthController({LoginUseCase? loginUseCase})
      : _loginUseCase = loginUseCase ??
            LoginUseCase(
              AuthRepositoryImpl(
                AuthRemoteDataSourceImpl(DependencyInjector.instance.apiClient),
              ),
            ),
        super(const AuthState());

  @override
  void onIntent(AuthIntent intent) {
    switch (intent) {
      case LoginIntent(:final email, :final password):
        _handleLogin(email, password);
      case LoginWithFacebookIntent():
        _handleFacebookLogin();
      case ResetAuthErrorIntent():
        emit(value.copyWith(errorMessage: ''));
    }
  }

  Future<void> _handleLogin(String email, String password) async {
    debugPrint('Attempting login with email: "$email" and password: "$password"');
    emit(value.copyWith(isLoading: true, errorMessage: '', isSuccess: false));

    try {
      final user = await _loginUseCase.call(email, password);
      emit(value.copyWith(
        isLoading: false,
        user: user,
        isSuccess: true,
      ));
    } catch (e) {
      debugPrint('Error logging in: $e');
      emit(value.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email or password',
        isSuccess: false,
      ));
    }
  }

  Future<void> _handleFacebookLogin() async {
    emit(value.copyWith(isLoading: true, errorMessage: '', isSuccess: false));
    try {
      final token = await _nativeAuthService.loginWithFacebook();
      if (token != null) {
        // Since we don't have a real backend to verify the FB token right now,
        // we'll mock a successful user login with the token.
        final user = User(id: 'fb_user_id', email: 'facebook_user@example.com', name: 'Facebook User');
        emit(value.copyWith(
          isLoading: false,
          user: user,
          isSuccess: true,
        ));
      } else {
        emit(value.copyWith(
          isLoading: false,
          errorMessage: 'Facebook login cancelled.',
          isSuccess: false,
        ));
      }
    } catch (e) {
      debugPrint('Error logging in with Facebook: $e');
      emit(value.copyWith(
        isLoading: false,
        errorMessage: 'Facebook login failed: $e',
        isSuccess: false,
      ));
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
