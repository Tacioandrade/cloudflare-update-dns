import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../data/api.dart';
import '../data/local_storage.dart';
import 'dns_editor_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import '../widgets/footer.dart';

class DomainsScreen extends StatefulWidget {
  const DomainsScreen({super.key});

  @override
  State<DomainsScreen> createState() => _DomainsScreenState();
}

class _DomainsScreenState extends State<DomainsScreen> {
  List<dynamic> _zones = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  bool _isSearching = false;
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadZones();
  }

  Future<void> _loadZones() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    final token = await LocalStorage.getToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = 'Token não configurado. Vá em Configurações.';
      });
      return;
    }

    try {
      final zones = await ApiService.listZones();
      setState(() {
        _zones = zones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Erro ao carregar domínios: $e';
        _isLoading = false;
      });
    }
  }

  void _logout() async {
    await LocalStorage.logout();
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.keyF, control: true): () {
          if (!_isSearching) {
            setState(() {
              _isSearching = true;
            });
          }
          Future.delayed(const Duration(milliseconds: 50), () {
            _searchFocusNode.requestFocus();
          });
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
            });
          }
        },
      },
      child: FocusScope(
        autofocus: true,
        child: Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                focusNode: _searchFocusNode,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar domínio...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : const Text('Domínios'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
              _loadZones();
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _loadZones,
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: const AppFooter(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 16),
              if (_error!.contains('Token'))
                ElevatedButton(
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SettingsScreen()),
                    );
                    _loadZones();
                  },
                  child: const Text('Configurar Token'),
                ),
            ],
          ),
        ),
      );
    }

    if (_zones.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadZones,
        child: ListView(
          children: const [
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Center(child: Text('Nenhum domínio encontrado.')),
            )
          ],
        ),
      );
    }

    final filteredZones = _zones.where((zone) {
      return zone['name']
          .toString()
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
    }).toList();

    return RefreshIndicator(
      onRefresh: _loadZones,
      child: filteredZones.isEmpty
          ? ListView(
              children: const [
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Center(
                      child: Text('Nenhum domínio corresponde à pesquisa.')),
                )
              ],
            )
          : ListView.builder(
              itemCount: filteredZones.length,
              itemBuilder: (context, index) {
                final zone = filteredZones[index];
                final isActive = zone['status'] == 'active';

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(zone['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(zone['status']),
                    trailing: Icon(
                      isActive ? Icons.check_circle : Icons.pending,
                      color: isActive ? AppColors.success : Colors.grey,
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DnsEditorScreen(
                            zoneId: zone['id'],
                            zoneName: zone['name'],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
