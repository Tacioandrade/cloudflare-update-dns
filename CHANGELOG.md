# Changelog

Todas as alterações notáveis neste projeto serão documentadas neste arquivo.

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
