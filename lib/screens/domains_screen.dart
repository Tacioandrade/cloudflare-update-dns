import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../data/api.dart';
import '../data/local_storage.dart';
import 'dns_editor_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import '../widgets/footer.dart';
import '../l10n/app_localizations.dart';

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
  int _loadId = 0;

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
    final loadId = ++_loadId;
    setState(() {
      _isLoading = true;
      _error = null;
      _zones = [];
    });

    final token = await LocalStorage.getToken();
    if (!mounted || loadId != _loadId) return;

    if (token == null || token.isEmpty) {
      setState(() {
        _isLoading = false;
        _error = context.l10n.text('tokenNotConfigured');
      });
      return;
    }

    try {
      await for (final zone in ApiService.streamZones()) {
        if (!mounted || loadId != _loadId) return;
        setState(() {
          _zones.add(zone);
        });
      }
      if (!mounted || loadId != _loadId) return;
      setState(() => _isLoading = false);
    } catch (e) {
      if (!mounted || loadId != _loadId) return;
      setState(() {
        _error = context.l10n.text('domainsLoadError', values: {'error': '$e'});
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
                decoration: InputDecoration(
                  hintText: context.l10n.text('searchDomain'),
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : Text(context.l10n.text('domains')),
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
    if (_isLoading && _zones.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null && _zones.isEmpty) {
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
                  child: Text(context.l10n.text('configureToken')),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        if (_isLoading) const LinearProgressIndicator(),
        if (_error != null)
          Container(
            width: double.infinity,
            color: AppColors.error.withOpacity(0.1),
            padding: const EdgeInsets.all(12),
            child: Text(
              context.l10n.text('partialDomainsError', values: {'error': _error!}),
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        Expanded(child: _buildZonesList()),
      ],
    );
  }

  Widget _buildZonesList() {
    if (_zones.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadZones,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 100),
              child: Center(child: Text(context.l10n.text('noDomains'))),
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
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Center(
                      child: Text(context.l10n.text('noDomainsSearch'))),
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
