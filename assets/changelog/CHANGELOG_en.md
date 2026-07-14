# Changelog

Project on GitHub: [https://github.com/Tacioandrade/cloudflare-update-dns/](https://github.com/Tacioandrade/cloudflare-update-dns/)

All notable changes to this project will be documented in this file.

## [2.0.0] - 2026-07-14
### Added / Changed
- The domain list is now displayed progressively, as soon as each domain is received from the Cloudflare API, without waiting for all pages to finish loading.
- Added support for Portuguese, English, French, Spanish, Simplified Chinese, and Japanese, with persistent language selection and system language detection.
- Version history is now displayed in the language selected in the application.

## [1.1.4] - 2026-06-27
### Added / Changed
- Renamed the project from Cloudflare Update DNS to Cloudflare DNS Manager.
- Added the `Ctrl + N` keyboard shortcut to open the creation of a new DNS record.

## [1.1.3] - 2026-06-26
### Fixed
- Fixed a runtime bug in the Windows version related to the absence of the Microsoft Visual C++ Runtime.
- Fixed the project's CI/CD settings to publish only the changelog for the current version and package the Windows and Linux bundles inside the `cloudflare-update-dns` folder.

## [1.1.2] - 2026-06-26
### Added / Fixed
- Added validation of the content entered when creating and editing DNS records.
- Added IPv4 validation for `A` records and IPv6 validation for `AAAA` records.
- Added domain format validation for `CNAME`, `MX`, and `NS` records, without relying on a fixed TLD list.
- Added basic format validation for `SRV` records and non-empty content validation for `TXT` records.
- Fixed domain validation to reject IP addresses entered in `CNAME`, `MX`, `NS`, and `SRV` target fields.
- Fixed the creation of `TXT` records such as DMARC and DKIM by removing the improper submission of the `proxied` field for record types that cannot be proxied.
- The `Proxied` control is now displayed only for `A`, `AAAA`, and `CNAME` records.
- Adjusted the error message displayed when the Cloudflare API rejects the creation or update of a record.
- Enabled the project's CI/CD to automatically generate Windows and Linux applications.

## [1.1.1] - 2026-06-25
### Added / Fixed
- When the application opens, keyboard focus is placed on the password or biometric field, depending on the configured authentication type.
- Added the `Ctrl + F` keyboard shortcut to quickly open search in the domain and DNS record lists.
- Added the `ESC` keyboard shortcut to quickly close the search feature.
- Added the `ESC` keyboard shortcut to quickly close the DNS record creation/editing screen.
- Added the `ESC` keyboard shortcut to return to the domain list when on the DNS record creation/editing or settings screen.
- Implemented automatic login when the `Enter` key is pressed in the password field on the login screen.
- Implemented automatic saving of the DNS record when the `Enter` key is pressed in the subdomain and content fields during creation/editing.

## [1.1.0] - 2026-06-25
### Added
- Added documentation and build/test workflows for the Windows version.
- Added documentation and build/test workflows for the Linux version.
### Security
- Changed Cloudflare API Token storage to `flutter_secure_storage`, using each platform's native secure storage.
- Changed app password storage to a PBKDF2-HMAC-SHA256 hash with a random salt in secure storage, removing plaintext password persistence.
- Authentication sessions are now kept only in memory, requiring a new login when the application is reopened.
- Only non-sensitive settings, such as theme and DNS record types, are kept in `shared_preferences`.

## [1.0.8] - 2026-06-24
### Fixed
- Forced application logout when the app is closed and reopened, requiring a new login on all operating systems.

## [1.0.7] - 2026-06-24
### Added / Fixed
- Added support for light and dark themes with automatic detection of the operating system's configured theme.
- Added an option in Settings to choose between the system, light, or dark theme.
- Added Flutter native localization to display internal text, such as copy, paste, and select all, in the device language.

## [1.0.6] - 2026-06-24
### Added / Fixed
- Added CDN cache purge functionality for the selected zone on the DNS records screen.
- Documented the permissions required to use CDN cache purge with a custom Cloudflare Token.

## [1.0.5] - 2026-06-24
### Added / Fixed
- Changed first access to open the password creation screen directly, without requiring a default password or biometrics.
- Removed the username field from the login screen; access is now granted only with the registered password or biometrics.

## [1.0.4] - 2026-06-19
### Added / Fixed
- Added a DNS record type selector in Settings to filter which records the system loads.
- Added an in-app Changelog viewing screen.

## [1.0.3] - 2026-06-19
### Added / Fixed
- Implemented native biometric login support (Fingerprint / Facial recognition) with transparent and automatic fallback.
- Adjusted DNS domain editing to allow editing only the record's subdomain.

## [1.0.2] - 2026-06-18
### Added / Fixed
- Fixed the API integration logic to perform automatic pagination. The application now retrieves all domains and DNS records accessible to the token, bypassing Cloudflare's default limit of 20 records per page.
- Fine-tuned the interface and visual identity.
- Implemented a new logo and generated standardized icons (Android, iOS, and Web).

## [1.0.1] - 2026-06-18
### Fixed
- Resolved compatibility issues and fixed code for the native Android build.
- Adjusted Kotlin versions and NDK settings for reliable compilation.
- Changed the package identifier (Application ID) from the example default to the official corporate signature.

## [1.0.0] - Initial Release
### Added
- Basic system version.
- Complete DNS record management through the Cloudflare API.
- Ability to run locally in a browser or be packaged for Android using Flutter.
- Dynamic dark mode and modern interface.
