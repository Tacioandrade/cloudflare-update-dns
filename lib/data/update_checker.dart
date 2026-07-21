import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

import 'local_storage.dart';

class AvailableUpdate {
  final String version;

  const AvailableUpdate({required this.version});
}

class UpdateChecker {
  const UpdateChecker._();

  static final Uri latestReleaseUri = Uri.parse(
    'https://api.github.com/repos/'
    'Tacioandrade/cloudflare-update-dns/releases/latest',
  );
  static final Uri releasesUri = Uri.parse(
    'https://github.com/Tacioandrade/cloudflare-update-dns/releases',
  );

  static bool get supportsCurrentPlatform =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.windows);

  static Future<AvailableUpdate?> checkAtStartup({
    http.Client? client,
    String? installedVersion,
    DateTime? now,
    bool? supportedPlatform,
  }) async {
    if (!(supportedPlatform ?? supportsCurrentPlatform)) return null;
    http.Client? requestClient;
    try {
      if (!await LocalStorage.getUpdateCheckEnabled()) return null;

      final checkDate = _formatDate((now ?? DateTime.now()).toLocal());
      if (await LocalStorage.getLastUpdateCheckDate() == checkDate) {
        return null;
      }

      await LocalStorage.saveLastUpdateCheckDate(checkDate);
      requestClient = client ?? http.Client();
      final response = await requestClient.get(
        latestReleaseUri,
        headers: const {
          'Accept': 'application/vnd.github+json',
          'X-GitHub-Api-Version': '2022-11-28',
          'User-Agent': 'Cloudflare-DNS-Manager',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) return null;

      final payload = jsonDecode(response.body);
      if (payload is! Map<String, dynamic>) return null;

      final latestVersion = payload['tag_name']?.toString();
      if (latestVersion == null || latestVersion.isEmpty) return null;

      final currentVersion =
          installedVersion ?? (await PackageInfo.fromPlatform()).version;
      if (!isNewerVersion(latestVersion, currentVersion)) return null;

      return AvailableUpdate(version: _normalizedVersion(latestVersion));
    } catch (_) {
      return null;
    } finally {
      if (client == null) requestClient?.close();
    }
  }

  static bool isNewerVersion(String candidate, String installed) {
    final candidateParts = _versionParts(candidate);
    final installedParts = _versionParts(installed);
    if (candidateParts == null || installedParts == null) return false;

    for (var index = 0; index < candidateParts.length; index++) {
      if (candidateParts[index] > installedParts[index]) return true;
      if (candidateParts[index] < installedParts[index]) return false;
    }
    return false;
  }

  static List<int>? _versionParts(String version) {
    final match = RegExp(
      r'^v?(\d+)\.(\d+)\.(\d+)(?:[-+].*)?$',
      caseSensitive: false,
    ).firstMatch(version.trim());
    if (match == null) return null;

    return [
      int.parse(match.group(1)!),
      int.parse(match.group(2)!),
      int.parse(match.group(3)!),
    ];
  }

  static String _normalizedVersion(String version) {
    final parts = _versionParts(version);
    return parts?.join('.') ?? version.trim();
  }

  static String _formatDate(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';
}
