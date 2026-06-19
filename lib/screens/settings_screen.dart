import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../data/local_storage.dart';
import '../data/api.dart';
import '../widgets/footer.dart';
import 'changelog_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
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
  
  List<String> _dnsTypes = [];
  final List<String> _availableTypes = ['A', 'AAAA', 'CNAME', 'MX', 'NS', 'TXT', 'SRV'];

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final token = await LocalStorage.getToken();
    final types = await LocalStorage.getDnsTypes();
    if (token != null) {
      _tokenController.text = token;
    }
    setState(() {
      _dnsTypes = types;
    });
  }

  Future<void> _saveToken() async {
    await LocalStorage.saveToken(_tokenController.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Token salvo!'), backgroundColor: AppColors.success),
      );
    }
  }

  Future<void> _testToken() async {
    await LocalStorage.saveToken(_tokenController.text.trim());
    try {
      await ApiService.listZones();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conexão bem-sucedida!'), backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha na conexão. Token inválido.'), backgroundColor: AppColors.error),
        );
      }
    }
  }

  Future<void> _changePassword() async {
    final currentPass = await LocalStorage.getAppPassword();
    if (_currentPassController.text != currentPass) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Senha atual incorreta!'), backgroundColor: AppColors.error),
        );
      }
      return;
    }

    if (_newPassController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('A nova senha não pode ser vazia!'), backgroundColor: AppColors.error),
        );
      }
      return;
    }

    if (_newPassController.text != _confirmPassController.text) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('As senhas não coincidem!'), backgroundColor: AppColors.error),
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
        const SnackBar(content: Text('Senha atualizada com sucesso!'), backgroundColor: AppColors.success),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Cloudflare API Token', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _tokenController,
              obscureText: _obscureToken,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureToken ? Icons.visibility : Icons.visibility_off),
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
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
                    child: const Text('TESTAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveToken,
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                    child: const Text('SALVAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Tipos de Registro DNS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Selecione quais tipos de DNS o sistema irá carregar e exibir:', style: TextStyle(color: Colors.grey)),
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
                            const SnackBar(content: Text('É necessário pelo menos um tipo de registro.')),
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
            const Text('Alterar Senha do App', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _currentPassController,
              obscureText: _obscureCurrentPass,
              decoration: InputDecoration(
                labelText: 'Senha Atual',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureCurrentPass ? Icons.visibility : Icons.visibility_off),
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
                labelText: 'Nova Senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureNewPass ? Icons.visibility : Icons.visibility_off),
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
                labelText: 'Confirmar Nova Senha',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(_obscureConfirmPass ? Icons.visibility : Icons.visibility_off),
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
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('ATUALIZAR SENHA', style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            const SizedBox(height: 16),
            const Text('Sobre o Aplicativo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                label: const Text('VER HISTÓRICO DE VERSÕES (CHANGELOG)', style: TextStyle(color: AppColors.textPrimary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}
