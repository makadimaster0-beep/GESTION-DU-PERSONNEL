# Dossiers du personnel — version base de données (Supabase)

## Fichiers
- `index.html` : l'application complète (un seul fichier), déjà reliée à votre projet Supabase.
- `supabase_schema.sql` : la table et les règles de sécurité à créer dans Supabase.
- `LISEZ-MOI.md` : ce guide.

## Mise en route (5 minutes)
1. Supabase > **SQL Editor** > **New query** : collez `supabase_schema.sql` > **Run**.
2. Supabase > **Authentication** > **Providers** > **Email** : désactivez **Confirm email**
   (sinon les nouveaux comptes devront d'abord confirmer une adresse e-mail, que l'application n'utilise pas).
3. Ouvrez `index.html` (double-clic) ou déposez-le sur un hébergement statique (Netlify, GitHub Pages, serveur de l'organisation).
4. Cliquez sur **Créer un compte** : le premier compte devient **Administrateur**.
   Les comptes suivants sont « Vérificateur » par défaut ; l'administrateur change les rôles dans *Utilisateurs et rôles*.

## Comment ça marche
- La connexion passe par Supabase Auth. L'identifiant saisi devient `identifiant@rhdossiers.com` en interne
  (vous pouvez aussi saisir une vraie adresse e-mail).
- Toute la base de l'application est enregistrée dans une ligne JSON de la table `rh_store`.
  Chaque modification est envoyée après ½ seconde ; l'application vérifie toutes les 6 secondes si quelqu'un d'autre a modifié les données.
- Résultat : le message « nouvelle demande de validation » arrive bien au vérificateur **sur un autre ordinateur**.
- Une copie locale reste dans le navigateur (cache).

## Sécurité — à lire
- La clé `sb_publishable_…` est faite pour être visible dans le navigateur. La protection vient de la sécurité par ligne (RLS) du fichier SQL
  et de la connexion. N'ajoutez **jamais** de clé `sb_secret_…` ou `service_role` dans `index.html`.
- Tout compte créé dans Supabase peut lire la base : les rôles de l'application (Opérateur, Vérificateur…) limitent l'interface, pas la base.
  Si vous ne voulez pas d'inscription libre, créez les comptes puis désactivez **Allow new users to sign up** dans Supabase > Authentication > Sign In / Providers.
- Les pièces numérisées et photos sont stockées dans la même ligne JSON : gardez-les légères (1,5 Mo max chacune).

## Limites connues
- Deux personnes qui enregistrent en même temps : la seconde reçoit « Modification simultanée détectée », ses données sont rechargées et elle refait son action.
- Pour un grand volume (milliers d'agents, nombreux scans), il faudra passer à des tables séparées et à Supabase Storage.
- Cette version n'a pas pu être testée contre votre projet depuis mon environnement (pas d'accès réseau) : faites un essai avec deux comptes avant l'usage réel.
