import 'package:flutter/material.dart';
import 'package:manage_state/presentation/auth/controllers/auth_controller.dart';
import 'package:manage_state/presentation/auth/intents/auth_intent.dart';
import 'package:manage_state/presentation/auth/states/auth_state.dart';

class LoginView extends StatelessWidget {
  final AuthController controller;

  const LoginView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Welcome Back',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 48),
          TextField(
            controller: controller.emailController,
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'test@test.com',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller.passwordController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password',
              hintText: '123456',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
          ),
          const SizedBox(height: 24),
          ValueListenableBuilder<AuthState>(
            valueListenable: controller,
            builder: (context, state, _) {
              if (state.errorMessage.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    state.errorMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          ValueListenableBuilder<AuthState>(
            valueListenable: controller,
            builder: (context, state, _) {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: state.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        controller.onIntent(
                          LoginIntent(
                            email: controller.emailController.text.trim(),
                            password: controller.passwordController.text.trim(),
                          ),
                        );
                      },
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('Login', style: TextStyle(fontSize: 16)),
              );
            },
          ),
          const SizedBox(height: 16),
          ValueListenableBuilder<AuthState>(
            valueListenable: controller,
            builder: (context, state, _) {
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFF1877F2)),
                  foregroundColor: const Color(0xFF1877F2),
                ),
                icon: const Icon(Icons.facebook),
                label: const Text('Continue with Facebook', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: state.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        controller.onIntent(const LoginWithFacebookIntent());
                      },
              );
            },
          ),
          const SizedBox(height: 12),
          ValueListenableBuilder<AuthState>(
            valueListenable: controller,
            builder: (context, state, _) {
              return OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Color(0xFFDB4437)),
                  foregroundColor: const Color(0xFFDB4437),
                ),
                icon: const Icon(Icons.g_mobiledata, size: 28),
                label: const Text('Continue with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                onPressed: state.isLoading
                    ? null
                    : () {
                        FocusScope.of(context).unfocus();
                        controller.onIntent(const LoginWithGoogleIntent());
                      },
              );
            },
          ),
        ],
      ),
    );
  }
}
