import 'package:flutter/material.dart';
import 'core/constants.dart';
import 'data/local_storage.dart';
import 'screens/login_screen.dart';
import 'screens/domains_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isAuth = await LocalStorage.isAuthenticated();
  runApp(CloudflareDnsApp(isAuth: isAuth));
}

class CloudflareDnsApp extends StatelessWidget {
  final bool isAuth;
  const CloudflareDnsApp({Key? key, required this.isAuth}) : super(key: key);

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
      home: isAuth ? const DomainsScreen() : const LoginScreen(),
    );
  }
}
