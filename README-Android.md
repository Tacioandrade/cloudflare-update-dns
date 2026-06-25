# Cloudflare DNS Manager - Android

Guia especifico para testar e gerar o APK Android. Para funcionalidades comuns, configuracao do token e arquitetura geral, consulte o [README principal](README.md).

No Android, o app suporta login por senha e biometria quando o dispositivo e o sistema operacional oferecem suporte.

## Desenvolvimento e Build via Docker

O fluxo Android usa os arquivos dedicados em `Docker/Android`.

### Teste em Modo Desenvolvimento

Para testar a interface sem emulador Android, o projeto usa o `web-server` do Flutter dentro do Docker:

```bash
docker compose -f Docker/Android/docker-compose.yml up test
```

Acesse:

```text
http://localhost:8080
```

O servico `proxy` em `http://localhost:8081` existe para encaminhar chamadas da API Cloudflare durante o teste web.

### Build do APK

```bash
docker compose -f Docker/Android/docker-compose.yml run --rm build
```

O APK release sera gerado em:

```text
build/app/outputs/flutter-apk/
```

## Assinatura do APK

O build Android release exige `android/key.properties` com as credenciais da keystore persistente. Sem esse arquivo, o Gradle interrompe o build release.

Arquivos de keystore e `android/key.properties` devem permanecer fora do Git.

## Detalhes da Plataforma

- Plataforma alvo: Android.
- Artefato gerado: APK.
- Docker dedicado: `Docker/Android/Dockerfile`.
- Compose dedicado: `Docker/Android/docker-compose.yml`.
- Pacote: `br.com.multiti.cloudflare_update_dns`.
- Permissoes Android: internet e biometria.
- Icone do launcher: `assets/icon.png`, gerado para `android/app/src/main/res/mipmap-*`.
- Biometria: implementada com `local_auth`.
- Segredos locais: `flutter_secure_storage`.

## Sessao

Ao fechar e reabrir o aplicativo, o login e exigido novamente. A sessao autenticada nao fica persistida em disco.

## Referencias

- [README principal](README.md)
- [README Linux](README-Linux.md)
- [README Windows](README-Windows.md)
