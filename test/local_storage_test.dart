import 'package:cloudflare_dns/data/local_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('authentication state is kept only in the current process', () async {
    SharedPreferences.setMockInitialValues({'authenticated': true});

    expect(await LocalStorage.isAuthenticated(), isFalse);

    await LocalStorage.login();
    expect(await LocalStorage.isAuthenticated(), isTrue);

    await LocalStorage.logout();
    expect(await LocalStorage.isAuthenticated(), isFalse);

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool('authenticated'), isNull);
  });

  test('app password is verified from a secure hash', () async {
    await LocalStorage.saveAppPassword('senha-segura');

    expect(await LocalStorage.hasAppPassword(), isTrue);
    expect(await LocalStorage.verifyAppPassword('senha-segura'), isTrue);
    expect(await LocalStorage.verifyAppPassword('senha-errada'), isFalse);
  });

  test('cloudflare token is stored in secure storage', () async {
    await LocalStorage.saveToken('cf-token');

    expect(await LocalStorage.getToken(), 'cf-token');

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('cf_api_token'), isNull);
  });

  test('language preference is stored in shared preferences', () async {
    expect(await LocalStorage.getLanguage(), 'system');

    await LocalStorage.saveLanguage('ja');

    expect(await LocalStorage.getLanguage(), 'ja');
  });
}
