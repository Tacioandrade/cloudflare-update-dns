# Cloudflare DNS Manager - Linux

Guia especifico para compilar, testar e executar a versao Linux. Para funcionalidades comuns, configuracao do token e arquitetura geral, consulte o [README principal](README.md).

No Linux, o app usa login local apenas por senha. A validacao por biometria e ignorada nessa plataforma.

## Build e Testes via Docker

Os arquivos Docker da versao Linux ficam em `Docker/Linux` para nao alterar a imagem usada pelo fluxo Android.

### Analise Estatica

```bash
docker compose -f Docker/Linux/docker-compose.yml run --rm analyze
```

### Testes

```bash
docker compose -f Docker/Linux/docker-compose.yml run --rm test
```

### Build Linux

```bash
docker compose -f Docker/Linux/docker-compose.yml run --rm build
```

O executavel sera gerado em:

```text
build/linux/x64/release/bundle/cloudflare_dns
```

Para executar depois do build:

```bash
./build/linux/x64/release/bundle/cloudflare_dns
```

## Detalhes da Plataforma

- Plataforma alvo: Linux desktop x64.
- Artefato gerado: bundle nativo com binario ELF.
- Docker dedicado: `Docker/Linux/Dockerfile`.
- Compose dedicado: `Docker/Linux/docker-compose.yml`.
- Icone e nome da janela sao aplicados pelo runner GTK em `linux/runner/my_application.cc`.
- Plugins Linux usados pelo projeto incluem `shared_preferences_linux`, `flutter_secure_storage_linux` e `url_launcher_linux`.
- O armazenamento seguro usa `libsecret`; por isso o pacote `libsecret-1-0` e necessario em runtime e `libsecret-1-dev` em build.

## Sessao

Ao fechar e reabrir o aplicativo, o login e exigido novamente. A sessao autenticada nao fica persistida em disco.

## Referencias

- [README principal](README.md)
- [README Android](README-Android.md)
- [README Windows](README-Windows.md)
