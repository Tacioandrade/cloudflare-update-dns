# Cloudflare DNS Manager - macOS

Guia para compilar e testar a versão macOS em um Mac. A compilação exige macOS, Xcode e CocoaPods.

## Preparação

1. Instale o Flutter, Xcode e CocoaPods.
2. Execute `flutter pub get` para instalar os pods.
3. Abra `macos/Runner.xcworkspace` no Xcode para configurar assinatura e distribuição.

## Testes e build

```bash
flutter pub get
flutter test
flutter build macos --release
```

O bundle é gerado em `build/macos/Build/Products/Release/`.

## Detalhes

- Alvo mínimo: macOS 10.15.
- Bundle ID: `br.com.multiti.cloudflare_dns`.
- O sandbox inclui acesso de rede de saída para a API Cloudflare.
- Para publicar fora do ambiente local, configure a equipe Apple, certificado e notarização no Xcode.
