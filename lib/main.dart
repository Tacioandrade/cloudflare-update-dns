import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'data/local_storage.dart';
import 'screens/login_screen.dart';
import 'screens/domains_screen.dart';
import 'screens/password_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final hasPassword = await LocalStorage.hasAppPassword();
  final isAuth = hasPassword && await LocalStorage.isAuthenticated();
  runApp(CloudflareDnsApp(hasPassword: hasPassword, isAuth: isAuth));
}

class CloudflareDnsApp extends StatelessWidget {
  final bool hasPassword;
  final bool isAuth;

  const CloudflareDnsApp({
    super.key,
    required this.hasPassword,
    required this.isAuth,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cloudflarer DNS Manager',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        useMaterial3: true,
      ),
      home: !hasPassword
          ? const PasswordSetupScreen()
          : isAuth
              ? const DomainsScreen()
              : const LoginScreen(),
    );
  }
}
