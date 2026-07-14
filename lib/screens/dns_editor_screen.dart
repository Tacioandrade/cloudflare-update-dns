import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/constants.dart';
import '../data/api.dart';
import '../data/dns_record_validator.dart';
import '../data/local_storage.dart';
import '../widgets/footer.dart';
import '../l10n/app_localizations.dart';

class DnsEditorScreen extends StatefulWidget {
  final String zoneId;
  final String zoneName;

  const DnsEditorScreen({
    super.key,
    required this.zoneId,
    required this.zoneName,
  });

  @override
  State<DnsEditorScreen> createState() => _DnsEditorScreenState();
}

class _DnsEditorScreenState extends State<DnsEditorScreen> {
  List<dynamic> _records = [];
  bool _isLoading = true;
  String _searchQuery = '';
  bool _isSearching = false;
  bool _isPurgingCache = false;
  List<String> _allowedTypes = ['A', 'CNAME'];
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.text('error', values: {'error': '$e'}))));
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
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.text('updateError', values: {'error': '$e'}))));
      }
    }
  }

  Future<void> _deleteRecord(String recordId) async {
    try {
      await ApiService.deleteDnsRecord(widget.zoneId, recordId);
      _loadRecords();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.text('deleteError', values: {'error': '$e'}))));
      }
    }
  }

  Future<void> _confirmPurgeCache() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.text('purgeConfirmTitle')),
        content: Text(context.l10n.text('purgeConfirmMessage')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(context.l10n.text('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              context.l10n.text('purge'),
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    setState(() => _isPurgingCache = true);
    try {
      await ApiService.purgeCache(widget.zoneId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.text('cachePurged')),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(context.l10n.text('purgeError', values: {'error': '$e'})),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPurgingCache = false);
      }
    }
  }

  void _showRecordDialog([dynamic record]) {
    String initialName = '';
    if (record != null) {
      String fullName = record['name'];
      if (fullName == widget.zoneName) {
        initialName = '@';
      } else if (fullName.endsWith('.${widget.zoneName}')) {
        initialName =
            fullName.substring(0, fullName.length - widget.zoneName.length - 1);
      } else {
        initialName = fullName;
      }
    }

    final typeController =
        TextEditingController(text: record != null ? record['type'] : 'A');
    final nameController = TextEditingController(text: initialName);
    final contentController =
        TextEditingController(text: record != null ? record['content'] : '');
    bool isProxied = record != null
        ? record['proxied'] == true
        : DnsRecordValidator.isProxiableType(typeController.text);

    Future<void> onSave() async {
      final selectedType = typeController.text.trim().toUpperCase();
      final content = contentController.text.trim();
      final validationError = DnsRecordValidator.validateContent(
        type: selectedType,
        content: content,
      );

      if (validationError != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(validationError),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      String finalName = nameController.text.trim();
      if (finalName == '@' || finalName.isEmpty) {
        finalName = widget.zoneName;
      } else if (!finalName.endsWith('.${widget.zoneName}')) {
        finalName = '$finalName.${widget.zoneName}';
      }

      final data = <String, dynamic>{
        'type': selectedType,
        'name': finalName,
        'content': content,
      };
      if (DnsRecordValidator.isProxiableType(selectedType)) {
        data['proxied'] = isProxied;
      }
      try {
        if (record == null) {
          await ApiService.createDnsRecord(widget.zoneId, data);
        } else {
          await ApiService.updateDnsRecord(widget.zoneId, record['id'], data);
        }
        if (mounted) {
          Navigator.pop(context);
        }
        _loadRecords();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(context.l10n.text('error', values: {'error': '$e'}))));
      }
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CallbackShortcuts(
              bindings: {
                const SingleActivator(LogicalKeyboardKey.escape): () {
                  Navigator.pop(context);
                },
              },
              child: FocusScope(
                autofocus: true,
                child: AlertDialog(
                  title: Text(
                      record == null ? context.l10n.text('newRecord') : context.l10n.text('editRecord')),
                  content: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DropdownButtonFormField<String>(
                          value: typeController.text,
                          items: (_allowedTypes.contains(typeController.text)
                                  ? _allowedTypes
                                  : [..._allowedTypes, typeController.text])
                              .map((type) {
                            return DropdownMenuItem(
                                value: type, child: Text(type));
                          }).toList(),
                          onChanged: (val) {
                            setStateDialog(() {
                              typeController.text = val!;
                              if (!DnsRecordValidator.isProxiableType(val)) {
                                isProxied = false;
                              } else if (record == null) {
                                isProxied = true;
                              }
                            });
                          },
                          decoration: InputDecoration(labelText: context.l10n.text('type')),
                        ),
                        TextField(
                          controller: nameController,
                          onSubmitted: (_) => onSave(),
                          decoration: InputDecoration(
                            labelText: context.l10n.text('nameSubdomain'),
                            hintText: '@ ou www',
                            suffixText: '.${widget.zoneName}',
                          ),
                        ),
                        TextField(
                            controller: contentController,
                            onSubmitted: (_) => onSave(),
                            decoration: InputDecoration(
                                labelText: context.l10n.text('content'))),
                        if (DnsRecordValidator.isProxiableType(
                            typeController.text))
                          SwitchListTile(
                            title: Text(context.l10n.text('proxied')),
                            value: isProxied,
                            onChanged: (val) =>
                                setStateDialog(() => isProxied = val),
                          ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(context.l10n.text('cancel'))),
                    ElevatedButton(
                      onPressed: onSave,
                      child: Text(context.l10n.text('recordSave')),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
        const SingleActivator(LogicalKeyboardKey.keyN, control: true): () {
          _showRecordDialog();
        },
        const SingleActivator(LogicalKeyboardKey.escape): () {
          if (_isSearching) {
            setState(() {
              _isSearching = false;
              _searchQuery = '';
            });
          } else {
            Navigator.pop(context);
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
                      hintText: context.l10n.text('searchRecord'),
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
                tooltip: context.l10n.text('purgeCache'),
                icon: _isPurgingCache
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.cleaning_services),
                onPressed: _isPurgingCache ? null : _confirmPurgeCache,
              ),
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
                        return record['name']
                                .toString()
                                .toLowerCase()
                                .contains(search) ||
                            record['content']
                                .toString()
                                .toLowerCase()
                                .contains(search) ||
                            record['type']
                                .toString()
                                .toLowerCase()
                                .contains(search);
                      }).toList();

                      if (filteredRecords.isEmpty) {
                        return ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Center(
                                  child: Text(context.l10n.text('noRecords'))),
                            )
                          ],
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredRecords.length,
                        itemBuilder: (context, index) {
                          final record = filteredRecords[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: ListTile(
                              title: Text(
                                  '${record['type']} • ${record['name']}',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              subtitle: Text(record['content']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Switch(
                                    value: record['proxied'],
                                    onChanged: record['proxiable']
                                        ? (val) => _toggleProxy(record, val)
                                        : null,
                                    activeColor: AppColors.primary,
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showRecordDialog(record),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete,
                                        color: AppColors.error),
                                    onPressed: () async {
                                      final confirm = await showDialog<bool>(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: Text(context.l10n.text('deleteConfirmTitle')),
                                          content: Text(
                                              context.l10n.text('deleteRecord', values: {'name': '${record['name']}'})),
                                          actions: [
                                            TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, false),
                                                child: Text(context.l10n.text('cancel'))),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      AppColors.error),
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text(context.l10n.text('delete')),
                                            ),
                                          ],
                                        ),
                                      );
                                      if (confirm == true) {
                                        _deleteRecord(record['id']);
                                      }
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
        ),
      ),
    );
  }
}
