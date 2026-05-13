# Narsingh Kitchen

**A multi-service food platform: fast food, tiffin, and spices—unified in one Flutter app under the FoodieExpress experience.**

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Android](https://img.shields.io/badge/Android-3DDC84?style=for-the-badge&logo=android&logoColor=white)
![Web](https://img.shields.io/badge/Web-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white)
![Material 3](https://img.shields.io/badge/Material%20Design%203-6200EE?style=for-the-badge&logo=materialdesign&logoColor=white)

---

## Overview

Narsingh Kitchen is a production-oriented Flutter client for **FoodieExpress**, a food and grocery experience that brings **fast food ordering**, **tiffin subscription services**, and a **spices e-commerce** catalog into a single, consistent product. The app is intended for **end customers** who want to discover items, customize products, and move through authentication and checkout-style flows in one place. The codebase follows a **feature-based layout** so each domain (splash, onboarding, auth, catalog, cart) stays isolated and easier to evolve. UI is built with **Material 3**, **Google Fonts (Poppins)**, and layouts tuned for **scroll safety** on narrow viewports and **Flutter Web**. The stack uses **sound null safety** throughout and targets **Android** and **Web** from one project.

---

## Features

### Core Features

- 🍔 **Fast Food Ordering** — Browse categorized fast-food items with search and grid listings.
- 🍱 **Tiffin Subscription Plans** — Explore daily menus and monthly or one-time style subscription cards.
- 🌶️ **Spices Store** — Filter-oriented spice catalog with promotional highlights.
- 📦 **Product Detail Customization** — Sizes, optional add-ons, quantity, and add-to-cart CTAs.
- 🛒 **Cart & Order Summary** — Line items with quantity controls, promo entry, and priced summary.
- 📱 **OTP Verification** — Six-digit OTP entry with timed resend UX.
- 🧭 **Bottom Navigation System** — Shell with Home, Saved, Cart, Orders, and Profile destinations.
- ✨ **Smooth Onboarding** — Three-page onboarding with pager-style progression.

### UI/UX Highlights

- **Modern Material 3 Design** — Theming aligned with Material 3 components and typography.
- **Category-based Dynamic Theming** — Accent colors by vertical (red / orange / brown lanes).
- **Soft Shadows & Rounded Cards** — Elevated surfaces with controlled radius and elevation.
- **Responsive Layout** — Adaptive use of scroll views, stacks, and safe areas for mobile and Web.
- **Scroll-safe Layouts** — Reduced overflow risk via `SafeArea`, `SingleChildScrollView`, and constrained lists.
- **Reusable Components** — Shared buttons, fields, cards, section headers, and steppers under `core/widgets`.

---

## Tech Stack

| Layer | Choice |
|--------|--------|
| Framework | Flutter (latest stable SDK in `pubspec.yaml`) |
| Language | Dart (null-safe) |
| UI | Material 3 |
| Typography | Google Fonts — **Poppins** |
| UX Polish | Smooth Page Indicator |
| Structure | Feature-based folders under `lib/features` |
| Safety | Null safety enforced |
| Targets | Cross-platform — **Android** & **Web** |

---

## Folder Structure

```
lib/
├── main.dart
├── core/
│   ├── theme/
│   │   └── app_theme.dart
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_routes.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_textfield.dart
│       ├── section_title.dart
│       ├── category_card.dart
│       ├── product_card.dart
│       └── quantity_stepper.dart
├── features/
│   ├── splash/
│   ├── onboarding/
│   ├── auth/
│   ├── home/
│   ├── fast_food/
│   ├── tiffin/
│   ├── spices/
│   ├── cart/
│   └── product/
└── ...
```

| Area | Purpose |
|------|---------|
| **`main.dart`** | Application entry, `MaterialApp`, route table, theme binding. |
| **`core/theme`** | Central `ThemeData`: colors, typography base, component themes. |
| **`core/constants`** | Shared tokens: palette, strings, route path constants (`AppRoutes`). |
| **`core/widgets`** | Design-system primitives reused across features. |
| **`features/*`** | One folder per capability; each owns its screens and local UI composition. |

---

## Design System

| Topic | Specification |
|--------|----------------|
| **Brand palette** | **Primary Red** (`#D32F2F`) — primary CTAs and food lane. **Primary Orange** (`#F57C00`) — tiffin lane. **Primary Brown** (`#8D4E1F`) — spices lane. Supporting neutrals for text, dividers, and backgrounds. |
| **Border radius** | Cards ~20px; buttons ~16px; hero bottoms ~30px; pills/chips highly rounded (~50 logical radius where used); fields ~14px; image clips ~16px via `ClipRRect` where applicable. |
| **Shadow** | Unified soft elevation: black at low opacity, `blurRadius` ~20, vertical offset ~10 — applied via shared shadow helpers on cards and elevated surfaces. |
| **Typography** | **Poppins** throughout via `GoogleFonts`; hierarchy from display-style headings down to captions; weights differentiate titles vs. supporting copy. |
| **Spacing** | Horizontal page gutters ~20; section gaps ~24; tight spacing ~8–16 between related controls; primary buttons target ~56px height for touch targets. |

---

## Screens Overview

- 🚀 **Splash Screen** — Brand reveal on a branded background with timed navigation into onboarding.
- 📖 **Onboarding (3 pages)** — Value props for fast food, tiffin, and spices with pager progression and indicators.
- 🔑 **Sign In** — Hero header, credentials, alternate entry affordances, and navigation to registration.
- ✏️ **Sign Up** — Account fields, role-style selection between customer-oriented flows and admin labeling, routing toward OTP.
- ✅ **OTP Verification** — Six single-digit fields with focus chaining and resend countdown behavior.
- 🏠 **Home Dashboard** — Greeting, categories, horizontally scrolling highlights, and promotional banners.
- 🍔 **Fast Food Listing** — Filter chips, search, and two-column product grid with detail navigation.
- 🍱 **Tiffin Service** — Subscription toggle, today’s menu card, plan cards, and delivery window summary.
- 🌶️ **Spices Store** — Brown-themed header, filters, promo strip, grid catalog, and floating action affordance.
- 🛒 **Cart Screen** — Cart lines with quantity steppers, promo row, financial summary, and checkout CTA.
- 📄 **Product Detail Screen** — Hero presentation, meta row, tab-style sections, customization, and sticky add-to-cart bar.

---

## Installation Guide

### Prerequisites

- Flutter SDK (stable channel recommended)
- Android Studio or Visual Studio Code with Flutter / Dart extensions
- Chrome (for Web debugging and release smoke tests)

### Clone Repository

```bash
git clone <repo-url>
cd narsingh_kitchen
```

### Install Dependencies

```bash
flutter pub get
```

### Run on Chrome

```bash
flutter run -d chrome
```

### Run on Android

```bash
flutter run
```

---

## Build APK

Generate a release APK for distribution or device testing:

```bash
flutter build apk --release
```

Output artifact:

`build/app/outputs/flutter-apk/app-release.apk`

---

## Architecture Explanation

The project uses **feature-based architecture**: each capability under `lib/features` owns its screens and composition while relying on **`core`** for shared concerns. **Reusable widgets** encapsulate buttons, inputs, cards, and steppers so presentation stays consistent and duplicated layout logic stays minimal. **`AppTheme`** centralizes **ThemeData** so colors, shapes, and text styles propagate from one place. **`AppRoutes`** defines **named routes** consumed by `MaterialApp.routes`, keeping navigation strings consistent and easing future integration with generated routes or deep links. This separation scales cleanly when adding **REST or Firebase** backends: models and repositories can land in `core` or per-feature `data` layers without rewriting UI folders.

---

## Future Improvements

- Backend integration (**Firebase**, **REST APIs**) for catalog, auth, and orders.
- Payment gateway (**Razorpay** / **Stripe**) with secure checkout flows.
- **Admin panel** for menus, subscriptions, and inventory.
- **Push notifications** for order status and promotions.
- **Live order tracking** with maps or timeline UI.
- **Dark mode** theme variant aligned with the same design tokens.
- **Rich domain models** and serialization (`freezed`, `json_serializable`) as APIs stabilize.

---

## Contributing

Contributors are welcome. Fork this repository, create a **feature branch** from `main`, implement changes with clear commits, and open a **pull request** describing scope, screenshots for UI changes, and any breaking navigation or dependency updates. Follow existing formatting and run `flutter analyze` before submitting.

---

## License

This project is licensed under the **MIT License**.

```
MIT License

Copyright (c) Narsingh Kitchen contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

Built with ❤️ by [Amritesh Kumar](https://github.com/amritesh-0) & OM Mishra