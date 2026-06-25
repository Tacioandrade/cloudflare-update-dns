import 'package:cloudflare_dns/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Linux login uses password instead of biometric auth',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;

    await tester.pumpWidget(
      const CloudflareDnsApp(hasPassword: true, isAuth: false),
    );

    expect(find.text('Senha'), findsOneWidget);
    expect(find.text('ENTRAR'), findsOneWidget);
    expect(find.text('ENTRAR COM BIOMETRIA'), findsNothing);

    debugDefaultTargetPlatformOverride = null;
  });
}
