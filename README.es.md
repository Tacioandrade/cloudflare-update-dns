[Português](README.md) | [English](README.en.md) | [Français](README.fr.md) | [Español](README.es.md) | [简体中文](README.zh.md) | [日本語](README.ja.md)

# Cloudflare DNS Manager

Aplicación Flutter para administrar registros DNS mediante la API de Cloudflare.

Este README contiene la información común. Consulta las guías de [Android](README-Android.md), [Linux](README-Linux.md) y [Windows](README-Windows.md) para compilación, pruebas y detalles específicos.

## Funcionalidades

- Autenticación local con contraseña y biometría en plataformas compatibles.
- Cierre de sesión automático al cerrar y volver a abrir la aplicación.
- Lista de dominios y editor de registros DNS configurables.
- Interruptor de proxy Cloudflare, purga de caché CDN y validación del token API.
- Tema claro, oscuro o del sistema; interfaz en portugués, inglés, francés, español, chino simplificado y japonés.
- Historial de versiones localizado dentro de la aplicación.

## Acceso y seguridad

En el primer acceso crea una contraseña. Cada nueva sesión requiere autenticación. La sesión solo permanece en memoria; la contraseña se guarda como hash PBKDF2-HMAC-SHA256 con una sal aleatoria en almacenamiento seguro. El token de Cloudflare también se almacena de forma segura. El tema y la configuración DNS se guardan en preferencias locales comunes.

## Token de API de Cloudflare

1. Inicia sesión en la aplicación.
2. Abre **Configuración**.
3. Pega tu [token de API de Cloudflare](https://dash.cloudflare.com/profile/api-tokens).
4. Selecciona **Probar** y luego **Guardar**.

Para purgar la caché CDN, crea un token personalizado con permisos **Zone / Cache Purge / Purge** y **Zone / DNS / Edit**.

## Arquitectura

- Flutter / Dart y `shared_preferences` para estado local no sensible.
- `flutter_secure_storage` para secretos, `local_auth` para biometría, `http` y `url_launcher`.

## Problema conocido

Windows requiere Microsoft Visual C++ Redistributable 2015–2022. Instálalo desde la [página oficial de Microsoft](https://learn.microsoft.com/es-es/cpp/windows/latest-supported-vc-redist) si falta alguna DLL.

## Licencia

MIT
