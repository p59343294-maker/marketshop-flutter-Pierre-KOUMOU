# Mini E-Commerce Flutter

Application Flutter complète de mini e-commerce utilisant FakeStoreAPI.

## Fonctionnalités

- **Catalogue** : grille 2 colonnes, filtre par catégorie, chargement/erreur
- **Détail produit** : image, description, note, sélecteur quantité, ajout panier
- **Panier** : liste des articles, modification quantité, suppression, total
- **Commande** : formulaire livraison, validation, récapitulatif, confirmation
- **Historique** : liste des commandes, détail par commande
- **Profil** : édition infos, mode sombre, vider données

## Structure du projet

```
lib/
├── main.dart
├── data/
│   ├── api_service.dart
│   ├── database_helper.dart
│   ├── models/
│   │   ├── product.dart
│   │   ├── cart_item.dart
│   │   ├── order.dart
│   │   └── user_profile.dart
│   └── repositories/
│       ├── cart_repository.dart
│       ├── order_repository.dart
│       └── profile_repository.dart
├── screens/
│   ├── catalogue_screen.dart
│   ├── product_detail_screen.dart
│   ├── cart_screen.dart
│   ├── checkout_screen.dart
│   ├── history_screen.dart
│   ├── order_detail_screen.dart
│   └── profile_screen.dart
├── widgets/
│   ├── product_card.dart
│   └── cart_line.dart
├── providers/
│   ├── catalogue_provider.dart
│   ├── cart_provider.dart
│   ├── order_provider.dart
│   └── profile_provider.dart
├── theme/
│   └── app_theme.dart
└── navigation/
    └── app_router.dart
```

## Installation

### Prérequis
- Flutter SDK >= 3.10.0
- Dart SDK >= 3.0.0
- Android Studio ou VS Code avec plugin Flutter

### Lancer le projet

```bash
# Cloner / extraire le projet
cd mini_ecommerce

# Installer les dépendances
flutter pub get

# Lancer sur émulateur ou appareil
flutter run
```

### Permissions Android
Le fichier `android/app/src/main/AndroidManifest.xml` doit contenir :
```xml
<uses-permission android:name="android.permission.INTERNET" />
```
(déjà présent par défaut dans les projets Flutter)

## Technologies utilisées

| Bibliothèque | Usage |
|---|---|
| `http` | Appels API REST (FakeStoreAPI) |
| `sqflite` | Persistance locale (panier, commandes, profil) |
| `provider` | Gestion d'état réactive |
| `cached_network_image` | Chargement et cache des images produit |
| `go_router` | Navigation déclarative (ShellRoute + routes imbriquées) |
| `intl` | Formatage des dates (fr_FR) et des prix |

## API utilisée

**FakeStoreAPI** : https://fakestoreapi.com

- `GET /products` — liste tous les produits
- `GET /products/{id}` — détail d'un produit
- `GET /products/categories` — liste des catégories
- `GET /products/category/{nom}` — produits par catégorie

## Architecture

L'application suit le pattern **Provider + Repository** :

- **Providers** : gèrent l'état de l'UI et coordonnent les repositories
- **Repositories** : accèdent à la base de données locale (sqflite)
- **ApiService** : effectue les appels HTTP vers FakeStoreAPI
- **DatabaseHelper** : singleton gérant la connexion sqflite

La navigation utilise `go_router` avec un `ShellRoute` pour la Bottom Navigation Bar, et des routes racines pour les écrans de navigation contextuelle (détail produit, commande, détail commande).
