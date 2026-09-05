sealed class AuthIntent {
  const AuthIntent();
}

class LoginIntent extends AuthIntent {
  final String email;
  final String password;
  const LoginIntent({required this.email, required this.password});
}

class ResetAuthErrorIntent extends AuthIntent {
  const ResetAuthErrorIntent();
}

class LoginWithFacebookIntent extends AuthIntent {
  const LoginWithFacebookIntent();
}

class LoginWithGoogleIntent extends AuthIntent {
  const LoginWithGoogleIntent();
}
