# Fullup — New App Checklist

Checklist for setting up a new app in the monorepo or onboarding an existing one.

---

## Step 1: App Info

| Field | Answer |
|---|---|
| **App Name** | |
| **App Type** | |
| **Target Users** | |
| **User Roles** | |
| **Languages** | Arabic (primary) + English |
| **Platform** | iOS + Android |

---

## Step 2: API Documentation

| Format | Details |
|---|---|
| **API Docs** | |
| **Base URL** | |
| **Auth method** | Bearer token (Laravel Sanctum) |
| **Response format** | `{ success, message, data?, errors? }` |
| **Localization** | `Accept-Language` header: `ar` or `en` |

---

## Step 3: Features List

- [ ] **Onboarding** — Splash screen, onboarding pages
- [ ] **Auth** — Register, OTP, Login, Forgot/Reset password, Logout
- [ ] **Home** — Main dashboard with bottom navigation
- [ ] **Profile** — View and edit profile
- [ ] **Notifications** — Push notifications (FCM)
- [ ] **Settings** — Language, theme, etc.
- [ ] **Chat** — Real-time messaging (see [guides/chat_implementation.md](guides/chat_implementation.md))
- [ ] *(Add app-specific features)*

---

## Step 4: Third-party Services

| Service | Used? | Details |
|---|---|---|
| **Firebase** | | FCM, Analytics, Crashlytics |
| **Payment Gateway** | | |
| **Google Maps** | | |
| **Social Login** | | |
| **Chat / WebSocket** | | Pusher / Reverb |

---

## Step 5: Design Assets

| Item | Status |
|---|---|
| **Figma Design** | |
| **App Icon** | |
| **Splash Screen** | |
| **Translation Files** | `assets/translations/` |

---

## Step 6: Tech Stack (Standard)

| Component | Technology |
|---|---|
| Framework | Flutter (Dart) |
| State Management | Cubit |
| DI | getIt (manual registration in `lib/core/di/injection_container.dart`) |
| Navigation | go_router |
| HTTP | Dio (via `packages/core/networking`) |
| Storage | SharedPreferences + SecureStorage (via `packages/core/storage`) |
| Localization | easy_localization (via `packages/localization`) |
| Responsive | flutter_screenutil |
| Immutable Data | Equatable (hand-written `copyWith`, `fromJson` in DTOs) |
| UI Kit | `packages/ui_kit` |

---

## Step 7: Folder Setup

```
apps/[app_name]/
├── assets/
│   ├── fonts/
│   ├── images/
│   └── translations/
│       ├── ar.json
│       └── en.json
├── lib/
│   ├── core/
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   ├── di/
│   │   │   └── injection_container.dart
│   │   └── router/
│   │       └── app_router.dart
│   ├── features/
│   │   ├── auth/
│   │   ├── home/
│   │   └── ...
│   └── main.dart
├── test/
├── pubspec.yaml
└── analysis_options.yaml
```

---

## Step 8: Pre-Launch Checklist

### Build Readiness
- [ ] App icon in all required sizes
- [ ] Splash screen
- [ ] Privacy policy URL
- [ ] Version number and build number set
- [ ] Required permissions justified in Info.plist / AndroidManifest

### Quality
- [ ] No crashes on first open
- [ ] No crashes on screen rotation
- [ ] Works offline (shows cached data or proper error)
- [ ] API errors handled gracefully
- [ ] Back button works (Android)
- [ ] RTL layout correct (Arabic)
- [ ] No console warnings

### Testing
- [ ] Unit tests for business logic
- [ ] Widget tests for key components
- [ ] E2E tests with Maestro (see [guides/maestro_e2e_testing.md](guides/maestro_e2e_testing.md))
- [ ] Tested on both iOS and Android

### Build Commands

```bash
# Run
flutter run

# Tests
flutter test

# Build iOS
flutter build ios --release

# Build Android
flutter build apk --release
flutter build appbundle --release

# Analyze
flutter analyze

```
