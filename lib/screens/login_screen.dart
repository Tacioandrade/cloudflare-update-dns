import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:local_auth/local_auth.dart';
import '../core/constants.dart';
import '../data/local_storage.dart';
import '../widgets/footer.dart';
import 'domains_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _passController = TextEditingController();
  bool _obscurePassword = true;

  final LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    if (kIsWeb) return;
    try {
      final canCheck =
          await auth.canCheckBiometrics || await auth.isDeviceSupported();
      if (mounted) {
        setState(() {
          _canCheckBiometrics = canCheck;
        });
      }
      if (canCheck) {
        _authenticate();
      }
    } catch (e) {
      print('Erro ao checar biometria: $e');
    }
  }

  Future<void> _authenticate() async {
    try {
      final authenticated = await auth.authenticate(
        localizedReason: 'Autentique-se para gerenciar seus domínios DNS',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (authenticated) {
        await LocalStorage.login();
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DomainsScreen()),
          );
        }
      }
    } catch (e) {
      print('Erro na autenticacao: $e');
    }
  }

  void _login() async {
    final expectedPassword = await LocalStorage.getAppPassword();
    if (expectedPassword != null && _passController.text == expectedPassword) {
      await LocalStorage.login();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DomainsScreen()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Credenciais inválidas!'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const AppFooter(),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/icon.png', width: 100, height: 100),
              const SizedBox(height: 24),
              const Text(
                'Cloudflare DNS',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              if (_canCheckBiometrics) ...[
                const Icon(Icons.fingerprint, size: 80, color: Colors.grey),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _authenticate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'ENTRAR COM BIOMETRIA',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => setState(() => _canCheckBiometrics = false),
                  child: const Text(
                    'Usar senha ao invés da biometria',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ] else ...[
                TextField(
                  controller: _passController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('ENTRAR', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
