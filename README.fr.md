[Português](README.md) | [English](README.en.md) | [Français](README.fr.md) | [Español](README.es.md) | [简体中文](README.zh.md) | [日本語](README.ja.md)

# Cloudflare DNS Manager

Application Flutter de gestion des enregistrements DNS via l’API Cloudflare.

Ce README contient les informations communes. Consultez les guides [Android](README-Android.md), [Linux](README-Linux.md) et [Windows](README-Windows.md) pour la compilation, les tests et les détails propres à chaque plateforme.

## Fonctionnalités

- Authentification locale par mot de passe et biométrie sur les plateformes compatibles.
- Déconnexion automatique après fermeture et réouverture de l’application.
- Liste des domaines et éditeur d’enregistrements DNS configurables.
- Bascule du proxy Cloudflare, purge du cache CDN et validation du jeton API.
- Thème clair, sombre ou système ; interface en portugais, anglais, français, espagnol, chinois simplifié et japonais.
- Historique des versions localisé dans l’application.

## Accès et sécurité

Lors de la première utilisation, créez un mot de passe. Chaque nouvelle session nécessite une authentification. La session reste uniquement en mémoire ; le mot de passe est stocké sous forme de hachage PBKDF2-HMAC-SHA256 avec un sel aléatoire dans le stockage sécurisé. Le jeton Cloudflare y est aussi stocké. Le thème et les réglages DNS utilisent les préférences locales ordinaires.

## Jeton API Cloudflare

1. Connectez-vous à l’application.
2. Ouvrez **Paramètres**.
3. Collez votre [jeton API Cloudflare](https://dash.cloudflare.com/profile/api-tokens).
4. Sélectionnez **Tester**, puis **Enregistrer**.

Pour purger le cache CDN, créez un jeton personnalisé avec les permissions **Zone / Cache Purge / Purge** et **Zone / DNS / Edit**.

## Architecture

- Flutter / Dart ; `shared_preferences` pour les données non sensibles.
- `flutter_secure_storage` pour les secrets, `local_auth` pour la biométrie, `http` et `url_launcher`.

## Problème connu

Windows requiert Microsoft Visual C++ Redistributable 2015–2022. Installez-le depuis la [page officielle Microsoft](https://learn.microsoft.com/fr-fr/cpp/windows/latest-supported-vc-redist) si une DLL est manquante.

## Licence

MIT
