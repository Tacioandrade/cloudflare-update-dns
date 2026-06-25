import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/footer.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
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

  Future<void> _openExternalLink(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível abrir o link.')),
      );
    }
  }

  Widget _buildChangelogContent(BuildContext context) {
    final lines = _changelogContent.split('\n');
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontSize: 16, height: 1.5);
    final linkStyle = textStyle?.copyWith(
      color: Theme.of(context).colorScheme.primary,
      decoration: TextDecoration.underline,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: lines.map((line) {
        final linkMatch =
            RegExp(r'\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)').firstMatch(line);

        if (linkMatch == null) {
          return Text(line, style: textStyle);
        }

        final prefix = line.substring(0, linkMatch.start);
        final label = linkMatch.group(1)!;
        final url = linkMatch.group(2)!;
        final suffix = line.substring(linkMatch.end);

        return Wrap(
          children: [
            if (prefix.isNotEmpty) Text(prefix, style: textStyle),
            InkWell(
              onTap: () => _openExternalLink(url),
              child: Text(label, style: linkStyle),
            ),
            if (suffix.isNotEmpty) Text(suffix, style: textStyle),
          ],
        );
      }).toList(),
    );
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
        title: const Text('Histórico de Versões'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: _buildChangelogContent(context),
            ),
      bottomNavigationBar: const AppFooter(),
        ),
      ),
    );
  }
}
