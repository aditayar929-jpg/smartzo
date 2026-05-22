# Smartzo - Modern Flutter eCommerce App

A production-ready Flutter shopping app with WooCommerce backend support.

## Features

- Splash Screen with animations
- Onboarding Screens
- Login/Register with JWT Authentication
- Home Screen with banners, categories and featured products
- Product Listing with pagination
- Product Details with image gallery, size/color selection and reviews
- Search with live search
- Wishlist
- Cart management
- Checkout with multiple payment options (Razorpay/Stripe/COD)
- Orders & Tracking
- User Profile
- Notifications
- Coupons & Offers
- Address Management
- Customer Support
- Dark Mode support

## Tech Stack

- Flutter 3.x
- GetX (State Management)
- Dio (HTTP Client)
- WooCommerce REST API
- JWT Authentication
- Material Design 3

## Project Structure

```
lib/
├── main.dart
├── app/
│   ├── controllers/     # GetX Controllers
│   ├── models/          # Data Models
│   ├── routes/          # App Routes
│   ├── services/        # API & Storage Services
│   ├── theme/           # App Theme & Colors
│   ├── utils/           # Helpers & Validators
│   └── views/           # UI Screens
│       ├── address/
│       ├── auth/
│       ├── cart/
│       ├── checkout/
│       ├── coupons/
│       ├── home/
│       ├── notifications/
│       ├── onboarding/
│       ├── orders/
│       ├── product/
│       ├── profile/
│       ├── search/
│       ├── settings/
│       ├── splash/
│       ├── support/
│       └── wishlist/
```

## Setup

1. Clone the repository
2. Run `flutter pub get`
3. Update WooCommerce API keys in `lib/app/utils/constants.dart`
4. Run `flutter run`

## Build APK

```bash
flutter build apk --release
```

## Configuration

Update `lib/app/utils/constants.dart`:

```dart
static const String baseUrl = 'YOUR_WOO_COMMERCE_URL/wp-json/wc/v3';
static const String consumerKey = 'YOUR_CONSUMER_KEY';
static const String consumerSecret = 'YOUR_CONSUMER_SECRET';
```

## Color Theme

- Primary: Dark Blue (#1A237E)
- Accent: Maroon (#880E4F)
- Background: White (#FFFFFF)

## License

MIT License
