# Changelog

Projeto no GitHub: [https://github.com/Tacioandrade/cloudflare-update-dns/](https://github.com/Tacioandrade/cloudflare-update-dns/)

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

## [1.1.4] - 2026-06-27
### Adicionado / Alterado
- Renomeado o projeto de Cloudflare Update DNS para Cloudflare DNS Manager.
- Adicionado atalho de teclado `Ctrl + N` para abrir a criação de um novo registro DNS.

## [1.1.3] - 2026-06-26
### Corrigido
- Corrigido bug de execução na versão para Windows relacionado à ausência do Microsoft Visual C++ Runtime.
- Corrigidos ajustes de CI/CD do projeto para publicar apenas o changelog da versão atual e empacotar os bundles Windows e Linux dentro da pasta `cloudflare-update-dns`.

## [1.1.2] - 2026-06-26
### Adicionado / Corrigido
- Adicionada validação do conteúdo informado na criação e edição de registros DNS.
- Validado IPv4 para registros `A` e IPv6 para registros `AAAA`.
- Validado formato de domínio para registros `CNAME`, `MX` e `NS`, sem depender de lista fixa de TLDs.
- Validado formato básico de registros `SRV` e conteúdo não vazio para registros `TXT`.
- Corrigida a validação de domínio para rejeitar IPs informados em registros `CNAME`, `MX`, `NS` e destino de `SRV`.
- Corrigida a criação de registros `TXT` como DMARC e DKIM, removendo o envio indevido do campo `proxied` para tipos não proxiáveis.
- O controle `Proxied` agora aparece apenas para registros `A`, `AAAA` e `CNAME`.
- Ajustada a mensagem de erro exibida quando a API da Cloudflare rejeita a criação ou atualização de um registro.
- Ativa o CI/CD do projeto para gerar aplicação para Windows e Linux automaticamente.

## [1.1.1] - 2026-06-25
### Adicionado / Corrigido
- Ao abrir a aplicação o foco do teclado ficará no campo de senha ou biometria (dependendo do tipo de autenticação configurado).
- Adicionado atalho de teclado `Ctrl + F` para abrir rapidamente a pesquisa nas listas de domínios e de registros DNS.
- Adicionado atalho de teclado `ESC` para fechar rapidamente a funcionalidade de pesquisa.
- Adicionado atalho de teclado `ESC` para fechar rapidamente a tela de criação/edição de registro DNS.
- Adicionado atalho de teclado `ESC` para voltar a tela de listagem de domínios, caso esteja na tela de criação/edição de registro DNS ou configurações.
- Implementado login automático ao pressionar a tecla `Enter` no campo de senha na tela de login.
- Implementado salvamento automático do registro DNS ao pressionar a tecla `Enter` nos campos de subdomínio e conteúdo durante a criação/edição.

## [1.1.0] - 2026-06-25
### Adicionado
- Adicionada documentação e fluxo de build/testes para a versão Windows.
- Adicionada documentação e fluxo de build/testes para a versão Linux.

### Segurança
- Alterado o armazenamento do Cloudflare API Token para `flutter_secure_storage`, usando o armazenamento seguro nativo de cada plataforma.
- Alterado o armazenamento da senha do app para hash PBKDF2-HMAC-SHA256 com salt aleatório no armazenamento seguro, removendo a persistência da senha em texto claro.
- Mantida a sessão autenticada apenas em memória, exigindo novo login ao reabrir o aplicativo.
- Mantidas em `shared_preferences` apenas configurações não sensíveis, como tema e tipos de registros DNS.

## [1.0.8] - 2026-06-24
### Corrigido
- Forçado o logout da aplicação ao fechar e reabrir o app, exigindo novo login em todos os sistemas operacionais.

## [1.0.7] - 2026-06-24
### Adicionado / Corrigido
- Adicionado suporte a tema claro e escuro com detecção automática do tema configurado no sistema operacional.
- Adicionada opção em Configurações para escolher entre tema do sistema, claro ou escuro.
- Adicionada localização nativa do Flutter para exibir textos internos, como copiar, colar e selecionar tudo, no idioma do dispositivo.

## [1.0.6] - 2026-06-24
### Adicionado / Corrigido
- Adicionada funcionalidade de limpeza do cache da CDN para a zona selecionada na tela de registros DNS.
- Documentadas as permissões necessárias para usar a limpeza de Cache CDN com Token customizado da Cloudflare.

## [1.0.5] - 2026-06-24
### Adicionado / Corrigido
- Alterado o primeiro acesso para abrir diretamente a tela de criação de senha, sem exigir senha padrão ou biometria.
- Removido o campo de usuário da tela de login; o acesso agora é feito apenas por senha cadastrada ou biometria.

## [1.0.4] - 2026-06-19
### Adicionado / Corrigido
- Adicionado seletor de tipos de entradas DNS nas configurações para permitir filtrar quais registros o sistema carrega.
- Adicionada tela de visualização do Changelog diretamente no aplicativo.

## [1.0.3] - 2026-06-19
### Adicionado / Corrigido
- Implementado suporte nativo para login via Biometria (Impressão digital / Reconhecimento facial) com fallback transparente e automático.
- Ajuste na edição de domínios DNS para permitir a edição de apenas o subdomínio da entrada.

## [1.0.2] - 2026-06-18
### Adicionado / Corrigido
- Correção na lógica de integração com a API para realizar paginação automática. Agora o aplicativo puxa todos os domínios e registros DNS que o token tem acesso, contornando o limite padrão de 20 registros por página do Cloudflare.
- Ajustes finos de interface e identidade visual.
- Implementação de novo logotipo e geração de ícones padronizados (Android, iOS e Web).

## [1.0.1] - 2026-06-18
### Corrigido
- Resolução de problemas de compatibilidade e correção de código para o build nativo do Android.
- Ajuste das versões do Kotlin e configuração do NDK para compilação segura.
- Alteração do identificador do pacote (Application ID) de padrão de exemplo para a assinatura corporativa oficial.

## [1.0.0] - Lançamento Inicial
### Adicionado
- Versão básica do sistema.
- Gerenciamento completo de registros DNS via Cloudflare API.
- Capacidade de rodar localmente no navegador ou ser empacotado para Android via Flutter.
- Modo noturno dinâmico e interface moderna.
