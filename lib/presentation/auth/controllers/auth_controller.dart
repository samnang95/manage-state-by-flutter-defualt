import 'package:flutter/material.dart';
import 'package:manage_state/domain/auth/entities/user.dart';
import 'package:manage_state/domain/auth/usecases/login_usecase.dart';
import 'package:manage_state/data/auth/repositories/auth_repository_impl.dart';
import 'package:manage_state/data/auth/datasources/auth_remote_datasource.dart';

class AuthController extends ChangeNotifier {
  // Simple dependency injection for example
  final LoginUseCase _loginUseCase = LoginUseCase(
    AuthRepositoryImpl(
      AuthRemoteDataSourceImpl(),
    ),
  );

  bool _isLoading = false;
  String _errorMessage = '';
  User? _user;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _user = await _loginUseCase.call(email, password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Invalid email or password';
      notifyListeners();
      return false;
    }
  }
}

