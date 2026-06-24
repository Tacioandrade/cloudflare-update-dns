import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/app_theme.dart';
import 'data/local_storage.dart';
import 'screens/login_screen.dart';
import 'screens/domains_screen.dart';
import 'screens/password_setup_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await LocalStorage.getThemeMode();
  AppThemeController.themeMode.value =
      AppThemeController.fromStorageValue(savedThemeMode);
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
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AppThemeController.themeMode,
      builder: (context, themeMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Cloudflarer DNS Manager',
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('pt', 'BR'),
            Locale('pt'),
            Locale('en'),
            Locale('es'),
          ],
          theme: AppThemeController.lightTheme,
          darkTheme: AppThemeController.darkTheme,
          themeMode: themeMode,
          home: !hasPassword
              ? const PasswordSetupScreen()
              : isAuth
                  ? const DomainsScreen()
                  : const LoginScreen(),
        );
      },
    );
  }
}
