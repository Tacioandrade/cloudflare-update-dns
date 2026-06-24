# Cloudflare DNS Manager — Flutter Android App

> Aplicativo Android construído em Flutter para gerenciamento de registros DNS via Cloudflare API.

## ✨ Funcionalidades

- 🔐 **Autenticação local**
- 🌐 **Listagem de domínios** com status (ativo/pendente/inativo)
- 📝 **Editor DNS** completo para registros **DNS**, sendo configurados quais entradas listar na tela de Configurações
- 🔄 **Toggle de proxy** Cloudflare com atualização em tempo real
- ⚙️ **Configurações** para gerenciar o API Token
- 📱 **App Nativo Android** — distribuído em formato `.apk`
- 🌙 **Dark mode**

## 🐳 Desenvolvimento e Compilação via Docker

Este projeto foi projetado para não depender de ferramentas locais instaladas, como o **Flutter SDK** ou o **Android Studio** (nem o Android Command Line Tools). Todo o processo de testes e compilação do APK é gerenciado através do **Docker**.

### 🛠️ Como Testar o App (Modo Desenvolvimento)

Para testar o aplicativo e visualizar as interfaces, utilizamos a funcionalidade de "web-server" do Flutter rodando dentro do Docker.

1. Inicie o serviço de testes:
   ```bash
   docker compose up test
   ```
2. Acesse no seu navegador: `http://localhost:8080`

Dessa forma, você interage com a UI do aplicativo perfeitamente pelo navegador sem precisar de emulador de celular na sua máquina.

### 📦 Como Gerar o APK (Android)

Para compilar o projeto e gerar o instalador nativo do Android (`.apk`), execute:

```bash
docker compose run --rm build
```

Este comando provisiona um container com o Flutter SDK e as dependências Android, faz o build do projeto e salva o arquivo `.apk` resultante.
> **Onde encontrar o APK:** Após a compilação, o arquivo gerado estará na pasta `build/app/outputs/flutter-apk/` (ou na pasta que você configurar como volume em seu `docker-compose.yml`) do seu projeto local. Você pode então transferi-lo para um dispositivo Android.

## 🔑 Acesso

No primeiro acesso, o aplicativo abre diretamente a tela de criação de senha. Depois disso, o login passa a ser feito apenas com a senha cadastrada ou biometria, quando disponível no dispositivo.

## ⚙️ Configuração do Cloudflare API Token

1. Faça login no aplicativo
2. Clique no ícone de **Configurações**
3. Cole seu [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens)
4. Clique em **Testar** para validar
5. Clique em **Salvar Token**

> O token precisa ter permissão de **Zone:Read**, **DNS:Edit** e **Cache Purge** para as zonas desejadas.

Para utilizar a funcionalidade de limpeza de Cache CDN de uma Zona, você precisa criar um Token customizado com as seguintes permissões:

- **Zona / Zone** => **Limpeza do cache / Cache Purge** => **Limpar / Clear**
- **Zona / Zone** => **DNS** => **Editar / Edit**

## 🏗️ Arquitetura

- **Framework:** Flutter / Dart
- **Autenticação e Sessão:** Gerenciadas via `SharedPreferences`
- **Comunicação de Rede:** Módulo `http`
- **Ambiente de Build:** Imagens Docker (`ghcr.io/cirruslabs/flutter` ou similar)

## 📄 Licença

MIT
