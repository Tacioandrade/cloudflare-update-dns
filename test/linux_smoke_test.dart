import 'package:cloudflare_dns/main.dart';
import 'package:cloudflare_dns/core/app_language.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Linux login uses password instead of biometric auth',
      (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.linux;
    AppLanguageController.locale.value = const Locale('pt');

    await tester.pumpWidget(
      const CloudflareDnsApp(hasPassword: true, isAuth: false),
    );
    await tester.pumpAndSettle();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.byIcon(Icons.fingerprint), findsNothing);

    debugDefaultTargetPlatformOverride = null;
    AppLanguageController.locale.value = null;
  });
}
