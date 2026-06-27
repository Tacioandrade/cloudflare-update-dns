# AGENTS.md

## Nome do Projeto

- O nome atual do projeto/aplicativo e **Cloudflare DNS Manager**.
- Use **Cloudflare DNS Manager** para qualquer texto visivel ao usuario, documentacao nova, titulos de janela, atalhos, nomes de instalador, nomes de menu, nomes de pacote distribuivel e metadados publicos.
- O nome antigo **Cloudflare Update DNS** nao deve ser usado em novas telas, atalhos, documentacao, artefatos ou textos publicos.

## Compatibilidade de Identificadores Legados

- Identificadores legados com `cloudflare_update_dns` ou `cloudflare-update-dns` podem continuar existindo somente quando forem necessarios para compatibilidade.
- Em especial, `br.com.multiti.cloudflare_update_dns` pode ser mantido como package/application ID para evitar quebra de atualizacao, assinatura, instalacao ou dados existentes.
- Nao use `cloudflare_update_dns`, `cloudflare-update-dns` ou variantes do nome antigo para novas criacoes que sejam visiveis ao usuario, como atalhos, nomes de app, nomes de executavel final, diretorios de pacote, labels, titulos ou artefatos publicados, salvo se a compatibilidade exigir explicitamente.
- Para novos identificadores internos que nao dependam de compatibilidade, prefira o padrao atual `cloudflare_dns`.

## Contexto do Projeto

- Este e um aplicativo Flutter/Dart para gerenciamento de registros DNS via Cloudflare API.
- O pacote Dart atual e `cloudflare_dns`.
- O app armazena configuracoes nao sensiveis com `shared_preferences`.
- Segredos locais, como senha e token da Cloudflare, usam `flutter_secure_storage`.
- A senha local do app nao deve ser salva em texto claro; o app usa hash PBKDF2-HMAC-SHA256 com salt aleatorio.
- Autenticacao biometrica usa `local_auth` quando a plataforma suporta.
- Comunicacao de rede usa `http`.
- Links externos usam `url_launcher`.

## Plataformas

- Plataformas com suporte/documentacao no projeto: Android, Linux e Windows.
- Existem pastas Flutter tambem para iOS, macOS e Web; trate alteracoes nelas com cuidado e teste quando forem afetadas.
- Leia os guias especificos antes de mudar comandos, nomes ou empacotamento:
  - `README-Android.md`
  - `README-Linux.md`
  - `README-Windows.md`

## Comandos Uteis

- Validacao estatica: `flutter analyze`
- Testes: `flutter test`
- Build Android: consulte `README-Android.md`
- Build Linux: consulte `README-Linux.md`
- Build Windows: consulte `README-Windows.md`

## Cuidados de Manutencao

- Antes de renomear packages, application IDs, bundle IDs ou namespaces, verifique impacto em atualizacoes, assinatura, armazenamento local e compatibilidade com instalacoes existentes.
- Evite trocar identificadores de plataforma apenas para alinhar nomes cosmeticos.
- Quando alterar textos ou nomes de aplicativo, verifique Linux, Windows, Android, Web manifest e configuracoes de macOS/iOS se forem relevantes.
- Mantenha o `CHANGELOG.md` atualizado para mudancas de usuario, releases e ajustes de empacotamento.
- Preserve o estilo atual do projeto: Flutter simples, dependencias enxutas e configuracoes por plataforma documentadas nos READMEs.
