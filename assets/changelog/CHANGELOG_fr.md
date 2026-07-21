# Journal des modifications

Projet sur GitHub : [https://github.com/Tacioandrade/cloudflare-update-dns/](https://github.com/Tacioandrade/cloudflare-update-dns/)

Toutes les modifications notables de ce projet seront documentées dans ce fichier.

## [2.0.2] - 2026-07-20
### Ajouté
- Ajout d’une vérification quotidienne des nouvelles versions via GitHub Releases au démarrage de l’application sous Linux et Windows, avec une option pour la désactiver dans les Paramètres.

## [2.0.1] - 2026-07-19
### Ajouté
- Ajout de filtres combinables par type d’enregistrement DNS et état du proxy dans l’écran des enregistrements, à partir des types activés dans les Paramètres.

## [2.0.0] - 2026-07-14
### Ajouté / Modifié
- La liste des domaines est désormais affichée progressivement, dès que chaque domaine est reçu de l’API Cloudflare, sans attendre la fin du chargement de toutes les pages.
- Ajout de la prise en charge du portugais, de l’anglais, du français, de l’espagnol, du chinois simplifié et du japonais, avec sélection persistante de la langue et détection de la langue du système.
- L’historique des versions est désormais affiché dans la langue choisie dans l’application.

## [1.1.4] - 2026-06-27
### Ajouté / Modifié
- Le projet a été renommé de Cloudflare Update DNS en Cloudflare DNS Manager.
- Ajout du raccourci clavier `Ctrl + N` pour ouvrir la création d’un nouvel enregistrement DNS.

## [1.1.3] - 2026-06-26
### Corrigé
- Correction d’un problème d’exécution dans la version Windows lié à l’absence de Microsoft Visual C++ Runtime.
- Correction des paramètres CI/CD du projet afin de publier uniquement le journal de la version actuelle et d’empaqueter les bundles Windows et Linux dans le dossier `cloudflare-update-dns`.

## [1.1.2] - 2026-06-26
### Ajouté / Corrigé
- Ajout de la validation du contenu saisi lors de la création et de la modification des enregistrements DNS.
- Validation IPv4 pour les enregistrements `A` et IPv6 pour les enregistrements `AAAA`.
- Validation du format de domaine pour les enregistrements `CNAME`, `MX` et `NS`, sans dépendre d’une liste fixe de TLD.
- Validation du format de base des enregistrements `SRV` et du contenu non vide des enregistrements `TXT`.
- Correction de la validation des domaines afin de refuser les adresses IP saisies dans les enregistrements `CNAME`, `MX`, `NS` et dans la cible `SRV`.
- Correction de la création des enregistrements `TXT` tels que DMARC et DKIM en supprimant l’envoi incorrect du champ `proxied` pour les types qui ne peuvent pas être mis en proxy.
- Le contrôle `Proxied` apparaît désormais uniquement pour les enregistrements `A`, `AAAA` et `CNAME`.
- Ajustement du message d’erreur affiché lorsque l’API Cloudflare refuse la création ou la mise à jour d’un enregistrement.
- Activation du CI/CD du projet afin de générer automatiquement les applications Windows et Linux.

## [1.1.1] - 2026-06-25
### Ajouté / Corrigé
- À l’ouverture de l’application, le focus du clavier est placé sur le champ du mot de passe ou de la biométrie, selon le type d’authentification configuré.
- Ajout du raccourci clavier `Ctrl + F` pour ouvrir rapidement la recherche dans les listes de domaines et d’enregistrements DNS.
- Ajout du raccourci clavier `ESC` pour fermer rapidement la fonction de recherche.
- Ajout du raccourci clavier `ESC` pour fermer rapidement l’écran de création/modification d’un enregistrement DNS.
- Ajout du raccourci clavier `ESC` pour revenir à la liste des domaines depuis l’écran de création/modification d’un enregistrement DNS ou des paramètres.
- Mise en place de la connexion automatique lors de l’appui sur `Enter` dans le champ du mot de passe de l’écran de connexion.
- Mise en place de l’enregistrement automatique de l’enregistrement DNS lors de l’appui sur `Enter` dans les champs du sous-domaine et du contenu pendant la création/modification.

## [1.1.0] - 2026-06-25
### Ajouté
- Ajout de la documentation et du processus de compilation/tests pour la version Windows.
- Ajout de la documentation et du processus de compilation/tests pour la version Linux.
### Sécurité
- Le stockage du Token API Cloudflare utilise désormais `flutter_secure_storage`, avec le stockage sécurisé natif de chaque plateforme.
- Le mot de passe de l’application est désormais stocké sous forme de hash PBKDF2-HMAC-SHA256 avec un sel aléatoire dans le stockage sécurisé, supprimant sa conservation en texte clair.
- La session authentifiée est conservée uniquement en mémoire, imposant une nouvelle connexion à la réouverture de l’application.
- Seuls les paramètres non sensibles, comme le thème et les types d’enregistrements DNS, sont conservés dans `shared_preferences`.

## [1.0.8] - 2026-06-24
### Corrigé
- Déconnexion forcée de l’application lors de sa fermeture et de sa réouverture, imposant une nouvelle connexion sur tous les systèmes d’exploitation.

## [1.0.7] - 2026-06-24
### Ajouté / Corrigé
- Ajout de la prise en charge des thèmes clair et sombre avec détection automatique du thème configuré dans le système d’exploitation.
- Ajout d’une option dans les Paramètres pour choisir le thème système, clair ou sombre.
- Ajout de la localisation native de Flutter afin d’afficher les textes internes, tels que copier, coller et tout sélectionner, dans la langue de l’appareil.

## [1.0.6] - 2026-06-24
### Ajouté / Corrigé
- Ajout de la fonction de purge du cache CDN pour la zone sélectionnée dans l’écran des enregistrements DNS.
- Documentation des autorisations nécessaires pour utiliser la purge du cache CDN avec un Token Cloudflare personnalisé.

## [1.0.5] - 2026-06-24
### Ajouté / Corrigé
- Modification du premier accès afin d’ouvrir directement l’écran de création du mot de passe, sans exiger de mot de passe par défaut ni de biométrie.
- Suppression du champ utilisateur de l’écran de connexion ; l’accès s’effectue désormais uniquement avec le mot de passe enregistré ou la biométrie.

## [1.0.4] - 2026-06-19
### Ajouté / Corrigé
- Ajout d’un sélecteur de types d’enregistrements DNS dans les Paramètres afin de filtrer les enregistrements chargés par le système.
- Ajout d’un écran de consultation du journal des modifications directement dans l’application.

## [1.0.3] - 2026-06-19
### Ajouté / Corrigé
- Mise en place de la connexion biométrique native (Empreinte digitale / Reconnaissance faciale) avec fallback transparent et automatique.
- Ajustement de la modification des domaines DNS pour permettre de modifier uniquement le sous-domaine de l’enregistrement.

## [1.0.2] - 2026-06-18
### Ajouté / Corrigé
- Correction de la logique d’intégration à l’API afin d’effectuer une pagination automatique. L’application récupère désormais tous les domaines et enregistrements DNS accessibles au token, en contournant la limite par défaut de Cloudflare de 20 enregistrements par page.
- Ajustements fins de l’interface et de l’identité visuelle.
- Mise en place d’un nouveau logo et génération d’icônes standardisées (Android, iOS et Web).

## [1.0.1] - 2026-06-18
### Corrigé
- Résolution des problèmes de compatibilité et correction du code pour la compilation Android native.
- Ajustement des versions de Kotlin et de la configuration du NDK pour une compilation fiable.
- Modification de l’identifiant du paquet (Application ID), de la valeur d’exemple vers la signature officielle de l’entreprise.

## [1.0.0] - Version Initiale
### Ajouté
- Version de base du système.
- Gestion complète des enregistrements DNS via l’API Cloudflare.
- Possibilité d’exécuter l’application localement dans le navigateur ou de la conditionner pour Android avec Flutter.
- Mode sombre dynamique et interface moderne.
