[Português](README.md) | [English](README.en.md) | [Français](README.fr.md) | [Español](README.es.md) | [简体中文](README.zh.md) | [日本語](README.ja.md)

# Cloudflare DNS Manager

A Flutter application for managing DNS records through the Cloudflare API.

This README contains information shared by all platforms. For build commands, tests, and platform-specific details, see [Android](README-Android.md), [Linux](README-Linux.md), and [Windows](README-Windows.md).

## Features

- Local password authentication and biometric login on supported platforms.
- Automatic logout when the application is closed and reopened.
- Domain listing with active, pending, and inactive statuses.
- Configurable DNS record editor, real-time Cloudflare proxy toggle, and CDN cache purge.
- Cloudflare API token configuration and validation.
- Light, dark, or system theme; Portuguese, English, French, Spanish, Simplified Chinese, and Japanese UI.
- Localized in-app version history.

## Access and security

On first use, create an application password. Each new application session requires authentication. The session exists only in memory; the password is stored as a PBKDF2-HMAC-SHA256 hash with a random salt in secure platform storage. The Cloudflare token is also stored securely. Theme and DNS settings are stored in normal local preferences.

## Cloudflare API token

1. Sign in to the application.
2. Open **Settings**.
3. Paste your [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens).
4. Select **Test**, then **Save**.

For CDN cache purging, create a custom token with **Zone / Cache Purge / Purge** and **Zone / DNS / Edit** permissions.

## Architecture

- Flutter / Dart; `shared_preferences` for non-sensitive local state.
- `flutter_secure_storage` for secrets; `local_auth` for biometric authentication.
- `http` for network communication and `url_launcher` for external links.

## Known issue

Windows requires Microsoft Visual C++ Redistributable 2015–2022. Install it from [Microsoft’s official download page](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist) if `MSVCP140.dll`, `VCRUNTIME140.dll`, or `VCRUNTIME140_1.dll` is missing.

## License

MIT
