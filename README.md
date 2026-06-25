# Cloudflare DNS Manager

Aplicativo em Flutter para gerenciamento de registros DNS via Cloudflare API.

Este README contem as informacoes compartilhadas entre as plataformas. Para comandos de build, testes e detalhes especificos, use os guias por sistema operacional:

- [Android](README-Android.md)
- [Linux](README-Linux.md)
- [Windows](README-Windows.md)

## Funcionalidades

- Autenticacao local por senha.
- Login por biometria nas plataformas que suportam essa integracao.
- Logout automatico ao fechar e reabrir o aplicativo, exigindo novo login.
- Listagem de dominios com status ativo, pendente ou inativo.
- Editor de registros DNS com tipos configuraveis na tela de Configuracoes.
- Toggle de proxy Cloudflare com atualizacao em tempo real.
- Limpeza de cache CDN da zona selecionada.
- Configuracao e validacao do Cloudflare API Token.
- Tema claro, escuro ou automatico pelo sistema.
- Visualizacao do changelog dentro do aplicativo.

## Acesso

No primeiro acesso, o aplicativo abre a tela de criacao de senha. Depois disso, cada nova execucao do app exige login novamente.

A sessao autenticada fica apenas em memoria. Senha do app, token da Cloudflare, tema e configuracoes de DNS continuam salvos localmente.

## Cloudflare API Token

1. Faca login no aplicativo.
2. Abra Configuracoes.
3. Cole seu Cole seu [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens)
4. Clique em Testar para validar.
5. Clique em Salvar.

Para usar a limpeza de Cache CDN, crie um token customizado com as seguintes permissoes:

- Zona / Zone => Limpeza do cache / Cache Purge => Limpar / Clear
- Zona / Zone => DNS => Editar / Edit

## Arquitetura

- Framework: Flutter / Dart
- Estado local: `shared_preferences`
- Autenticacao biometrica: `local_auth`, quando suportado pela plataforma
- Comunicacao de rede: `http`
- Abertura de links externos: `url_launcher`

## Estrutura dos Guias

- `README-Android.md`: Documentação do build e detalhes da versão para Android.
- `README-Linux.md`: Documentação do build e detalhes da versão para Linux.
- `README-Windows.md`: Documentação do build e detalhes da versão para Windows.

## Licenca

MIT
