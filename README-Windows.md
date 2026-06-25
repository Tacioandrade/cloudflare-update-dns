# Cloudflare DNS Manager - Windows

Guia especifico para compilar, testar e executar a versao Windows. Para funcionalidades comuns, configuracao do token e arquitetura geral, consulte o [README principal](README.md).

No Windows, o app suporta login por senha e biometria via Windows Hello quando o dispositivo e o sistema operacional oferecem suporte.

## Build e Testes via Docker

Os arquivos Docker da versao Windows ficam em `Docker/Windows` para nao alterar os fluxos Android e Linux.

Este fluxo usa Windows containers. Execute em uma maquina Windows com Docker Desktop alternado para Windows containers. Ele nao roda em Linux containers nem em Docker Engine Linux/WSL.

### Analise Estatica

```powershell
docker compose -f Docker/Windows/docker-compose.yml run --rm analyze
```

### Testes

```powershell
docker compose -f Docker/Windows/docker-compose.yml run --rm test
```

### Build Windows

```powershell
docker compose -f Docker/Windows/docker-compose.yml run --rm build
```

O bundle release sera gerado em:

```text
build\windows\x64\runner\Release\
```

O executavel principal sera:

```text
build\windows\x64\runner\Release\cloudflare_dns.exe
```

## Detalhes da Plataforma

- Plataforma alvo: Windows desktop x64.
- Artefato gerado: bundle nativo com `.exe`.
- Docker dedicado: `Docker/Windows/Dockerfile`.
- Compose dedicado: `Docker/Windows/docker-compose.yml`.
- Runner nativo: `windows/runner/`.
- Icone do executavel: `windows/runner/resources/app_icon.ico`.
- Biometria: `local_auth_windows`, usando Windows Hello quando disponivel.
- Segredos locais: `flutter_secure_storage_windows`.

## Toolchain no Container

A imagem Windows instala:

- Flutter `3.22.0`.
- Git for Windows.
- Visual Studio Build Tools com C++ workload, CMake e Windows SDK.

A primeira compilacao pode demorar bastante porque a imagem baixa e instala o toolchain nativo Windows.

## Sessao

Ao fechar e reabrir o aplicativo, o login e exigido novamente. A sessao autenticada nao fica persistida em disco.

## Referencias

- [README principal](README.md)
- [README Android](README-Android.md)
- [README Linux](README-Linux.md)
