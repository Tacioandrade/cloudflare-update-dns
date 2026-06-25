import 'package:cloudflare_dns/data/local_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

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
}
