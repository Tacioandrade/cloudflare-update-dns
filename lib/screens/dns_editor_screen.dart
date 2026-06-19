import 'package:flutter/material.dart';
import '../core/constants.dart';
import '../data/api.dart';
import '../data/local_storage.dart';
import '../widgets/footer.dart';

class DnsEditorScreen extends StatefulWidget {
  final String zoneId;
  final String zoneName;

  const DnsEditorScreen({Key? key, required this.zoneId, required this.zoneName}) : super(key: key);

  @override
  _DnsEditorScreenState createState() => _DnsEditorScreenState();
}

class _DnsEditorScreenState extends State<DnsEditorScreen> {
  List<dynamic> _records = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearching = false;
  List<String> _allowedTypes = ['A', 'CNAME'];

  @override
  void initState() {
    super.initState();
    _loadTypesAndRecords();
  }

  Future<void> _loadTypesAndRecords() async {
    _allowedTypes = await LocalStorage.getDnsTypes();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    setState(() => _isLoading = true);
    try {
      final records = await ApiService.listDnsRecords(widget.zoneId);
      setState(() {
        _records = records;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
      }
    }
  }

  Future<void> _toggleProxy(dynamic record, bool value) async {
    try {
      await ApiService.updateDnsRecord(widget.zoneId, record['id'], {
        'name': record['name'],
        'content': record['content'],
        'type': record['type'],
        'proxied': value,
      });
      _loadRecords();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao atualizar: $e')));
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    try {
      await ApiService.deleteDnsRecord(widget.zoneId, recordId);
      _loadRecords();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao deletar: $e')));
    }
  }

  void _showRecordDialog([dynamic record]) {
    String initialName = '';
    if (record != null) {
      String fullName = record['name'];
      if (fullName == widget.zoneName) {
        initialName = '@';
      } else if (fullName.endsWith('.${widget.zoneName}')) {
        initialName = fullName.substring(0, fullName.length - widget.zoneName.length - 1);
      } else {
        initialName = fullName;
      }
    }

    final typeController = TextEditingController(text: record != null ? record['type'] : 'A');
    final nameController = TextEditingController(text: initialName);
    final contentController = TextEditingController(text: record != null ? record['content'] : '');
    bool isProxied = record != null ? record['proxied'] : true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(record == null ? 'Novo Registro' : 'Editar Registro'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      value: typeController.text,
                      items: (_allowedTypes.contains(typeController.text) 
                              ? _allowedTypes 
                              : [..._allowedTypes, typeController.text]).map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (val) => setStateDialog(() => typeController.text = val!),
                      decoration: const InputDecoration(labelText: 'Tipo'),
                    ),
                    TextField(
                      controller: nameController, 
                      decoration: InputDecoration(
                        labelText: 'Nome (Subdomínio)',
                        hintText: '@ ou www',
                        suffixText: '.${widget.zoneName}',
                      ),
                    ),
                    TextField(controller: contentController, decoration: const InputDecoration(labelText: 'Conteúdo (IP ou destino)')),
                    SwitchListTile(
                      title: const Text('Proxied'),
                      value: isProxied,
                      onChanged: (val) => setStateDialog(() => isProxied = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    String finalName = nameController.text.trim();
                    if (finalName == '@' || finalName.isEmpty) {
                      finalName = widget.zoneName;
                    } else if (!finalName.endsWith('.${widget.zoneName}')) {
                      finalName = '$finalName.${widget.zoneName}';
                    }

                    final data = {
                      'type': typeController.text,
                      'name': finalName,
                      'content': contentController.text,
                      'proxied': isProxied,
                    };
                    try {
                      if (record == null) {
                        await ApiService.createDnsRecord(widget.zoneId, data);
                      } else {
                        await ApiService.updateDnsRecord(widget.zoneId, record['id'], data);
                      }
                      _loadRecords();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro: $e')));
                    }
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print('>>> BUILDING DNS EDITOR SCREEN: _isSearching=$_isSearching');
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar registro...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val;
                  });
                },
              )
            : Text(widget.zoneName),
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
          const SizedBox(width: 16),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadRecords,
              child: Builder(
                builder: (context) {
                  final filteredRecords = _records.where((record) {
                    final search = _searchQuery.toLowerCase();
                    return record['name'].toString().toLowerCase().contains(search) ||
                           record['content'].toString().toLowerCase().contains(search) ||
                           record['type'].toString().toLowerCase().contains(search);
                  }).toList();

                  if (filteredRecords.isEmpty) {
                    return ListView(
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(top: 100),
                          child: Center(child: Text('Nenhum registro encontrado.')),
                        )
                      ],
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredRecords.length,
                    itemBuilder: (context, index) {
                      final record = filteredRecords[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      title: Text('${record['type']} • ${record['name']}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(record['content']),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: record['proxied'],
                            onChanged: record['proxiable'] ? (val) => _toggleProxy(record, val) : null,
                            activeColor: AppColors.primary,
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _showRecordDialog(record),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: AppColors.error),
                            onPressed: () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Confirmar exclusão'),
                                  content: Text('Deletar o registro ${record['name']}?'),
                                  actions: [
                                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                                      onPressed: () => Navigator.pop(context, true),
                                      child: const Text('Deletar'),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm == true) _deleteRecord(record['id']);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showRecordDialog(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}
