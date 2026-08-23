import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:manage_state/core/utils/app_colors.dart';
import 'package:manage_state/presentation/navi/pages/navi_page.dart';
import 'package:manage_state/core/di/dependency_injector.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyInjector.instance.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: NaviPage(),
      ),
    );
  }
}
