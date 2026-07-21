# Registro de cambios

Proyecto en GitHub: [https://github.com/Tacioandrade/cloudflare-update-dns/](https://github.com/Tacioandrade/cloudflare-update-dns/)

Todos los cambios destacables de este proyecto se documentarán en este archivo.

## [2.0.2] - 2026-07-20
### Añadido
- Se añadió una comprobación diaria de nuevas versiones mediante GitHub Releases al abrir la aplicación en Linux y Windows, con una opción para desactivarla en Configuración.

## [2.0.1] - 2026-07-19
### Añadido
- Se añadieron filtros combinables por tipo de registro DNS y estado del proxy en la pantalla de registros, utilizando los tipos habilitados en Configuración.

## [2.0.0] - 2026-07-14
### Añadido / Modificado
- La lista de dominios ahora se muestra progresivamente, tan pronto como cada dominio se recibe de la API de Cloudflare, sin esperar a que terminen todas las páginas.
- Se añadió compatibilidad con portugués, inglés, francés, español, chino simplificado y japonés, con selección persistente del idioma y detección del idioma del sistema.
- El historial de versiones ahora se muestra en el idioma seleccionado en la aplicación.

## [1.1.4] - 2026-06-27
### Añadido / Modificado
- Se cambió el nombre del proyecto de Cloudflare Update DNS a Cloudflare DNS Manager.
- Se añadió el atajo de teclado `Ctrl + N` para abrir la creación de un nuevo registro DNS.

## [1.1.3] - 2026-06-26
### Corregido
- Se corrigió un error de ejecución en la versión para Windows relacionado con la ausencia de Microsoft Visual C++ Runtime.
- Se corrigieron los ajustes de CI/CD del proyecto para publicar únicamente el registro de cambios de la versión actual y empaquetar los bundles de Windows y Linux dentro de la carpeta `cloudflare-update-dns`.

## [1.1.2] - 2026-06-26
### Añadido / Corregido
- Se añadió la validación del contenido introducido al crear y editar registros DNS.
- Se validan direcciones IPv4 para registros `A` e IPv6 para registros `AAAA`.
- Se valida el formato de dominio para registros `CNAME`, `MX` y `NS`, sin depender de una lista fija de TLD.
- Se valida el formato básico de los registros `SRV` y que el contenido de los registros `TXT` no esté vacío.
- Se corrigió la validación de dominios para rechazar direcciones IP introducidas en registros `CNAME`, `MX`, `NS` y en el destino de `SRV`.
- Se corrigió la creación de registros `TXT` como DMARC y DKIM, eliminando el envío incorrecto del campo `proxied` para tipos que no admiten proxy.
- El control `Proxied` ahora aparece únicamente para registros `A`, `AAAA` y `CNAME`.
- Se ajustó el mensaje de error que aparece cuando la API de Cloudflare rechaza la creación o actualización de un registro.
- Se activó el CI/CD del proyecto para generar automáticamente aplicaciones para Windows y Linux.

## [1.1.1] - 2026-06-25
### Añadido / Corregido
- Al abrir la aplicación, el foco del teclado se coloca en el campo de contraseña o biometría, según el tipo de autenticación configurado.
- Se añadió el atajo de teclado `Ctrl + F` para abrir rápidamente la búsqueda en las listas de dominios y registros DNS.
- Se añadió el atajo de teclado `ESC` para cerrar rápidamente la función de búsqueda.
- Se añadió el atajo de teclado `ESC` para cerrar rápidamente la pantalla de creación/edición de registros DNS.
- Se añadió el atajo de teclado `ESC` para volver a la lista de dominios desde la pantalla de creación/edición de registros DNS o de configuración.
- Se implementó el inicio de sesión automático al pulsar `Enter` en el campo de contraseña de la pantalla de inicio de sesión.
- Se implementó el guardado automático del registro DNS al pulsar `Enter` en los campos de subdominio y contenido durante la creación/edición.

## [1.1.0] - 2026-06-25
### Añadido
- Se añadió documentación y el flujo de compilación/pruebas para la versión de Windows.
- Se añadió documentación y el flujo de compilación/pruebas para la versión de Linux.
### Seguridad
- Se cambió el almacenamiento del Token de API de Cloudflare a `flutter_secure_storage`, utilizando el almacenamiento seguro nativo de cada plataforma.
- Se cambió el almacenamiento de la contraseña de la aplicación a un hash PBKDF2-HMAC-SHA256 con salt aleatorio en el almacenamiento seguro, eliminando la persistencia de la contraseña en texto plano.
- La sesión autenticada se mantiene únicamente en memoria, por lo que se requiere un nuevo inicio de sesión al volver a abrir la aplicación.
- En `shared_preferences` solo se conservan ajustes no sensibles, como el tema y los tipos de registros DNS.

## [1.0.8] - 2026-06-24
### Corregido
- Se forzó el cierre de sesión de la aplicación al cerrarla y volverla a abrir, exigiendo un nuevo inicio de sesión en todos los sistemas operativos.

## [1.0.7] - 2026-06-24
### Añadido / Corregido
- Se añadió compatibilidad con temas claro y oscuro, con detección automática del tema configurado en el sistema operativo.
- Se añadió una opción en Configuración para elegir entre el tema del sistema, claro u oscuro.
- Se añadió la localización nativa de Flutter para mostrar textos internos, como copiar, pegar y seleccionar todo, en el idioma del dispositivo.

## [1.0.6] - 2026-06-24
### Añadido / Corregido
- Se añadió la función de limpieza de la caché de la CDN para la zona seleccionada en la pantalla de registros DNS.
- Se documentaron los permisos necesarios para usar la limpieza de la caché de la CDN con un Token personalizado de Cloudflare.

## [1.0.5] - 2026-06-24
### Añadido / Corregido
- Se cambió el primer acceso para abrir directamente la pantalla de creación de contraseña, sin exigir una contraseña predeterminada ni biometría.
- Se eliminó el campo de usuario de la pantalla de inicio de sesión; ahora el acceso se realiza únicamente con la contraseña registrada o biometría.

## [1.0.4] - 2026-06-19
### Añadido / Corregido
- Se añadió un selector de tipos de registros DNS en Configuración para filtrar qué registros carga el sistema.
- Se añadió una pantalla para consultar el registro de cambios directamente en la aplicación.

## [1.0.3] - 2026-06-19
### Añadido / Corregido
- Se implementó compatibilidad nativa con el inicio de sesión mediante biometría (Huella digital / Reconocimiento facial), con fallback transparente y automático.
- Se ajustó la edición de dominios DNS para permitir editar únicamente el subdominio del registro.

## [1.0.2] - 2026-06-18
### Añadido / Corregido
- Se corrigió la lógica de integración con la API para realizar paginación automática. Ahora la aplicación obtiene todos los dominios y registros DNS a los que tiene acceso el token, evitando el límite predeterminado de Cloudflare de 20 registros por página.
- Se realizaron ajustes finos en la interfaz y la identidad visual.
- Se implementó un nuevo logotipo y se generaron iconos estandarizados (Android, iOS y Web).

## [1.0.1] - 2026-06-18
### Corregido
- Se resolvieron problemas de compatibilidad y se corrigió el código para la compilación nativa de Android.
- Se ajustaron las versiones de Kotlin y la configuración del NDK para una compilación segura.
- Se cambió el identificador del paquete (Application ID) del valor de ejemplo a la firma corporativa oficial.

## [1.0.0] - Lanzamiento Inicial
### Añadido
- Versión básica del sistema.
- Gestión completa de registros DNS mediante la API de Cloudflare.
- Capacidad de ejecutarse localmente en el navegador o empaquetarse para Android mediante Flutter.
- Modo oscuro dinámico e interfaz moderna.
