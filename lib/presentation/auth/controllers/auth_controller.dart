import 'package:flutter/foundation.dart';
import 'package:manage_state/core/mvi/mvi_controller.dart';
import 'package:manage_state/domain/auth/usecases/login_usecase.dart';
import 'package:manage_state/data/auth/repositories/auth_repository_impl.dart';
import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';
import 'package:manage_state/presentation/auth/intents/auth_intent.dart';
import 'package:manage_state/presentation/auth/states/auth_state.dart';

import 'package:manage_state/core/di/dependency_injector.dart';

class AuthController extends MviController<AuthIntent, AuthState> {
  final LoginUseCase _loginUseCase;

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
      case ResetAuthErrorIntent():
        emit(value.copyWith(errorMessage: ''));
    }
  }

  Future<void> _handleLogin(String email, String password) async {
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
}
