import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/app_theme.dart';
import '../core/app_language.dart';
import '../core/constants.dart';
import '../data/local_storage.dart';
import '../data/api.dart';
import 'changelog_screen.dart';
import '../l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _tokenController = TextEditingController();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _obscureToken = true;
  bool _obscureCurrentPass = true;
  bool _obscureNewPass = true;
  bool _obscureConfirmPass = true;

  String _themeMode = AppThemeController.systemValue;
  String _language = AppLanguageController.systemValue;
  List<String> _dnsTypes = [];
  final List<String> _availableTypes = [
    'A',
    'AAAA',
    'CNAME',
    'MX',
    'NS',
    'TXT',
    'SRV'
  ];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final token = await LocalStorage.getToken();
    final types = await LocalStorage.getDnsTypes();
    final themeMode = await LocalStorage.getThemeMode();
    final language = await LocalStorage.getLanguage();
    if (token != null) {
      _tokenController.text = token;
    }
    setState(() {
      _dnsTypes = types;
      _themeMode = themeMode;
      _language = language;
    });
  }

  Future<void> _saveLanguage(String value) async {
    await LocalStorage.saveLanguage(value);
    AppLanguageController.locale.value =
        AppLanguageController.fromStorageValue(value);
    if (mounted) setState(() => _language = value);
  }

  Future<void> _saveThemeMode(String value) async {
    await LocalStorage.saveThemeMode(value);
    AppThemeController.themeMode.value =
        AppThemeController.fromStorageValue(value);
    if (mounted) {
      setState(() {
        _themeMode = value;
      });
    }
  }

  Future<void> _saveToken() async {
    await LocalStorage.saveToken(_tokenController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.text('tokenSaved')), backgroundColor: AppColors.success),
      );
    }
  }

  Future<void> _testToken() async {
    await LocalStorage.saveToken(_tokenController.text.trim());
    try {
      await ApiService.listZones();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.text('connectionSuccess')),
              backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.text('connectionFailed')),
              backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    if (!await LocalStorage.verifyAppPassword(_currentPassController.text)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.text('passwordIncorrect')),
            backgroundColor: AppColors.error,
          ),
        );
      }
      return;
    }

    if (_newPassController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.text('newPasswordEmpty')),
              backgroundColor: AppColors.error),
        );
      }
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(context.l10n.text('passwordMismatchExclaim')),
              backgroundColor: AppColors.error),
        );
      }
      return;
    }

    await LocalStorage.saveAppPassword(_newPassController.text.trim());
    _currentPassController.clear();
    _newPassController.clear();
    _confirmPassController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(context.l10n.text('passwordUpdated')),
            backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.escape): () {
          Navigator.pop(context);
        },
      },
      child: FocusScope(
        autofocus: true,
        child: Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.text('settings')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.text('apiToken'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              obscureText: _obscureToken,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      _obscureToken ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureToken = !_obscureToken;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _testToken,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[700]),
                    child: Text(context.l10n.text('test'),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveToken,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary),
                    child: Text(context.l10n.text('save'),
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(context.l10n.text('appTheme'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
                context.l10n.text('themeDescription'),
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _themeMode,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.palette),
              ),
              items: [
                DropdownMenuItem(
                  value: AppThemeController.systemValue,
                  child: Text(context.l10n.text('systemTheme')),
                ),
                DropdownMenuItem(
                  value: AppThemeController.lightValue,
                  child: Text(context.l10n.text('light')),
                ),
                DropdownMenuItem(
                  value: AppThemeController.darkValue,
                  child: Text(context.l10n.text('dark')),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  _saveThemeMode(value);
                }
              },
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(context.l10n.text('language'),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(context.l10n.text('languageDescription'),
                style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _language,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              items: [
                DropdownMenuItem(value: AppLanguageController.systemValue, child: Text(context.l10n.text('systemLanguage'))),
                const DropdownMenuItem(value: 'pt', child: Text('Português')),
                const DropdownMenuItem(value: 'en', child: Text('English')),
                const DropdownMenuItem(value: 'fr', child: Text('Français')),
                const DropdownMenuItem(value: 'es', child: Text('Español')),
                const DropdownMenuItem(value: 'zh', child: Text('简体中文')),
                const DropdownMenuItem(value: 'ja', child: Text('日本語')),
              ],
              onChanged: (value) { if (value != null) _saveLanguage(value); },
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(context.l10n.text('dnsTypes'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(context.l10n.text('dnsTypesDescription'),
                style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _availableTypes.map((type) {
                return FilterChip(
                  label: Text(type),
                  selected: _dnsTypes.contains(type),
                  selectedColor: AppColors.primary.withOpacity(0.3),
                  checkmarkColor: AppColors.primary,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _dnsTypes.add(type);
                      } else {
                        if (_dnsTypes.length > 1) {
                          _dnsTypes.remove(type);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.text('atLeastOneType'))),
                          );
                        }
                      }
                    });
                    LocalStorage.saveDnsTypes(_dnsTypes);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(context.l10n.text('changePassword'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _currentPassController,
              obscureText: _obscureCurrentPass,
              decoration: InputDecoration(
                labelText: context.l10n.text('currentPassword'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPass
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureCurrentPass = !_obscureCurrentPass;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPassController,
              obscureText: _obscureNewPass,
              decoration: InputDecoration(
                labelText: context.l10n.text('newPassword'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPass
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureNewPass = !_obscureNewPass;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPassController,
              obscureText: _obscureConfirmPass,
              decoration: InputDecoration(
                labelText: context.l10n.text('confirmNewPassword'),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPass
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _obscureConfirmPass = !_obscureConfirmPass;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _changePassword,
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary),
                child: Text(context.l10n.text('updatePassword'),
                    style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            Text(context.l10n.text('about'),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ChangelogScreen()),
                  );
                },
                icon: const Icon(Icons.history, color: AppColors.primary),
                label: Text(context.l10n.text('viewChangelog'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
        ),
      ),
    );
  }
}
