import 'package:cloudflare_dns/data/local_storage.dart';
import 'package:cloudflare_dns/data/update_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('compares semantic release versions numerically', () {
    expect(UpdateChecker.isNewerVersion('v2.0.2', '2.0.1'), isTrue);
    expect(UpdateChecker.isNewerVersion('2.1.0', '2.0.10'), isTrue);
    expect(UpdateChecker.isNewerVersion('3.0.0', '2.9.9'), isTrue);
    expect(UpdateChecker.isNewerVersion('2.0.1', '2.0.1'), isFalse);
    expect(UpdateChecker.isNewerVersion('2.0.0', '2.0.1'), isFalse);
    expect(UpdateChecker.isNewerVersion('invalid', '2.0.1'), isFalse);
  });

  test('checks GitHub only once per local calendar day', () async {
    var requestCount = 0;
    final client = MockClient((request) async {
      requestCount++;
      expect(request.url, UpdateChecker.latestReleaseUri);
      return http.Response('{"tag_name":"v2.0.2"}', 200);
    });
    final now = DateTime(2026, 7, 20, 8);

    final firstResult = await UpdateChecker.checkAtStartup(
      client: client,
      installedVersion: '2.0.1',
      now: now,
      supportedPlatform: true,
    );
    final secondResult = await UpdateChecker.checkAtStartup(
      client: client,
      installedVersion: '2.0.1',
      now: now.add(const Duration(hours: 4)),
      supportedPlatform: true,
    );

    expect(firstResult?.version, '2.0.2');
    expect(secondResult, isNull);
    expect(requestCount, 1);
    expect(await LocalStorage.getLastUpdateCheckDate(), '2026-07-20');
  });

  test('does not contact GitHub when update checks are disabled', () async {
    await LocalStorage.saveUpdateCheckEnabled(false);
    var requestCount = 0;
    final client = MockClient((request) async {
      requestCount++;
      return http.Response('{"tag_name":"v2.0.2"}', 200);
    });

    final result = await UpdateChecker.checkAtStartup(
      client: client,
      installedVersion: '2.0.1',
      now: DateTime(2026, 7, 20),
      supportedPlatform: true,
    );

    expect(result, isNull);
    expect(requestCount, 0);
    expect(await LocalStorage.getLastUpdateCheckDate(), isNull);
  });

  test('does not check on unsupported platforms', () async {
    var requestCount = 0;
    final client = MockClient((request) async {
      requestCount++;
      return http.Response('{"tag_name":"v2.0.2"}', 200);
    });

    final result = await UpdateChecker.checkAtStartup(
      client: client,
      installedVersion: '2.0.1',
      supportedPlatform: false,
    );

    expect(result, isNull);
    expect(requestCount, 0);
  });
}
