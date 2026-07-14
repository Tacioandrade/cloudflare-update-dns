# Cloudflare DNS Manager - iOS

Guia para compilar e testar a versão iOS em um Mac. A compilação exige macOS, Xcode e CocoaPods.

## Preparação

1. Instale o Flutter, Xcode e CocoaPods.
2. Abra `ios/Runner.xcworkspace` no Xcode após executar `flutter pub get`.
3. Em **Signing & Capabilities**, selecione sua equipe Apple e configure um perfil para `br.com.multiti.cloudflare_dns`.

## Testes e build

```bash
flutter pub get
flutter test
flutter build ios --debug
```

Para distribuição, configure assinatura e execute:

```bash
flutter build ipa --release
```

## Detalhes

- Alvo mínimo: iOS 13.
- A versão vem de `pubspec.yaml`.
- Face ID solicita uma descrição de uso no `Info.plist`.
- O token e a senha usam o armazenamento seguro nativo.
