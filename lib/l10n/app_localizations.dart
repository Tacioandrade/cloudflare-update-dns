import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;
  static const supportedLocales = [
    Locale('pt'), Locale('en'), Locale('fr'), Locale('es'), Locale('zh'), Locale('ja'),
  ];

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  String text(String key, {Map<String, String> values = const {}}) {
    var value = (_translations[locale.languageCode] ?? _translations['en']!)[key] ??
        _translations['en']![key] ?? key;
    values.forEach((name, replacement) => value = value.replaceAll('{$name}', replacement));
    return value;
  }

  static const _translations = <String, Map<String, String>>{
    'en': {
      'dnsFilters': 'DNS filters', 'filterByType': 'Record type', 'filterByProxy': 'Proxy status',
      'proxyEnabled': 'Enabled', 'proxyDisabled': 'Disabled', 'clearFilters': 'Clear filters',
      'appName': 'Cloudflare DNS Manager', 'domains': 'Domains', 'settings': 'Settings',
      'searchDomain': 'Search domain...', 'searchRecord': 'Search record...',
      'noDomains': 'No domains found.', 'noDomainsSearch': 'No domains match the search.',
      'noRecords': 'No records found.', 'configureToken': 'Configure token',
      'tokenNotConfigured': 'Token not configured. Go to Settings.',
      'domainsLoadError': 'Error loading domains: {error}',
      'partialDomainsError': 'Some domains were loaded, but an error occurred: {error}',
      'apiToken': 'Cloudflare API Token', 'test': 'TEST', 'save': 'SAVE',
      'tokenSaved': 'Token saved!', 'connectionSuccess': 'Connection successful!',
      'connectionFailed': 'Connection failed. Invalid token.', 'appTheme': 'App theme',
      'themeDescription': 'Choose a fixed theme or automatically use the system theme.',
      'systemTheme': 'Use system theme', 'light': 'Light', 'dark': 'Dark',
      'language': 'Language', 'languageDescription': 'Choose the app language or use the system language.',
      'systemLanguage': 'Use system language', 'portuguese': 'Portuguese', 'english': 'English',
      'french': 'French', 'spanish': 'Spanish', 'chineseSimplified': 'Chinese (Simplified)', 'japanese': 'Japanese',
      'dnsTypes': 'DNS record types', 'dnsTypesDescription': 'Select which DNS types the app will load and show:',
      'atLeastOneType': 'At least one record type is required.', 'changePassword': 'Change app password',
      'currentPassword': 'Current password', 'newPassword': 'New password', 'confirmNewPassword': 'Confirm new password',
      'password': 'Password', 'confirmPassword': 'Confirm password', 'updatePassword': 'UPDATE PASSWORD',
      'passwordIncorrect': 'Current password is incorrect!', 'passwordEmpty': 'The password cannot be empty.',
      'newPasswordEmpty': 'The new password cannot be empty!', 'passwordMismatch': 'Passwords do not match.',
      'passwordMismatchExclaim': 'Passwords do not match!', 'passwordUpdated': 'Password updated successfully!',
      'about': 'About the app', 'viewChangelog': 'VIEW VERSION HISTORY (CHANGELOG)',
      'versionHistory': 'Version history', 'changelogLoadError': 'Unable to load the changelog.\nDetails: {error}',
      'unableOpenLink': 'Unable to open the link.',
      'credentialsInvalid': 'Invalid credentials!', 'biometricReason': 'Authenticate to manage your DNS domains',
      'loginBiometric': 'LOGIN WITH BIOMETRICS', 'usePassword': 'Use password instead of biometrics',
      'login': 'LOGIN', 'createPassword': 'Create password', 'saveAndLogin': 'SAVE AND LOGIN',
      'error': 'Error: {error}', 'updateError': 'Error updating: {error}', 'deleteError': 'Error deleting: {error}',
      'purgeCache': 'Purge CDN cache', 'purgeConfirmTitle': 'Confirm CDN cache purge',
      'purgeConfirmMessage': 'Purging the cache may temporarily slow down your site. Do you want to continue?',
      'cancel': 'Cancel', 'purge': 'Purge', 'cachePurged': 'CDN cache purged successfully.',
      'purgeError': 'Error purging CDN cache: {error}', 'newRecord': 'New record', 'editRecord': 'Edit record',
      'type': 'Type', 'nameSubdomain': 'Name (subdomain)', 'content': 'Content (IP or destination)',
      'proxied': 'Proxied', 'recordSave': 'Save', 'deleteConfirmTitle': 'Confirm deletion',
      'deleteRecord': 'Delete record {name}?', 'delete': 'Delete',
    },
    'pt': {
      'dnsFilters': 'Filtros de DNS', 'filterByType': 'Tipo de registro', 'filterByProxy': 'Status do proxy',
      'proxyEnabled': 'Ativado', 'proxyDisabled': 'Desativado', 'clearFilters': 'Limpar filtros',
      'appName': 'Cloudflare DNS Manager', 'domains': 'Domínios', 'settings': 'Configurações',
      'searchDomain': 'Pesquisar domínio...', 'searchRecord': 'Pesquisar registro...', 'noDomains': 'Nenhum domínio encontrado.',
      'noDomainsSearch': 'Nenhum domínio corresponde à pesquisa.', 'noRecords': 'Nenhum registro encontrado.',
      'configureToken': 'Configurar token', 'tokenNotConfigured': 'Token não configurado. Vá em Configurações.',
      'domainsLoadError': 'Erro ao carregar domínios: {error}', 'partialDomainsError': 'Alguns domínios foram carregados, mas ocorreu um erro: {error}',
      'apiToken': 'Token da API Cloudflare', 'test': 'TESTAR', 'save': 'SALVAR', 'tokenSaved': 'Token salvo!',
      'connectionSuccess': 'Conexão bem-sucedida!', 'connectionFailed': 'Falha na conexão. Token inválido.',
      'appTheme': 'Tema do aplicativo', 'themeDescription': 'Escolha um tema fixo ou use automaticamente o tema configurado no sistema.',
      'systemTheme': 'Usar tema do sistema', 'light': 'Claro', 'dark': 'Escuro', 'language': 'Idioma',
      'languageDescription': 'Escolha o idioma do aplicativo ou use o idioma do sistema.', 'systemLanguage': 'Usar idioma do sistema',
      'portuguese': 'Português', 'english': 'Inglês', 'french': 'Francês', 'spanish': 'Espanhol', 'chineseSimplified': 'Chinês simplificado', 'japanese': 'Japonês',
      'dnsTypes': 'Tipos de registro DNS', 'dnsTypesDescription': 'Selecione quais tipos de DNS o aplicativo irá carregar e exibir:',
      'atLeastOneType': 'É necessário pelo menos um tipo de registro.', 'changePassword': 'Alterar senha do app',
      'currentPassword': 'Senha atual', 'newPassword': 'Nova senha', 'confirmNewPassword': 'Confirmar nova senha', 'password': 'Senha', 'confirmPassword': 'Confirmar senha',
      'updatePassword': 'ATUALIZAR SENHA', 'passwordIncorrect': 'Senha atual incorreta!', 'passwordEmpty': 'A senha não pode ser vazia.',
      'newPasswordEmpty': 'A nova senha não pode ser vazia!', 'passwordMismatch': 'As senhas não coincidem.', 'passwordMismatchExclaim': 'As senhas não coincidem!',
      'passwordUpdated': 'Senha atualizada com sucesso!', 'about': 'Sobre o aplicativo', 'viewChangelog': 'VER HISTÓRICO DE VERSÕES (CHANGELOG)',
      'versionHistory': 'Histórico de versões', 'changelogLoadError': 'Erro ao carregar o changelog.\nDetalhes: {error}', 'unableOpenLink': 'Não foi possível abrir o link.',
      'credentialsInvalid': 'Credenciais inválidas!', 'biometricReason': 'Autentique-se para gerenciar seus domínios DNS',
      'loginBiometric': 'ENTRAR COM BIOMETRIA', 'usePassword': 'Usar senha ao invés da biometria', 'login': 'ENTRAR', 'createPassword': 'Criar senha', 'saveAndLogin': 'SALVAR E ENTRAR',
      'error': 'Erro: {error}', 'updateError': 'Erro ao atualizar: {error}', 'deleteError': 'Erro ao deletar: {error}', 'purgeCache': 'Limpar cache da CDN',
      'purgeConfirmTitle': 'Confirme a limpeza do cache da CDN', 'purgeConfirmMessage': 'Limpar o cache pode tornar seu site temporariamente lento. Deseja continuar?',
      'cancel': 'Cancelar', 'purge': 'Limpar', 'cachePurged': 'Cache da CDN limpo com sucesso.', 'purgeError': 'Erro ao limpar cache da CDN: {error}',
      'newRecord': 'Novo registro', 'editRecord': 'Editar registro', 'type': 'Tipo', 'nameSubdomain': 'Nome (subdomínio)', 'content': 'Conteúdo (IP ou destino)',
      'proxied': 'Proxied', 'recordSave': 'Salvar', 'deleteConfirmTitle': 'Confirmar exclusão', 'deleteRecord': 'Deletar o registro {name}?', 'delete': 'Deletar',
    },
    'fr': {
      'dnsFilters': 'Filtres DNS', 'filterByType': 'Type d’enregistrement', 'filterByProxy': 'État du proxy',
      'proxyEnabled': 'Activé', 'proxyDisabled': 'Désactivé', 'clearFilters': 'Effacer les filtres',
'appName': 'Cloudflare DNS Manager', 'domains': 'Domaines', 'settings': 'Paramètres', 'searchDomain': 'Rechercher un domaine...', 'searchRecord': 'Rechercher un enregistrement...', 'noDomains': 'Aucun domaine trouvé.', 'noDomainsSearch': 'Aucun domaine ne correspond à la recherche.', 'noRecords': 'Aucun enregistrement trouvé.', 'configureToken': 'Configurer le jeton', 'tokenNotConfigured': 'Jeton non configuré. Accédez aux paramètres.', 'domainsLoadError': 'Erreur lors du chargement des domaines : {error}', 'partialDomainsError': 'Certains domaines ont été chargés, mais une erreur est survenue : {error}', 'apiToken': 'Jeton API Cloudflare', 'test': 'TESTER', 'save': 'ENREGISTRER', 'tokenSaved': 'Jeton enregistré !', 'connectionSuccess': 'Connexion réussie !', 'connectionFailed': 'Échec de la connexion. Jeton invalide.', 'appTheme': 'Thème de l’application', 'themeDescription': 'Choisissez un thème fixe ou utilisez automatiquement le thème du système.', 'systemTheme': 'Utiliser le thème du système', 'light': 'Clair', 'dark': 'Sombre', 'language': 'Langue', 'languageDescription': 'Choisissez la langue de l’application ou utilisez celle du système.', 'systemLanguage': 'Utiliser la langue du système', 'portuguese': 'Portugais', 'english': 'Anglais', 'french': 'Français', 'spanish': 'Espagnol', 'chineseSimplified': 'Chinois simplifié', 'japanese': 'Japonais', 'dnsTypes': 'Types d’enregistrements DNS', 'dnsTypesDescription': 'Sélectionnez les types DNS que l’application chargera et affichera :', 'atLeastOneType': 'Au moins un type d’enregistrement est requis.', 'changePassword': 'Modifier le mot de passe', 'currentPassword': 'Mot de passe actuel', 'newPassword': 'Nouveau mot de passe', 'confirmNewPassword': 'Confirmer le nouveau mot de passe', 'password': 'Mot de passe', 'confirmPassword': 'Confirmer le mot de passe', 'updatePassword': 'METTRE À JOUR LE MOT DE PASSE', 'passwordIncorrect': 'Le mot de passe actuel est incorrect !', 'passwordEmpty': 'Le mot de passe ne peut pas être vide.', 'newPasswordEmpty': 'Le nouveau mot de passe ne peut pas être vide !', 'passwordMismatch': 'Les mots de passe ne correspondent pas.', 'passwordMismatchExclaim': 'Les mots de passe ne correspondent pas !', 'passwordUpdated': 'Mot de passe mis à jour !', 'about': 'À propos de l’application', 'viewChangelog': 'VOIR L’HISTORIQUE DES VERSIONS', 'versionHistory': 'Historique des versions', 'changelogLoadError': 'Impossible de charger le journal des modifications.\nDétails : {error}', 'unableOpenLink': 'Impossible d’ouvrir le lien.', 'credentialsInvalid': 'Identifiants invalides !', 'biometricReason': 'Authentifiez-vous pour gérer vos domaines DNS', 'loginBiometric': 'SE CONNECTER AVEC LA BIOMÉTRIE', 'usePassword': 'Utiliser un mot de passe à la place', 'login': 'SE CONNECTER', 'createPassword': 'Créer un mot de passe', 'saveAndLogin': 'ENREGISTRER ET SE CONNECTER', 'error': 'Erreur : {error}', 'updateError': 'Erreur de mise à jour : {error}', 'deleteError': 'Erreur de suppression : {error}', 'purgeCache': 'Vider le cache CDN', 'purgeConfirmTitle': 'Confirmer la purge du cache CDN', 'purgeConfirmMessage': 'La purge du cache peut temporairement ralentir votre site. Continuer ?', 'cancel': 'Annuler', 'purge': 'Vider', 'cachePurged': 'Cache CDN vidé avec succès.', 'purgeError': 'Erreur lors de la purge du cache CDN : {error}', 'newRecord': 'Nouvel enregistrement', 'editRecord': 'Modifier l’enregistrement', 'type': 'Type', 'nameSubdomain': 'Nom (sous-domaine)', 'content': 'Contenu (IP ou destination)', 'proxied': 'Proxy', 'recordSave': 'Enregistrer', 'deleteConfirmTitle': 'Confirmer la suppression', 'deleteRecord': 'Supprimer l’enregistrement {name} ?', 'delete': 'Supprimer',
    },
    'es': {
      'dnsFilters': 'Filtros DNS', 'filterByType': 'Tipo de registro', 'filterByProxy': 'Estado del proxy',
      'proxyEnabled': 'Activado', 'proxyDisabled': 'Desactivado', 'clearFilters': 'Limpiar filtros',
      'appName': 'Cloudflare DNS Manager', 'domains': 'Dominios', 'settings': 'Configuración', 'searchDomain': 'Buscar dominio...', 'searchRecord': 'Buscar registro...', 'noDomains': 'No se encontraron dominios.', 'noDomainsSearch': 'Ningún dominio coincide con la búsqueda.', 'noRecords': 'No se encontraron registros.', 'configureToken': 'Configurar token', 'tokenNotConfigured': 'Token no configurado. Ve a Configuración.', 'domainsLoadError': 'Error al cargar dominios: {error}', 'partialDomainsError': 'Se cargaron algunos dominios, pero se produjo un error: {error}', 'apiToken': 'Token de API de Cloudflare', 'test': 'PROBAR', 'save': 'GUARDAR', 'tokenSaved': '¡Token guardado!', 'connectionSuccess': '¡Conexión exitosa!', 'connectionFailed': 'Error de conexión. Token no válido.', 'appTheme': 'Tema de la aplicación', 'themeDescription': 'Elige un tema fijo o usa automáticamente el tema del sistema.', 'systemTheme': 'Usar tema del sistema', 'light': 'Claro', 'dark': 'Oscuro', 'language': 'Idioma', 'languageDescription': 'Elige el idioma de la aplicación o usa el idioma del sistema.', 'systemLanguage': 'Usar idioma del sistema', 'portuguese': 'Portugués', 'english': 'Inglés', 'french': 'Francés', 'spanish': 'Español', 'chineseSimplified': 'Chino simplificado', 'japanese': 'Japonés', 'dnsTypes': 'Tipos de registros DNS', 'dnsTypesDescription': 'Selecciona los tipos de DNS que la aplicación cargará y mostrará:', 'atLeastOneType': 'Se requiere al menos un tipo de registro.', 'changePassword': 'Cambiar contraseña de la aplicación', 'currentPassword': 'Contraseña actual', 'newPassword': 'Nueva contraseña', 'confirmNewPassword': 'Confirmar nueva contraseña', 'password': 'Contraseña', 'confirmPassword': 'Confirmar contraseña', 'updatePassword': 'ACTUALIZAR CONTRASEÑA', 'passwordIncorrect': '¡La contraseña actual es incorrecta!', 'passwordEmpty': 'La contraseña no puede estar vacía.', 'newPasswordEmpty': '¡La nueva contraseña no puede estar vacía!', 'passwordMismatch': 'Las contraseñas no coinciden.', 'passwordMismatchExclaim': '¡Las contraseñas no coinciden!', 'passwordUpdated': '¡Contraseña actualizada correctamente!', 'about': 'Acerca de la aplicación', 'viewChangelog': 'VER HISTORIAL DE VERSIONES', 'versionHistory': 'Historial de versiones', 'changelogLoadError': 'No se pudo cargar el registro de cambios.\nDetalles: {error}', 'unableOpenLink': 'No se pudo abrir el enlace.', 'credentialsInvalid': '¡Credenciales inválidas!', 'biometricReason': 'Autentícate para administrar tus dominios DNS', 'loginBiometric': 'INICIAR SESIÓN CON BIOMETRÍA', 'usePassword': 'Usar contraseña en su lugar', 'login': 'INICIAR SESIÓN', 'createPassword': 'Crear contraseña', 'saveAndLogin': 'GUARDAR E INICIAR SESIÓN', 'error': 'Error: {error}', 'updateError': 'Error al actualizar: {error}', 'deleteError': 'Error al eliminar: {error}', 'purgeCache': 'Limpiar caché de CDN', 'purgeConfirmTitle': 'Confirmar limpieza de caché de CDN', 'purgeConfirmMessage': 'Limpiar la caché puede ralentizar temporalmente tu sitio. ¿Deseas continuar?', 'cancel': 'Cancelar', 'purge': 'Limpiar', 'cachePurged': 'Caché de CDN limpiada correctamente.', 'purgeError': 'Error al limpiar caché de CDN: {error}', 'newRecord': 'Nuevo registro', 'editRecord': 'Editar registro', 'type': 'Tipo', 'nameSubdomain': 'Nombre (subdominio)', 'content': 'Contenido (IP o destino)', 'proxied': 'Con proxy', 'recordSave': 'Guardar', 'deleteConfirmTitle': 'Confirmar eliminación', 'deleteRecord': '¿Eliminar el registro {name}?', 'delete': 'Eliminar',
    },
    'zh': {
      'dnsFilters': 'DNS 筛选', 'filterByType': '记录类型', 'filterByProxy': '代理状态',
      'proxyEnabled': '已启用', 'proxyDisabled': '已禁用', 'clearFilters': '清除筛选',
      'appName': 'Cloudflare DNS Manager', 'domains': '域名', 'settings': '设置', 'searchDomain': '搜索域名...', 'searchRecord': '搜索记录...', 'noDomains': '未找到域名。', 'noDomainsSearch': '没有与搜索匹配的域名。', 'noRecords': '未找到记录。', 'configureToken': '配置令牌', 'tokenNotConfigured': '未配置令牌。请前往设置。', 'domainsLoadError': '加载域名时出错：{error}', 'partialDomainsError': '已加载部分域名，但发生错误：{error}', 'apiToken': 'Cloudflare API 令牌', 'test': '测试', 'save': '保存', 'tokenSaved': '令牌已保存！', 'connectionSuccess': '连接成功！', 'connectionFailed': '连接失败。令牌无效。', 'appTheme': '应用主题', 'themeDescription': '选择固定主题或自动使用系统主题。', 'systemTheme': '使用系统主题', 'light': '浅色', 'dark': '深色', 'language': '语言', 'languageDescription': '选择应用语言或使用系统语言。', 'systemLanguage': '使用系统语言', 'portuguese': '葡萄牙语', 'english': '英语', 'french': '法语', 'spanish': '西班牙语', 'chineseSimplified': '简体中文', 'japanese': '日语', 'dnsTypes': 'DNS 记录类型', 'dnsTypesDescription': '选择应用将加载和显示的 DNS 类型：', 'atLeastOneType': '至少需要一种记录类型。', 'changePassword': '更改应用密码', 'currentPassword': '当前密码', 'newPassword': '新密码', 'confirmNewPassword': '确认新密码', 'password': '密码', 'confirmPassword': '确认密码', 'updatePassword': '更新密码', 'passwordIncorrect': '当前密码不正确！', 'passwordEmpty': '密码不能为空。', 'newPasswordEmpty': '新密码不能为空！', 'passwordMismatch': '密码不一致。', 'passwordMismatchExclaim': '密码不一致！', 'passwordUpdated': '密码更新成功！', 'about': '关于应用', 'viewChangelog': '查看版本历史', 'versionHistory': '版本历史', 'changelogLoadError': '无法加载更新日志。\n详情：{error}', 'unableOpenLink': '无法打开链接。', 'credentialsInvalid': '凭据无效！', 'biometricReason': '请验证身份以管理您的 DNS 域名', 'loginBiometric': '使用生物识别登录', 'usePassword': '改用密码', 'login': '登录', 'createPassword': '创建密码', 'saveAndLogin': '保存并登录', 'error': '错误：{error}', 'updateError': '更新错误：{error}', 'deleteError': '删除错误：{error}', 'purgeCache': '清除 CDN 缓存', 'purgeConfirmTitle': '确认清除 CDN 缓存', 'purgeConfirmMessage': '清除缓存可能会暂时降低网站速度。要继续吗？', 'cancel': '取消', 'purge': '清除', 'cachePurged': 'CDN 缓存已成功清除。', 'purgeError': '清除 CDN 缓存时出错：{error}', 'newRecord': '新记录', 'editRecord': '编辑记录', 'type': '类型', 'nameSubdomain': '名称（子域名）', 'content': '内容（IP 或目标）', 'proxied': '代理', 'recordSave': '保存', 'deleteConfirmTitle': '确认删除', 'deleteRecord': '删除记录 {name}？', 'delete': '删除',
    },
    'ja': {
      'dnsFilters': 'DNS フィルター', 'filterByType': 'レコードタイプ', 'filterByProxy': 'プロキシ状態',
      'proxyEnabled': '有効', 'proxyDisabled': '無効', 'clearFilters': 'フィルターをクリア',
      'appName': 'Cloudflare DNS Manager', 'domains': 'ドメイン', 'settings': '設定', 'searchDomain': 'ドメインを検索...', 'searchRecord': 'レコードを検索...', 'noDomains': 'ドメインが見つかりません。', 'noDomainsSearch': '検索に一致するドメインはありません。', 'noRecords': 'レコードが見つかりません。', 'configureToken': 'トークンを設定', 'tokenNotConfigured': 'トークンが設定されていません。設定を開いてください。', 'domainsLoadError': 'ドメインの読み込みエラー：{error}', 'partialDomainsError': '一部のドメインは読み込まれましたが、エラーが発生しました：{error}', 'apiToken': 'Cloudflare API トークン', 'test': 'テスト', 'save': '保存', 'tokenSaved': 'トークンを保存しました！', 'connectionSuccess': '接続に成功しました！', 'connectionFailed': '接続に失敗しました。トークンが無効です。', 'appTheme': 'アプリのテーマ', 'themeDescription': '固定テーマを選択するか、システムテーマを自動的に使用します。', 'systemTheme': 'システムテーマを使用', 'light': 'ライト', 'dark': 'ダーク', 'language': '言語', 'languageDescription': 'アプリの言語を選択するか、システム言語を使用します。', 'systemLanguage': 'システム言語を使用', 'portuguese': 'ポルトガル語', 'english': '英語', 'french': 'フランス語', 'spanish': 'スペイン語', 'chineseSimplified': '簡体字中国語', 'japanese': '日本語', 'dnsTypes': 'DNS レコードの種類', 'dnsTypesDescription': 'アプリが読み込み・表示する DNS 種類を選択してください：', 'atLeastOneType': '少なくとも 1 種類のレコードが必要です。', 'changePassword': 'アプリのパスワードを変更', 'currentPassword': '現在のパスワード', 'newPassword': '新しいパスワード', 'confirmNewPassword': '新しいパスワードを確認', 'password': 'パスワード', 'confirmPassword': 'パスワードを確認', 'updatePassword': 'パスワードを更新', 'passwordIncorrect': '現在のパスワードが正しくありません！', 'passwordEmpty': 'パスワードは空にできません。', 'newPasswordEmpty': '新しいパスワードは空にできません！', 'passwordMismatch': 'パスワードが一致しません。', 'passwordMismatchExclaim': 'パスワードが一致しません！', 'passwordUpdated': 'パスワードを更新しました！', 'about': 'アプリについて', 'viewChangelog': 'バージョン履歴を表示', 'versionHistory': 'バージョン履歴', 'changelogLoadError': '変更履歴を読み込めません。\n詳細：{error}', 'unableOpenLink': 'リンクを開けません。', 'credentialsInvalid': '認証情報が無効です！', 'biometricReason': 'DNS ドメインを管理するために認証してください', 'loginBiometric': '生体認証でログイン', 'usePassword': '代わりにパスワードを使用', 'login': 'ログイン', 'createPassword': 'パスワードを作成', 'saveAndLogin': '保存してログイン', 'error': 'エラー：{error}', 'updateError': '更新エラー：{error}', 'deleteError': '削除エラー：{error}', 'purgeCache': 'CDN キャッシュを削除', 'purgeConfirmTitle': 'CDN キャッシュ削除の確認', 'purgeConfirmMessage': 'キャッシュを削除すると、一時的にサイトが遅くなる場合があります。続行しますか？', 'cancel': 'キャンセル', 'purge': '削除', 'cachePurged': 'CDN キャッシュを削除しました。', 'purgeError': 'CDN キャッシュ削除エラー：{error}', 'newRecord': '新しいレコード', 'editRecord': 'レコードを編集', 'type': '種類', 'nameSubdomain': '名前（サブドメイン）', 'content': '内容（IP または宛先）', 'proxied': 'プロキシ', 'recordSave': '保存', 'deleteConfirmTitle': '削除の確認', 'deleteRecord': 'レコード {name} を削除しますか？', 'delete': '削除',
    },
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();
  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((supported) => supported.languageCode == locale.languageCode);
  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);
  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
