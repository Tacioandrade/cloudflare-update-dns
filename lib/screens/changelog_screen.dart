import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/footer.dart';
import '../l10n/app_localizations.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  static final Map<String, String> _changelogCache = {};
  String _changelogContent = '';
  bool _isLoading = true;
  String? _loadedLanguageCode;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final languageCode = Localizations.localeOf(context).languageCode;
    if (_loadedLanguageCode != languageCode) {
      _loadChangelog();
    }
  }

  Future<void> _loadChangelog() async {
    final languageCode = Localizations.localeOf(context).languageCode;
    _loadedLanguageCode = languageCode;
    try {
      final content = _changelogCache[languageCode] ??
          await rootBundle.loadString(
              'assets/changelog/CHANGELOG_$languageCode.md');
      _changelogCache[languageCode] = content;
      if (!mounted || _loadedLanguageCode != languageCode) return;
      setState(() {
        _changelogContent = content;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted || _loadedLanguageCode != languageCode) return;
      setState(() {
        _changelogContent = context.l10n.text('changelogLoadError', values: {'error': '$e'});
        _isLoading = false;
      });
    }
  }

  Future<void> _openExternalLink(String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.text('unableOpenLink'))),
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

    final children = <Widget>[];

    for (var index = 0; index < lines.length; index++) {
      final line = lines[index];
      final isVersionHeading = line.startsWith('## [');
      final nextLineIsVersionHeading =
          index + 1 < lines.length && lines[index + 1].startsWith('## [');

      // Empty Text widgets do not reserve the same vertical space on every
      // platform. Use an explicit gap before each version so the changelog
      // has consistent spacing on Android and Linux.
      if (line.isEmpty && nextLineIsVersionHeading) {
        continue;
      }

      if (isVersionHeading && children.isNotEmpty) {
        children.add(const SizedBox(height: 24));
      }

      final linkMatch =
          RegExp(r'\[([^\]]+)\]\((https?:\/\/[^\s)]+)\)').firstMatch(line);

      if (linkMatch == null) {
        children.add(Text(line, style: textStyle));
        continue;
      }

      final prefix = line.substring(0, linkMatch.start);
      final label = linkMatch.group(1)!;
      final url = linkMatch.group(2)!;
      final suffix = line.substring(linkMatch.end);

      children.add(Wrap(
        children: [
          if (prefix.isNotEmpty) Text(prefix, style: textStyle),
          InkWell(
            onTap: () => _openExternalLink(url),
            child: Text(label, style: linkStyle),
          ),
          if (suffix.isNotEmpty) Text(suffix, style: textStyle),
        ],
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
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
        title: Text(context.l10n.text('versionHistory')),
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
