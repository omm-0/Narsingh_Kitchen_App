# Narsingh Kitchen — Project Documentation

**Version:** 1.0.0  
**Platform:** Flutter (Android · Web)  
**Status:** Development / Demo  
**Last Updated:** April 2026

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Tech Stack](#2-tech-stack)
3. [Architecture Overview](#3-architecture-overview)
4. [Project Scope](#4-project-scope)
5. [Folder Structure](#5-folder-structure)
6. [Design System](#6-design-system)
7. [Navigation & Routing](#7-navigation--routing)
8. [Data Models](#8-data-models)
9. [State Management](#9-state-management)
10. [Feature Breakdown](#10-feature-breakdown)
    - [10.1 Splash & Onboarding](#101-splash--onboarding)
    - [10.2 Authentication](#102-authentication)
    - [10.3 Home & Navigation Shell](#103-home--navigation-shell)
    - [10.4 Fast Food](#104-fast-food)
    - [10.5 Tiffin Service](#105-tiffin-service)
    - [10.6 Premium Spices](#106-premium-spices)
    - [10.7 Cart & Checkout](#107-cart--checkout)
11. [Cart Service & Pricing Logic](#11-cart-service--pricing-logic)
12. [Reusable Widget Library](#12-reusable-widget-library)
13. [Sample Data Catalogue](#13-sample-data-catalogue)
14. [Build & Run](#14-build--run)
15. [Known Limitations & Future Roadmap](#15-known-limitations--future-roadmap)

---

## 1. Project Overview

**Narsingh Kitchen** (app display name: *FoodieExpress*) is a multi-service food delivery platform built with Flutter. It unifies three verticals — fast food delivery, daily tiffin subscription, and premium spice retail — under a single, unified mobile and web experience.

| Property | Value |
|---|---|
| App Name | FoodieExpress |
| Tagline | Deliver · Tiffin · Spices |
| Footer Copy | Fresh. Fast. Flavourful. |
| Demo User | OM Mishra · Jaipur, Rajasthan |
| Min Flutter SDK | 3.10.4 |
| Null Safety | Enforced (sound null safety) |
| Material Design | Material 3 |

The application is built as an **offline-first demo**, meaning all data is sourced from in-memory dummy data and state management lives locally in a singleton service. It is designed with a clear separation of concerns so that a real backend (Firebase, REST, etc.) can be plugged in without restructuring the codebase.

---

## 2. Tech Stack

### Framework & Language

| Layer | Technology |
|---|---|
| Language | Dart 3.x |
| UI Framework | Flutter 3.10.4+ |
| Design System | Material 3 (`useMaterial3: true`) |
| Platform Targets | Android, Web |

### Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Core framework |
| `google_fonts` | ^6.2.1 | Poppins typeface across all UI |
| `smooth_page_indicator` | ^1.2.0+3 | Dot indicators on onboarding and splash |
| `cupertino_icons` | ^1.0.8 | iOS-style icon set (supplementary) |

### Dev Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter_test` | SDK | Widget and unit testing |
| `flutter_lints` | ^6.0.0 | Dart/Flutter lint rules |

### State Management Strategy

The app uses Flutter's built-in reactive primitive **`ChangeNotifier`** paired with **`ListenableBuilder`** widgets — no third-party state management library. This keeps dependencies minimal and makes the state flow explicit and easy to trace.

---

## 3. Architecture Overview

The project follows a **feature-first layered architecture**:

```
Presentation  →  Features (screens, widgets)
Business      →  Services (CartService, data logic)
Data          →  Models, DummyData
Core          →  Constants, Theme, Shared Widgets
```

Each feature is self-contained under `lib/features/{feature}/` and only communicates upward through shared services or models, never by directly importing sibling features. Cross-cutting concerns (colors, routes, strings, shared widgets) live under `lib/core/`.

There is no backend integration in the current version — all data is read from `lib/data/dummy_data.dart` and all transient state is held in `CartService.instance`.

---

## 4. Project Scope

### In Scope (v1.0 — Current)

- Splash screen with branding and animated indicators
- 3-page illustrated onboarding flow
- Email/password sign-in and sign-up UI
- 6-digit OTP verification screen with resend timer
- Bottom navigation shell (5 tabs)
- **Fast Food vertical:** product catalog grid, search, category filters, product detail with customization (size, add-ons), add to cart
- **Tiffin vertical:** today's meal card, tiffin detail, subscription plan selection (1M / 3M / 6M), delivery slot picker, monthly toggle
- **Spices vertical:** product grid, category filters, sort by price/rating, spice detail with weight selector, purity index, farm source
- Persistent shopping cart with line-item management (add, remove, update qty, swipe-to-delete)
- Promo code entry and validation (4 active codes)
- Order summary with itemized pricing (subtotal, delivery, promo discount, GST)
- Checkout screen with delivery address and payment method selection
- Order success screen with animated confirmation and generated order ID
- Consistent Hero animations between list → detail screens

### Out of Scope (v1.0)

- Real authentication (Firebase Auth, OAuth)
- Backend API integration
- Live payment processing
- Push notifications
- Dark mode
- Order history persistence
- Admin / restaurant dashboard
- Real-time order tracking

---

## 5. Folder Structure

```
narsingh_kitchen/
├── lib/
│   ├── main.dart                            # App entry, MaterialApp, named routes
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart             # Full color palette + shadow system
│   │   │   ├── app_routes.dart             # All named route string constants
│   │   │   └── app_strings.dart            # Copy strings (app name, tagline, etc.)
│   │   ├── theme/
│   │   │   └── app_theme.dart              # ThemeData (buttons, inputs, typography)
│   │   └── widgets/
│   │       ├── animated_quantity_stepper.dart
│   │       ├── category_card.dart
│   │       ├── custom_button.dart
│   │       ├── custom_textfield.dart
│   │       ├── product_card.dart
│   │       ├── quantity_stepper.dart
│   │       └── section_title.dart
│   │
│   ├── data/
│   │   ├── cart_service.dart               # Singleton cart, promo, pricing
│   │   └── dummy_data.dart                 # All static product/subscription data
│   │
│   ├── models/
│   │   ├── cart_item_model.dart
│   │   ├── product_model.dart              # ProductModel + ProductKind enum
│   │   └── subscription_model.dart
│   │
│   └── features/
│       ├── auth/
│       │   ├── otp_screen.dart
│       │   ├── sign_in_screen.dart
│       │   └── sign_up_screen.dart
│       ├── cart/
│       │   ├── cart_screen.dart
│       │   ├── checkout_screen.dart
│       │   └── order_success_screen.dart
│       ├── fast_food/
│       │   └── fast_food_screen.dart
│       ├── home/
│       │   ├── bottom_nav_screen.dart      # 5-tab IndexedStack shell
│       │   └── home_screen.dart
│       ├── onboarding/
│       │   ├── onboarding_page.dart        # Individual page widget
│       │   └── onboarding_screen.dart      # PageView controller
│       ├── product/
│       │   └── product_detail_screen.dart
│       ├── spices/
│       │   ├── spice_category_screen.dart
│       │   ├── spice_detail_screen.dart
│       │   └── spices_screen.dart
│       ├── splash/
│       │   └── splash_screen.dart
│       └── tiffin/
│           ├── delivery_slot_screen.dart
│           ├── subscription_plan_screen.dart
│           ├── tiffin_detail_screen.dart
│           └── tiffin_screen.dart
│
├── test/
│   └── widget_test.dart
│
├── android/                                # Android platform project
├── ios/                                    # iOS platform project
├── web/                                    # Web platform project
├── pubspec.yaml
└── DOCUMENTATION.md                        # This file
```

---

## 6. Design System

### Color Palette

Three brand colors anchor the three product verticals, ensuring each section has a distinct identity while sharing a common neutral base.

| Token | Hex | Context |
|---|---|---|
| `primaryRed` | `#D32F2F` | Fast Food, primary CTAs, header backgrounds |
| `primaryOrange` | `#F57C00` | Tiffin service, subscription CTAs |
| `primaryBrown` | `#8D4E1F` | Spices vertical, weight selectors |
| `background` | `#F8F8F8` | All scaffold backgrounds |
| `whiteSurface` | `#FFFFFF` | Cards, modal surfaces, button text |
| `textPrimary` | `#1A1A1A` | Headings, primary body text |
| `textSecondary` | `#6B6B6B` | Captions, hints, secondary labels |
| `lightPinkBg` | `#FFF1F1` | Fast food tinted backgrounds |
| `lightOrangeBg` | `#FFE8D1` | Tiffin tinted backgrounds |
| `lightBrownBg` | `#EAD9C7` | Spice tinted backgrounds |
| `lightGrayBg` | `#F2F2F2` | Unselected chips, input fills |
| `dividerGray` | `#E5E5E5` | Dividers, borders |
| `successGreen` | `#2E7D32` | Promo applied messages, purity index bar |
| `starYellow` | `#FFB400` | Rating star icons |

### Shadow System

```dart
cardShadow = BoxShadow(
  color: Colors.black.withValues(alpha: 0.05),
  blurRadius: 20,
  offset: Offset(0, 10),
)
```

### Typography

All text uses the **Poppins** typeface via `google_fonts` package.

| Role | Weight | Size |
|---|---|---|
| Screen titles | 700 | 22–24px |
| Section headers | 700 | 16–18px |
| Card titles | 700 | 15px |
| Body text | 400 | 13–14px |
| Buttons | 600 | 14–16px |
| Captions | 400 | 12px |

### Spacing & Shape

| Token | Value |
|---|---|
| Page horizontal gutter | 20px |
| Section vertical gap | 20–24px |
| Card border radius | 20px |
| Button border radius | 16px |
| Input border radius | 14px |
| Pill / chip border radius | 50px |
| Primary button height | 56px |
| Secondary button height | 52–54px |

### Theme Configuration (`app_theme.dart`)

- **Seed color:** `primaryRed`
- **Text theme:** `GoogleFonts.poppinsTextTheme()`
- **Input decoration:** filled, 14px radius, focused border = primaryRed
- **Elevated button:** primaryRed background, 56px min height, 16px radius
- **Material 3:** enabled

---

## 7. Navigation & Routing

All navigation uses Flutter's named route system. Routes are defined as string constants in `AppRoutes` and registered in `MaterialApp.onGenerateRoute`.

### Route Table

| Constant | Path | Screen | Notes |
|---|---|---|---|
| `AppRoutes.splash` | `/` | `SplashScreen` | Initial route |
| `AppRoutes.onboarding` | `/onboarding` | `OnboardingScreen` | 3-page PageView |
| `AppRoutes.signIn` | `/sign-in` | `SignInScreen` | |
| `AppRoutes.signUp` | `/sign-up` | `SignUpScreen` | |
| `AppRoutes.otp` | `/otp` | `OtpScreen` | |
| `AppRoutes.home` | `/home` | `HomeScreen` | Standalone home |
| `AppRoutes.bottomNav` | `/bottom-nav` | `BottomNavScreen` | Main app shell |
| `AppRoutes.fastFood` | `/fast-food` | `FastFoodScreen` | |
| `AppRoutes.tiffin` | `/tiffin` | `TiffinScreen` | |
| `AppRoutes.tiffinDetail` | `/tiffin-detail` | `TiffinDetailScreen` | arg: `String` product ID |
| `AppRoutes.subscriptionPlan` | `/subscription-plan` | `SubscriptionPlanScreen` | |
| `AppRoutes.deliverySlot` | `/delivery-slot` | `DeliverySlotScreen` | |
| `AppRoutes.spices` | `/spices` | `SpicesScreen` | |
| `AppRoutes.spiceDetail` | `/spice-detail` | `SpiceDetailScreen` | arg: `String` product ID |
| `AppRoutes.spiceCategory` | `/spice-category` | `SpiceCategoryScreen` | arg: `String` category |
| `AppRoutes.cart` | `/cart` | `CartScreen` | |
| `AppRoutes.productDetail` | `/product-detail` | `ProductDetailScreen` | |
| `AppRoutes.checkout` | `/checkout` | `CheckoutScreen` | |
| `AppRoutes.orderSuccess` | `/order-success` | `OrderSuccessScreen` | arg: `String` order ID |

### Navigation Flows

```
App Start
└── SplashScreen (2.5 s)
    └── OnboardingScreen (3 pages, skippable)
        └── SignInScreen ↔ SignUpScreen
            └── OtpScreen
                └── BottomNavScreen (persistent shell)
                    ├── [Tab 0] HomeScreen
                    │   ├── FastFoodScreen
                    │   │   └── ProductDetailScreen
                    │   ├── TiffinScreen
                    │   │   ├── TiffinDetailScreen
                    │   │   └── SubscriptionPlanScreen
                    │   │       └── DeliverySlotScreen
                    │   └── SpicesScreen
                    │       ├── SpiceDetailScreen
                    │       └── SpiceCategoryScreen
                    │           └── SpiceDetailScreen
                    ├── [Tab 1] Saved
                    ├── [Tab 2] CartScreen
                    │   └── CheckoutScreen
                    │       └── OrderSuccessScreen
                    │           └── BottomNavScreen (reset)
                    ├── [Tab 3] Orders
                    └── [Tab 4] Profile
```

### Argument Passing

Arguments are passed as raw Dart objects via `ModalRoute.of(context)?.settings.arguments`. Each route that expects arguments performs a safe cast with a fallback default:

```dart
final arg = ModalRoute.of(context)?.settings.arguments;
final productId = arg is String ? arg : 'default-id';
```

---

## 8. Data Models

### `ProductKind` (enum)

```dart
enum ProductKind {
  fastFood,
  tiffinMeal,
  spice,
}
```

### `ProductModel`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique product identifier |
| `name` | `String` | Display name |
| `emoji` | `String` | Visual emoji used instead of image |
| `kind` | `ProductKind` | Category classification |
| `price` | `double` | Base price in INR |
| `rating` | `double` | Numeric rating (e.g. 4.8) |
| `tag` | `String` | Badge text ("Popular", "Chef pick") |
| `subtitle` | `String` | Short description or category |
| `spiceCategory` | `String` | For spices: "All", "Ground", "Whole", "Blends", "Seeds" |
| `weightPrices` | `Map<String, double>?` | Weight → price map for spices |
| `mealComponents` | `List<String>` | Tiffin component breakdown |
| `nutritionLines` | `List<String>` | Nutritional information |
| `weeklyRotation` | `List<String>` | Tiffin weekly menu labels |
| `farmRegion` | `String?` | Spice origin description |
| `purityPercent` | `double?` | Lab-verified purity (0–100) |
| `deliveryEta` | `String?` | Estimated delivery time label |

**Computed members:**

```dart
String get ratingLabel          // rating.toStringAsFixed(1)
Iterable<String> get weightOptions  // keys of weightPrices
double priceForVariant(String? label)   // looks up weight price, falls back to base price
```

### `CartItemModel`

| Field | Type | Description |
|---|---|---|
| `lineId` | `String` | Unique cart line ID (`{productId}-{variant}-{timestamp}`) |
| `product` | `ProductModel` | Reference to the product |
| `unitPrice` | `double` | Price per unit at the time of adding |
| `quantity` | `int` | Mutable; clamped 1–99 |
| `variantLabel` | `String?` | Weight variant (e.g. "500g") or null |

```dart
double get lineTotal => unitPrice * quantity;
```

### `SubscriptionModel`

| Field | Type | Description |
|---|---|---|
| `id` | `String` | Plan identifier (`sub-1m`, `sub-3m`, `sub-6m`) |
| `title` | `String` | Display name ("1 Month", "3 Months") |
| `mealsLabel` | `String` | Meal count description |
| `price` | `double` | Total plan price in INR |
| `savingsLabel` | `String` | Savings compared to per-meal pricing |
| `months` | `int` | Plan duration |
| `highlight` | `bool` | Whether to render as "best value" |

---

## 9. State Management

The app uses a **singleton `ChangeNotifier`** pattern — no third-party packages.

### `CartService` — `lib/data/cart_service.dart`

```dart
CartService.instance   // global singleton access
```

`CartService` extends `ChangeNotifier`. Any widget that needs to react to cart changes wraps itself in a `ListenableBuilder`:

```dart
ListenableBuilder(
  listenable: CartService.instance,
  builder: (context, _) {
    final cart = CartService.instance;
    // rebuild whenever cart changes
  },
)
```

All other screens read `CartService.instance` directly for one-time values (e.g. to add a product) without subscribing to changes.

---

## 10. Feature Breakdown

### 10.1 Splash & Onboarding

#### Splash Screen
- White FoodieExpress logo on a red background
- App name (`FoodieExpress`) and tagline rendered in Poppins
- `smooth_page_indicator` dots animate at the bottom
- 2.5-second timer then pushes replacement to onboarding

#### Onboarding Screen
- `PageView` with 3 pages, each a full-screen illustrated slide
- Background color and accent follow the three verticals (red → orange → brown)
- Skip button (top-right) jumps directly to sign-in
- "Next / Get Started" CTA advances pages or navigates to sign-in
- `SmoothPageIndicator` at the bottom tracks progress

| Page | Emoji | Title | CTA |
|---|---|---|---|
| 1 | 🍔 | Fast Food Delivery | Next → |
| 2 | 🍱 | Tiffin Services | Next → |
| 3 | 🌶️ | Premium Spices | Get Started |

---

### 10.2 Authentication

All authentication screens are **UI-only** in v1.0. No real backend calls are made.

#### Sign In
- Email field (requires `@`) and password field (min 6 chars)
- "Forgot password?" link
- Stub buttons for Google and phone sign-in
- Navigates to OTP on success

#### Sign Up
- Fields: Full Name, Phone Number, Email, Password (min 8 chars)
- Role selector toggle: Customer / Admin
- Navigates to OTP on tap

#### OTP Screen
- 6 single-digit text fields with auto-focus chaining
  - Typing a digit auto-advances to the next field
  - Backspace on empty field returns focus to the previous
- 45-second countdown timer; "Resend code" becomes active after
- **Demo code:** `123456` — any other input shows an error message
- On success: pushes to `BottomNavScreen` (removes all prior routes)

---

### 10.3 Home & Navigation Shell

#### Bottom Navigation Shell (`BottomNavScreen`)
- Wraps 5 screens in an `IndexedStack` (no rebuild on tab switch)
- Active tab icon color: `primaryRed`; inactive: `textSecondary`

| Tab | Icon | Content |
|---|---|---|
| 0 — Home | home | `HomeScreen` |
| 1 — Saved | favorite_border | Empty-state placeholder |
| 2 — Cart | shopping_cart_outlined | `CartScreen` (embedded) |
| 3 — Orders | receipt_long_outlined | Demo order list |
| 4 — Profile | person_outline | User card + settings menu |

#### Home Screen
- Red header with greeting, user location, notification bell
- Integrated search bar (decorative in v1.0)
- **Category Cards:** Fast Food, Tiffin, Spices (horizontally laid out)
- **Popular Right Now:** 2 horizontally scrollable product cards
- **Promo Banner:** "Today's Special — 20% off on Tiffin subscriptions"

---

### 10.4 Fast Food

**Entry:** Home → Fast Food card → `FastFoodScreen`

#### Fast Food Screen
- Red gradient header with title and search icon
- Horizontal filter chip carousel: All · Burger · Pizza · Rolls · Drinks
- 2-column product grid (aspect ratio 0.72)
- Each card shows: emoji (Hero-tagged), product name, rating, delivery ETA, price, tag badge, add-to-cart button
- Search dialog (via icon) filters the grid by name

#### Product Detail Screen
- Light pink header (380px) with emoji, back button, and favourite button
- Overlapping white content card with:
  - Tab selector: **Details / Reviews / Nutrition**
  - Description text
  - **Customize:** Regular / Large / Extra Large size pills
  - **Add-ons:** Extra Cheese (+₹30), Smoky Patty Upgrade (+₹50) — multi-select toggles
- Sticky footer: quantity stepper + "Add to Cart" button
  - Button price updates dynamically: `₹180 + (cheese ? ₹30 : 0) + (patty ? ₹50 : 0)`

---

### 10.5 Tiffin Service

**Entry:** Home → Tiffin card → `TiffinScreen`

#### Tiffin Screen
- Orange gradient header
- **Monthly / One-Time toggle** — `AnimatedSwitcher` with fade + slide transition
- **Today's Menu Card:** Hero-animated emoji, meal name, tags (Pure Veg · Fresh Daily · Healthy), price, tap to open detail
- **Subscription Plan Cards:** 3 preview cards (1M / 3M / 6M)
- **Delivery Slot Row:** Shows current preference, "Change" link
- **Floating Subscribe Button:** Visible only on Monthly toggle, navigates to subscription plan

#### Tiffin Detail Screen
- Orange gradient header with Hero emoji
- Meal breakdown (bulleted list of components)
- Nutrition snapshot card
- Weekly rotation list (Mon–Fri meals)
- "Add to subscription" sticky button

#### Subscription Plan Screen
- Plan cards for 1 Month (₹2,999 · Save ₹601), 3 Months (₹7,999 · Save ₹2,201 · **Best Value**), 6 Months (₹14,999 · Save ₹5,401)
- Selected plan: orange gradient background; unselected: white with border
- "Confirm subscription" → `DeliverySlotScreen`

#### Delivery Slot Screen
- Meal preference: Lunch (12–1 PM) / Dinner (7–8 PM) chip toggle
- Preferred time: `showTimePicker` — default 12:30
- Delivery address: pre-filled multi-line text field
- "Save preferences" button

---

### 10.6 Premium Spices

**Entry:** Home → Spices card → `SpicesScreen`

#### Spices Screen
- Brown gradient header
- Horizontal filter chips: All · Whole · Ground · Blends · Seeds
- Animated promo banner: "Farm Fresh Collection · Direct from Rajasthan farms"
- 2-column product grid showing weight-based pricing (e.g. "₹180 / 500g")
- "Open category view" link → `SpiceCategoryScreen`

#### Spice Category Screen
- Title: "{Category} spices"
- Sort dropdown: Price ↑ / Price ↓ / Rating
- Filtered and sorted 2-column grid
- Empty state: 🫙 "No products in this category yet"

#### Spice Detail Screen
- Brown gradient header (300px) with Hero emoji
- **Pack Size selector:** weight option chips (100g / 250g / 500g)
  - Price display updates on selection
- **Purity Index:** `LinearProgressIndicator` (green), lab-verified percentage label
- **Farm Source:** Card with origin description
- "Add to cart" sticky button — adds with selected weight variant, shows snackbar, pops screen

---

### 10.7 Cart & Checkout

#### Cart Screen
- Accessible from Bottom Nav tab 2 or via push
- **Empty state:** Bag icon, "Your cart is empty", "Start shopping" button
- **Cart lines:** Each line is `Dismissible` (swipe left → delete)
  - Shows: emoji, product name, variant label, type, unit price, `AnimatedQuantityStepper`
- **Promo code section:** Text field + "Apply" button; field clears after application; success message shows the exact applied code
- **Order Summary card:** Subtotal, Delivery Fee (₹30), Promo Discount (highlighted green when active), GST 5%, **Total**
- "Proceed to checkout" button (disabled when cart is empty)

#### Checkout Screen
- Delivery address text field (pre-filled)
- Payment method: 3 radio-style tiles — Cash on Delivery / UPI · GPay · PhonePe / Credit · Debit Card
  - Selected tile: red border + light pink tint
- Order breakdown summary (same as cart)
- "Confirm order" → generates order ID, clears cart, navigates to `OrderSuccessScreen`

#### Order Success Screen
- Animated green circle with check mark (`ScaleTransition`, `elasticOut` curve)
- "Order placed!" heading
- Thank-you message
- Selectable order ID (`FE-YYYY{6-digit random}`)
- "Continue shopping" → pushes `BottomNavScreen`, removes all prior routes

---

## 11. Cart Service & Pricing Logic

```
Final Total Calculation
───────────────────────────────────────
Subtotal      =  Σ (unitPrice × quantity)  for all lines
PromoDiscount =  Subtotal × discountRate   (0 if no promo)
TaxableBase   =  max(0, Subtotal − PromoDiscount)
GST (5%)      =  TaxableBase × 0.05
DeliveryFee   =  ₹30 (fixed, always added)
───────────────────────────────────────
Total         =  TaxableBase + GST + DeliveryFee
```

### Active Promo Codes

| Code | Discount |
|---|---|
| `FEAST10` | 10% off subtotal |
| `SAVE20` | 20% off subtotal |
| `WELCOME5` | 5% off subtotal |
| `FOODLOVER` | 15% off subtotal |

- Input is trimmed and uppercased before lookup — entry is case-insensitive.
- An invalid code silently clears any previously applied promo.

### Order ID Generation

```dart
'FE-${DateTime.now().year}${100000 + Random().nextInt(899999)}'
// Example: FE-2026734821
```

### Demo Cart Seed

On first launch (when cart is empty), `CartService.seedDemoIfEmpty()` populates:

| Item | Qty | Variant |
|---|---|---|
| Classic Veg Burger | 1 | — |
| Rajasthani Thali | 2 | — |
| Red Chilli Powder | 1 | 500g |

### Key API

```dart
CartService.instance.addProduct(product, quantity: 1, variantLabel: '500g');
CartService.instance.updateQuantity(lineId, newQty);  // clamps 1–99
CartService.instance.removeLine(lineId);
CartService.instance.applyPromoCode('FEAST10');
CartService.instance.clear();
CartService.instance.generateOrderId();
```

---

## 12. Reusable Widget Library

All shared widgets live in `lib/core/widgets/`.

### `CategoryCard`
Renders a tappable vertical card used on the home screen for each product vertical.

| Prop | Type | Description |
|---|---|---|
| `title` | `String` | Label text |
| `emoji` | `String` | Large emoji displayed |
| `bgColor` | `Color` | Card background |
| `accentColor` | `Color` | Border / icon accent |
| `onTap` | `VoidCallback` | Navigation handler |

---

### `ProductCard`
2-column grid card for product listings. Supports Hero animation for image transitions.

| Prop | Type | Description |
|---|---|---|
| `name` | `String` | Product name |
| `price` | `String` | Pre-formatted price string |
| `emoji` | `String` | Product emoji (in Hero container) |
| `rating` | `String` | Rating label |
| `time` | `String?` | Delivery ETA (optional) |
| `tag` | `String` | Badge text ("Popular") |
| `tagColor` | `Color` | Badge background |
| `accentColor` | `Color` | Add button and price color |
| `onTap` | `VoidCallback` | Card tap → detail |
| `onAdd` | `VoidCallback` | Add button → cart |
| `heroTag` | `String?` | Optional Hero tag for emoji |

---

### `CustomTextField`
Styled text input for auth forms.

| Prop | Type | Description |
|---|---|---|
| `label` | `String` | Label above field |
| `hint` | `String` | Placeholder text |
| `controller` | `TextEditingController?` | Controller |
| `obscureText` | `bool` | Toggle for password fields |
| `prefixIcon` | `IconData?` | Leading icon |
| `keyboardType` | `TextInputType?` | Keyboard variant |
| `onChanged` | `ValueChanged<String>?` | Change callback |

---

### `QuantityStepper`
Static quantity control with − / + buttons.

| Prop | Type | Description |
|---|---|---|
| `quantity` | `int` | Current value (displayed) |
| `onMinus` | `VoidCallback` | Decrement handler |
| `onPlus` | `VoidCallback` | Increment handler |
| `color` | `Color` | Accent color (default: `primaryRed`) |

---

### `AnimatedQuantityStepper`
Identical to `QuantityStepper` but quantity changes animate with a `ScaleTransition` (220ms, `easeOutBack`). Used in the cart for a polished feel.

---

### `SectionTitle`
Row with a bold left label and optional right action link.

| Prop | Type | Description |
|---|---|---|
| `title` | `String` | Section heading |
| `actionText` | `String?` | "See All" style link text |
| `onActionTap` | `VoidCallback?` | Link tap handler |

---

## 13. Sample Data Catalogue

### Fast Food Items

| Name | Emoji | Price | Rating | ETA | Tag |
|---|---|---|---|---|---|
| Classic Veg Burger | 🍔 | ₹180 | 4.8 | 22 min | Popular |
| Cheese Burst Pizza | 🍕 | ₹299 | 4.6 | 35 min | Chef pick |
| Paneer Tikka Roll | 🌯 | ₹149 | 4.7 | 28 min | Bestseller |

### Today's Tiffin Meal

| Field | Value |
|---|---|
| Name | Rajasthani Thali |
| Emoji | 🍱 |
| Price | ₹120/meal |
| Rating | 4.9 |
| Components | Whole wheat roti (2), Dal tadka, Seasonal sabzi, Jeera rice, Garden salad, Pickle & papad |
| Nutrition | ~580 kcal, protein-forward, low-oil |
| Weekly Rotation | Mon–Fri with regional cuisine rotation labels |

### Spice Items

| Name | Emoji | Weights | Purity | Category | Source |
|---|---|---|---|---|---|
| Red Chilli Powder | 🌶️ | 100g ₹45 · 250g ₹95 · 500g ₹180 | 99.2% | Ground | Byadgi & Mathania, Rajasthan |
| Turmeric Powder | 🟡 | 100g ₹35 · 250g ₹75 · 500g ₹120 | 99.5% | Ground | Erode cooperative |
| Cumin Seeds | 🌿 | 100g ₹55 · 250g ₹110 · 500g ₹160 | 98.8% | Seeds / Whole | Jodhpur sorting facility |
| Coriander Powder | 🍃 | 100g ₹28 · 250g ₹58 · 500g ₹90 | 99.0% | Ground | Kota cold-storage batch |
| Kitchen King Blend | 🫙 | 100g ₹48 · 250g ₹105 · 500g ₹195 | 98.5% | Blends / Ground | In-house Jaipur blend |
| Mustard Seeds | ⚪ | 100g ₹25 · 250g ₹48 · 500g ₹82 | 98.2% | Seeds | Rajasthan plains harvest |

### Subscription Plans

| Plan | ID | Price | Meals | Savings | Highlight |
|---|---|---|---|---|---|
| 1 Month | sub-1m | ₹2,999 | 30 meals · Lunch + Dinner | Save ₹601 | No |
| 3 Months | sub-3m | ₹7,999 | 90 meals · Lunch + Dinner | Save ₹2,201 | **Yes** |
| 6 Months | sub-6m | ₹14,999 | 180 meals · Lunch + Dinner | Save ₹5,401 | No |

---

## 14. Build & Run

### Prerequisites

- Flutter SDK ≥ 3.10.4 ([flutter.dev](https://flutter.dev))
- Dart SDK (bundled with Flutter)
- Android Studio / VS Code with Flutter plugin
- Android emulator or physical device (for Android target)
- Chrome (for web target)

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd narsingh_kitchen

# Install dependencies
flutter pub get
```

### Run

```bash
# Run on connected Android device / emulator
flutter run

# Run in Chrome (web)
flutter run -d chrome

# Run with specific device
flutter devices              # list available
flutter run -d <device-id>
```

### Build

```bash
# Android APK (debug)
flutter build apk

# Android APK (release)
flutter build apk --release

# Android App Bundle (for Play Store)
flutter build appbundle --release

# Web (production)
flutter build web --release
```

### Output Paths

| Target | Path |
|---|---|
| APK | `build/app/outputs/flutter-apk/app-release.apk` |
| App Bundle | `build/app/outputs/bundle/release/app-release.aab` |
| Web | `build/web/` |

### Lint

```bash
flutter analyze
```

---

## 15. Known Limitations & Future Roadmap

### Current Limitations (v1.0)

| Area | Limitation |
|---|---|
| Authentication | UI-only; no real sign-in or OTP validation (demo code: `123456`) |
| Data | All products, meals, and subscriptions are static in-memory |
| Cart | Resets on full app restart (not persisted to disk) |
| Payment | No payment gateway; checkout is a simulation |
| Orders | Order history is hard-coded demo data |
| Saved | Favourites feature is a UI placeholder |
| Search | Header search bar is decorative; dialog search works locally |
| Form Validation | Sign-up form has no per-field validators |

### Roadmap (Suggested Enhancements)

| Priority | Feature |
|---|---|
| High | Firebase Authentication (email/OTP) |
| High | REST or Firestore backend for products and orders |
| High | Cart persistence (`shared_preferences` or `hive`) |
| High | Razorpay / Stripe payment gateway |
| Medium | Push notifications (FCM) |
| Medium | Real-time order tracking |
| Medium | Dark mode support |
| Medium | Per-field form validation on sign-up |
| Medium | Admin / restaurant dashboard |
| Low | Rich data serialization (`freezed`, `json_serializable`) |
| Low | Comprehensive widget and integration tests |
| Low | iOS platform polish and App Store submission |

---

*Documentation authored for Narsingh Kitchen · FoodieExpress · April 2026*
