import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/update_checker.dart';
import '../l10n/app_localizations.dart';

class StartupUpdateCheck extends StatefulWidget {
  final Widget child;

  const StartupUpdateCheck({super.key, required this.child});

  @override
  State<StartupUpdateCheck> createState() => _StartupUpdateCheckState();
}

class _StartupUpdateCheckState extends State<StartupUpdateCheck> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkForUpdate());
  }

  Future<void> _checkForUpdate() async {
    final update = await UpdateChecker.checkAtStartup();
    if (!mounted || update == null) return;

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.text('updateAvailableTitle')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.text(
              'updateAvailableMessage',
              values: {'version': update.version},
            )),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _openReleases,
              icon: const Icon(Icons.open_in_new),
              label: Text(UpdateChecker.releasesUri.toString()),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(context.l10n.text('close')),
          ),
        ],
      ),
    );
  }

  Future<void> _openReleases() async {
    final opened = await launchUrl(
      UpdateChecker.releasesUri,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.text('unableOpenLink'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
