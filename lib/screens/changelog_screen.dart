import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../widgets/footer.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({Key? key}) : super(key: key);

  @override
  _ChangelogScreenState createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  String _changelogContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChangelog();
  }

  Future<void> _loadChangelog() async {
    try {
      final String content = await rootBundle.loadString('CHANGELOG.md');
      setState(() {
        _changelogContent = content;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _changelogContent = 'Erro ao carregar o changelog.\nDetalhes: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Versões'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Text(
                _changelogContent,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
      bottomNavigationBar: const AppFooter(),
    );
  }
}
