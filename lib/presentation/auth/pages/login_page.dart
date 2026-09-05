import 'package:flutter/material.dart';
import 'package:manage_state/core/di/dependency_injector.dart';
import 'package:manage_state/presentation/auth/states/auth_state.dart';
import 'package:manage_state/presentation/auth/widgets/login_view.dart';
import 'package:manage_state/presentation/navi/pages/navi_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = DependencyInjector.instance.getAuthController();

    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<AuthState>(
          valueListenable: controller,
          builder: (context, state, child) {
            if (state.isSuccess) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (context.mounted) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => NaviPage(),
                    ),
                  );
                }
              });
            }
            return LoginView(controller: controller);
          },
        ),
      ),
    );
  }
}
