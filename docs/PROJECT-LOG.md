# 📝 Project Activity Log: [اسم المشروع]

> سجل مفصّل بكل الأحداث والتفاصيل التي تمت في المشروع.  
> يتم التحديث تلقائيًا بواسطة الـ Orchestrator بعد كل حدث.

---

## كيف تقرأ هذا الملف

كل حدث مسجل بالشكل التالي:
```
### [YYYY-MM-DD HH:MM] — [رمز الحدث] [عنوان الحدث]
- **المنفذ:** [اسم الـ Agent]
- **الميزة:** [Feature ID]
- **التفاصيل:** [شرح مفصل]
- **الملفات المتأثرة:** [قائمة الملفات]
- **النتيجة:** [ماذا حدث]
```

---

## رموز الأحداث

| الرمز | النوع | الوصف |
|-------|-------|-------|
| 🚀 | START | بدء عمل على ميزة أو مهمة |
| ✅ | DONE | إنجاز مهمة بنجاح |
| ❌ | FAIL | فشل مهمة |
| 🔁 | RETURN | إرجاع مهمة لـ agent سابق |
| 🔒 | SECURITY | حدث أمني (ثغرة مكتشفة / تم الإصلاح) |
| 🧪 | TEST | نتائج اختبارات |
| 🐛 | BUG | اكتشاف أو إصلاح bug |
| 📦 | DEPLOY | رفع أو نشر إصدار |
| ⚙️ | CONFIG | تغيير في الإعدادات أو البنية التحتية |
| 📝 | NOTE | ملاحظة عامة أو قرار |
| ⏸️ | PAUSE | توقف مؤقت (في انتظار قرار أو معلومة) |
| 🔀 | MERGE | دمج كود أو branches |
| 📱 | MOBILE | حدث متعلق بالموبايل (بناء، رفع، إصدار) |
| 🗄️ | DB | تغيير في قاعدة البيانات (migration, seed) |

---

## السجل

---

### [YYYY-MM-DD HH:MM] — 🚀 START بدء المشروع
- **المنفذ:** 🎯 Orchestrator
- **التفاصيل:** تم إنشاء المشروع وتجهيز البنية الأساسية
- **الملفات المتأثرة:** -
- **النتيجة:** المشروع جاهز للعمل

---

<!-- 
=== نموذج لتسجيل الأحداث ===

### [YYYY-MM-DD HH:MM] — ✅ DONE إنجاز: تصميم البنية المعمارية للـ Authentication
- **المنفذ:** 🏗️ Architect
- **الميزة:** F-001
- **Task ID:** F-001-T01
- **التفاصيل:** 
  - تم تصميم نظام JWT مع refresh tokens
  - Database schema: جدول users + sessions + refresh_tokens
  - API: 4 endpoints (login, register, refresh, logout)
  - اختيار bcrypt للـ password hashing
- **الملفات المتأثرة:**
  - `docs/architecture/auth-design.md` (إنشاء)
- **النتيجة:** التصميم جاهز ومحفوظ، يمكن بدء الـ Backend

---

### [YYYY-MM-DD HH:MM] — 🔁 RETURN إرجاع: مراجعة الأمان وجدت ثغرة في الـ Auth
- **المنفذ:** 🔒 Security → ⚙️ Backend
- **الميزة:** F-001
- **Task ID:** F-001-T06 → F-001-T03
- **التفاصيل:**
  - ثغرة: الـ refresh token لا ينتهي عند تغيير كلمة المرور
  - الخطورة: 🔴 Critical
  - مطلوب: إبطال كل الـ refresh tokens عند password change
- **الملفات المتأثرة:**
  - `src/services/auth-service.ts` (تعديل مطلوب)
- **النتيجة:** تم إرجاع المهمة للـ Backend لإصلاح الثغرة

---

### [YYYY-MM-DD HH:MM] — 📦 DEPLOY رفع الإصدار v1.0.1
- **المنفذ:** 🎯 Orchestrator
- **التفاصيل:**
  - الميزات: F-001 (Auth), F-002 (Notifications)
  - البَاقز المصلحة: B-001, B-003
  - السيرفر: production (167.172.x.x)
  - الأمر: `ssh deploy@server 'cd /app && git pull && npm run build'`
- **النتيجة:** ✅ الإصدار مرفوع بنجاح

---

### [YYYY-MM-DD HH:MM] — 📱 MOBILE رفع الإصدار على App Store
- **المنفذ:** 📱 Mobile Dev
- **التفاصيل:**
  - النسخة: 2.1.0 (Build 45)
  - المتجر: App Store + Google Play
  - التغييرات: إضافة الإشعارات، إصلاح crash في صفحة البروفايل
- **النتيجة:** ✅ تم الرفع — في انتظار المراجعة

===
-->

---

### [2026-10-28] 🚀 START Phase 0a: SDK bump + lint
- **Branch:** `redesign/phase-0a-sdk-lint`
- **Changes:** SDK `>=3.4.0 <4.0.0`, `flutter_lints ^4.0.0` moved to dev_deps, modern lint rules in `analysis_options.yaml`.
- **Gates:** `flutter analyze` → 1031 info (style only, no errors) vs baseline 74. `flutter test` green. `flutter build apk --debug` success. iOS build skipped (Windows host).
- **Files:** `pubspec.yaml`, `analysis_options.yaml`, `test/widget_test.dart` (deleted stale template counter test, replaced with sanity test).
- **Result:** ✅ Chassis unblocked for modern deps.

### [2026-10-28] 🚀 START Phase 0b: Dio 5 + Figma inventory
- **Branch:** `redesign/phase-0b-dio5-figma-inventory`
- **Changes:** Dio 4→5, retrofit 3→4 (package only), retrofit_generator 4→10, build_runner 2.1→2.6, args override to ^2.6.0. Fixed `DioExceptionType` enum in `lib/data/networks/dio_errors.dart`. Timeouts changed to Duration in `lib/data/di/locator.dart`. Added `docs/figma-inventory.md` (55 screens across 5 sections + 21 overlay variants).
- **Gates:** `flutter analyze` 1091 info (0 err). `flutter test` green. `flutter build apk --debug` success. iOS skipped (Windows host). `build_runner` could not regen `.g.dart` (Flutter cache ships `frontend_server_aot.dart.snapshot` only; existing retrofit 3 `.g.dart` still compiles against retrofit 4 package).
- **Result:** ✅ Dio stack modernized. Figma inventory ready for Phase 8 reads.

### [2026-10-28] 🚀 START Phase 1: Design tokens + ThemeData
- **Branch:** `redesign/phase-1-tokens-theme`
- **Changes:** New `lib/core/theme/` — `app_colors_theme.dart`, `app_typography.dart`, `app_spacing.dart`, `app_radii.dart`, `app_shadows.dart`, `app_theme.dart`, `text_direction_x.dart`. All as `ThemeExtension`s. `MaterialApp.theme` now `AppTheme.light(locale: context.locale)` in `lib/main.dart`. Legacy `AppColors`/`AppStyles`/`AppFontSizes` untouched (migration happens per feature in Phase 8).
- **Gates:** `flutter analyze` on `lib/core` + `test/core` clean. `flutter test` 7 green. `flutter build apk --debug` success.
- **Result:** ✅ Theme chassis live; new widgets built against `ThemeExtension<T>` from day one.

### [2026-10-28] 🚀 START Phase 2: ui_kit essentials
- **Branch:** `redesign/phase-2-ui-kit`
- **Changes:** 17 widgets under `lib/core/ui_kit/` + barrel `ui_kit.dart`. Clusters: buttons (primary, secondary, text, icon), navigation (app_bar, back_button, bottom_nav_bar), surfaces (card, section_header, divider), feedback (dialog, bottom_sheet, snackbar), states (empty, error, loading, skeleton). All resolve tokens via `ThemeExtension`. RTL-aware back button.
- **Gates:** `flutter analyze lib/core test/core` 12 info (trailing commas, non-blocking). `flutter test` 21 green (14 ui_kit + 6 theme + sanity). `flutter build apk --debug` success.
- **Deferred to feature need:** inputs (text/password/select/phone/email/otp), provider buttons (Google/Apple), chips, rating, images, tabs.
- **Result:** ✅ Pilot `settings` can be built on this surface.

### [2026-10-28] — ✅ Phase 3 — Routing migration (Navigator 1.0 → go_router)
- **Branch:** `redesign/phase-3-router` (base: `redesign/phase-2-ui-kit`).
- **Deps:** `go_router: ^14.6.2`.
- **New:** `lib/core/router/route_names.dart` (mirror of NameRoutes with same string values), `lib/core/router/app_router.dart` (single `GoRouter`, 31 routes, root `GlobalKey<NavigatorState>`).
- **Changed:** `lib/main.dart` → `MaterialApp.router(routerConfig: AppRouter.router)`; FCM `onMessageOpenedApp` deep-link ports to `AppRouter.router.go('/home')`.
- **Deprecated:** `lib/routes/dorak_routes.dart::NameRoutes`, `lib/routes/route_manger.dart::RouteManger` (kept until Phase 8 call-site sweep).
- **Tests:** `test/core/router/app_router_test.dart` — 3 tests (name coverage, legacy string parity, config non-empty). All 24 tests green.
- **Gates:** `flutter analyze lib/core lib/main.dart test/core/router` → 6 info (pre-existing MultiProvider trailing-comma style). `flutter test` → 24 pass. `flutter build apk --debug` → OK.
- **Deferred:** per-screen `Navigator.pushNamed` → `context.goNamed` sweep lands in Phase 8 per feature.

### [2026-10-28] — ✅ Phase 4 (scaffold) — DI with injectable (codegen deferred)
- **Branch:** `redesign/phase-4-di` (base: `ui-redesign`).
- **Deps:** `injectable: ^2.5.0`, `injectable_generator: ^2.6.2` (dev).
- **New:** `lib/core/di/injection.dart` (`@InjectableInit`, `getIt`, stub `configureInjectableDependencies`), `lib/core/di/register_module.dart` (`@module` exposing `Dio` + `SharedPref` + `SharedPreferences`).
- **Docs:** `docs/DEVELOPER-OPS-GUIDE.md` — Phase 4 codegen section + mac/linux regen command.
- **Scaffold only:** `injection.config.dart` not generated on this Windows host (build_runner blocked by missing `frontend_server.dart.snapshot`). Manual `setupLocator()` in `lib/data/di/locator.dart` still the only wiring; new injectable path is a no-op until regen.
- **Gates:** `flutter analyze lib/core/di` → 0 issues. `flutter test` → 24/24. `flutter build apk --debug` → OK.
- **Phase 8 handoff:** when a mac/linux host is available, run `dart run build_runner build --delete-conflicting-outputs`, flip on the import + `$initGetIt(gi)` call in `lib/core/di/injection.dart`, call `configureInjectableDependencies(getIt)` from `main.dart`, then migrate each repo to `@LazySingleton(as: ...)` and delete the matching manual block.

### [2026-10-28] — ✅ Phase 5a — First BLoC migration (Language + AppReview)
- **Branch:** `redesign/phase-5a-cubits-language-review-general` (base: `ui-redesign`).
- **Deps:** `flutter_bloc ^8.1.6`, `bloc ^8.1.4`, `equatable ^2.0.5`, `bloc_test ^9.1.7` (dev), `mocktail ^1.0.4` (dev).
- **New:** `lib/core/state/status.dart` (shared `Status` enum). `lib/features/settings/logic/language_{cubit,state}.dart`. `lib/features/settings/logic/app_review_{cubit,state}.dart`.
- **Wiring:** `main.dart` wraps `MultiProvider` in `MultiBlocProvider` with `LanguageCubit` + `AppReviewCubit`. Legacy `ChangeNotifierProvider`s untouched (removed per screen in Phase 8).
- **Tests:** `test/features/settings/logic/language_cubit_test.dart` (3), `app_review_cubit_test.dart` (4). Total 31/31 green.
- **Gates:** `flutter analyze` clean on scope. `flutter test` 31/31. `flutter build apk --debug` OK.
- **Deferred to Phase 5b–5l:** GeneralCubit (next), OffersCubit, NotificationCubit, PatientProfileCubit, AppointmentsCubit, DoctorProfileCubit, SearchBloc, AuthBloc, HomeCubit + BottomNavCubit, BookingBloc.

### [2026-10-28] — ✅ Phase 5b — GeneralController → GeneralCubit
- **Branch:** `redesign/phase-5b-general-cubit` (base: `ui-redesign`).
- **New:** `lib/features/home/logic/general_{cubit,state}.dart`. Immutable `GeneralState` (22 fields, Equatable), 400-line controller ported to pure data methods.
- **Scope ported:** `getGeneralData`, `getCities`, `getSubSpeciality`, `searchSpecialization`, `searchSubSpecialization`, `searchArea`, `searchCity`, `searchByName`, `onSpecializationChange`, `onMainSpecializationChange`, `onSelectedCity`, `setMainSpecialization`, `setLatLng`, `loadTermsAndPolicy`.
- **Deferred:** `getCurrentLocation` + `handleLocationPermission` stay in UI (BuildContext + Geolocator) until Phase 8 extracts a `LocationService`.
- **Wiring:** `main.dart` adds `BlocProvider<GeneralCubit>` alongside legacy `ChangeNotifierProvider<GeneralController>` (both coexist until Phase 8).
- **Tests:** `test/features/home/logic/general_cubit_test.dart` — 5 tests (getGeneralData success, onSelectedCity, search filter, getSubSpeciality, setLatLng). Total 36/36 green.
- **Gates:** `flutter analyze` clean on scope. `flutter test` 36/36. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 6 — Feature-first folder scaffold
- **Branch:** `redesign/phase-6-feature-folders` (base: `ui-redesign`).
- **New:** 10 feature trees under `lib/features/` (`intro`, `auth`, `home`, `search`, `doctor`, `appointment`, `offers`, `profile`, `notification`, `settings`) with full Clean-Architecture subfolders + `.gitkeep` + per-feature `README.md`. Root `lib/features/README.md` documents the pattern.
- **Already populated:** `lib/features/home/logic/` (Phase 5b `GeneralCubit`), `lib/features/settings/logic/` (Phase 5a `LanguageCubit` + `AppReviewCubit`).
- **Gates:** `flutter analyze` unchanged (empty folders have no code). `flutter test` 36/36.

### [2026-10-28] — ✅ Phase 7 — Settings pilot
- **Branch:** `redesign/phase-7-pilot-settings` (base: `ui-redesign`).
- **New pages (ui_kit only, zero raw Color/TextStyle):**
  - `lib/features/settings/presentation/pages/settings_page.dart`
  - `lib/features/settings/presentation/pages/language_page.dart` — `BlocBuilder<LanguageCubit>` + `BlocListener` to `context.setLocale` then `goNamed(RouteNames.splash)`
  - `lib/features/settings/presentation/pages/app_review_page.dart` — rating + comment + submit, listens to `AppReviewState.submitted` to pop
  - `lib/features/settings/presentation/widgets/settings_tile.dart`
- **Router:** `app_router.dart` points `RouteNames.{setting,language,appReview}` at the new pages (legacy screens remain exported but unreferenced from the router).
- **Pattern doc:** `docs/feature_pattern_dorak.md` — folder layout, imports allowed, state/cubit/page/test shape. Phase 8 copies this.
- **Tests:** `test/features/settings/presentation/settings_page_test.dart` — 3 widget tests (settings list render, language page radios, app review render). Total 39/39 green.
- **Gates:** `flutter analyze lib/features test/features` clean on scope. `flutter test` 39/39. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 1/9) — intro from Figma
- **Branch:** `redesign/phase-8-intro` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`; nodes `201:1334` (Splash), `201:1345` (Welcome).
- **Assets:** 6 SVGs downloaded under `assets/images/intro/` (dorak_vertical, loader, dorak_mark, apple_logo, google_logo, call_icon).
- **New pages:**
  - `lib/features/intro/presentation/pages/splash_page.dart` — Figma-faithful mark + loader. Preserves legacy bootstrap: `AuthController.checkUserLoggedIn()`, Dio header refresh, `GeneralController.getData()`, then `go_router.goNamed(home | welcome | intro)` based on auth + `SharedPref.getFirstTime()`.
  - `lib/features/intro/presentation/pages/welcome_page.dart` — Status-bar-less header with language pill + back; centered logo + title + subtitle + phone CTA (brand green `#1F8046` + green glow shadow); "أو" divider; Apple + Google social buttons; bottom guest link.
- **i18n:** 7 new keys added to both `ar.json` and `en.json`: `welcome_title`, `welcome_subtitle`, `welcome_cta_phone`, `welcome_cta_apple`, `welcome_cta_google`, `welcome_guest`, `or`.
- **Router:** `RouteNames.splash` → `SplashPage`, `RouteNames.welcome` → `WelcomePage`. Legacy `SplashScreen`/`WelcomeScreen` still exported but unreferenced from router.
- **Pending token work (BRD):** Figma brand primary is green `#1F8046` while current DS token `borderPrimary` is blue `#014AE0`. Welcome CTA uses direct color constants pending a token swap when BRD lands; applies to Phase 9 cleanup.
- **Tests:** `test/features/intro/welcome_page_test.dart` — 1 widget test (3 FilledButton + 1 TextButton + 2 Dividers). Total 40/40 green.
- **Gates:** `flutter analyze lib/features/intro lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.
- **Deferred:** Apple + Google button handlers stubbed (Phase 8 auth feature wires them to legacy `AuthController` sign-in flows).

### [2026-10-28] — ✅ Phase 8 (feature 2/9) — home + bottom-nav shell from Figma
- **Branch:** `redesign/phase-8-home` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `171:509` (Home AR), bottom nav `171:682`.
- **Assets:** 20 Figma assets under `assets/images/home/` (icons, provider logos, offer + center images).
- **New files:**
  - `lib/features/home/presentation/pages/main_shell_page.dart` — 4-tab bottom nav host (Home/Discover/Bookings/Account) with Figma Primary green indicator bar.
  - `lib/features/home/presentation/pages/home_page.dart` — scroll body with location card, specialty chips, offers 2-col, nearest centers 2-col.
  - `lib/features/home/presentation/widgets/` × 7: `home_header.dart`, `location_card.dart`, `section_header.dart`, `specialty_chip_row.dart`, `offer_card.dart`, `center_card.dart`.
- **Router:** `RouteNames.home` → `MainShellPage` (legacy `MainScreen` kept exported).
- **i18n:** 9 new keys in both `ar.json` and `en.json` (`home_specialties`, `home_latest_offers`, `home_nearest_centers`, `home_nearest_clinics`, `home_view_all`, `nav_home`, `nav_discover`, `nav_bookings`, `nav_account`).
- **Scope:** static mock data; wiring to `HomeCubit`/`BottomNavCubit` lands with `HomeController` migration in Phase 5 sub-phase. Discovery + Bookings tabs stubbed. Nearest-clinics section deferred (same `CenterCard` shape, needs backend list).
- **Gates:** `flutter analyze lib/features/home lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 3/9) — search results from Figma
- **Branch:** `redesign/phase-8-search` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `203:1690` (Discovery 03 — Search results).
- **New:** `lib/features/search/presentation/pages/search_results_page.dart` — top search bar (editable TextField) + cancel link, specialty chip row (reused Phase 8 widget), list header, 2×2 grid of `CenterCard` (reused from home).
- **Assets:** no new downloads — reused `search.svg` + `center1.png` + `center2.png` from `assets/images/home/`.
- **i18n:** 4 keys: `search_cancel`, `search_specialties`, `search_results_label`, `search_medical_centers`.
- **Router:** `RouteNames.resultOfSearch` + `RouteNames.searchDoctor` → `SearchResultsPage`. Reads `?q=` query param for initial query.
- **Deferred:** map view (`203:1881`), empty state (`352:3400`), location picker (`203:1600`), and `SearchBloc` wiring (comes with Phase 5 SearchController migration).
- **Gates:** `flutter analyze lib/features/search lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 4/9) — doctor profile from Figma
- **Branch:** `redesign/phase-8-doctor` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `204:2053` (Center 03 — Doctor profile).
- **New:** `lib/features/doctor/presentation/pages/doctor_profile_page.dart` — top bar (heart + title + back), avatar/name/subtitle header, 3-stat row (reviews/experience/rating), About section, 2 city/branches cards, Services price row, bottom pinned "احجز موعدًا" CTA.
- **Assets:** 5 new under `assets/images/doctor/` (avatar.png, group.svg, shield_tick.svg, heart.svg, right.svg). Reused star/location/calendar from `assets/images/home/`.
- **i18n:** 5 keys: `doctor_profile`, `doctor_about`, `doctor_locations`, `doctor_price`, `doctor_book_cta`.
- **Router:** `RouteNames.doctor` → `DoctorProfilePage`. `RouteNames.doctorReview` still points at legacy `DoctorReview` (deferred).
- **Deferred:** doctor variants `363:3494`, `363:3625`; rate booking overlays; `DoctorProfileCubit` wiring (Phase 5 cluster).
- **Gates:** `flutter analyze lib/features/doctor lib/core/router` clean (1 info auto-fixed). `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 5/9) — appointments (My bookings) from Figma
- **Branch:** `redesign/phase-8-appointment` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `207:2279` (Account 01 — My bookings · Upcoming).
- **New:**
  - `lib/features/appointment/presentation/pages/appointments_page.dart` — title, 3 segmented tabs (Upcoming/Past/Cancelled), list of booking cards, empty state.
  - `lib/features/appointment/presentation/widgets/booking_card.dart` — status badge (4 kinds), date-time, center/doctor/branch meta, thumbnail, call+Details actions.
- **Assets:** none new — reused `home/calendar.svg`, `home/location.svg`, `home/call.svg`, `home/center1.png`, `home/center2.png`.
- **i18n:** 2 keys: `appointments_title`, `appointments_empty`.
- **Router:** `RouteNames.appointments` → `AppointmentsPage`. `MainShellPage` bookings tab now hosts `AppointmentsPage` (was stub).
- **Deferred:** booking flow (`177:888` specialty, `205:2084` city, `178:978` date-time, `206:2176` review, `206:2315` confirmed), booking details (`208:2535`), cancel booking overlay, `AppointmentsCubit` + `BookingBloc` wiring.
- **Gates:** `flutter analyze` clean on scope. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 6/9) — offers (pattern-matched, no Figma frame)
- **Branch:** `redesign/phase-8-offers` (base: `ui-redesign`).
- **Figma:** no dedicated offers list in inventory; pattern-matched from legacy `OffersScreen` using Phase 8 `OfferCard` + DS tokens.
- **New:** `lib/features/offers/presentation/pages/offers_page.dart` — title + 2-column grid of `OfferCard`.
- **Router:** `RouteNames.offers` → `OffersPage` (legacy `OffersScreen` still exported).
- **Deferred:** sort/filter sheet, `OffersCubit` wiring (Phase 5 cluster).
- **Gates:** `flutter analyze lib/features/offers lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 7/9) — profile signed-in from Figma
- **Branch:** `redesign/phase-8-profile` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `209:2649` (Account 06 — Profile signed in).
- **New:** `lib/features/profile/presentation/pages/profile_page.dart` — title, UserCard (edit + name/phone + initial-circle avatar), 3 list groups (Account / Preferences / Actions) with chevron rows, Primary-25 green icon pills, error-red logout.
- **Icons:** material icons stand in for Figma Hicon icons (same shape, same green pill). No asset downloads.
- **i18n:** 13 keys per locale.
- **Router:** `RouteNames.profile` → `ProfilePage`. `MainShellPage` account tab now hosts `ProfilePage` (was `SettingsPage`).
- **Deferred:** guest profile (`209:2842`), personal info page (`209:3066`), favorite centers (`363:3887`), help & support (`363:3756`), `PatientProfileCubit` wiring (Phase 5 cluster).
- **Gates:** `flutter analyze` clean on scope. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 8/9) — notifications from Figma
- **Branch:** `redesign/phase-8-notification` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, node `209:2971` (Account 08 — Notifications).
- **New:** `lib/features/notification/presentation/pages/notifications_page.dart` — top bar, section headers (Today + mark-all / This week), notification items with unread tint + dot, icon pill (calendar/check/offer/heart) in colored circle.
- **Icons:** material icons stand in for Figma Hicon. No asset downloads.
- **i18n:** 4 keys per locale.
- **Router:** `RouteNames.notification` → `NotificationsPage`.
- **Deferred:** empty state (`352:3712`), `NotificationCubit` wiring.
- **Gates:** `flutter analyze` clean on scope. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 8 (feature 9/9) — auth phone + OTP from Figma
- **Branch:** `redesign/phase-8-auth` (base: `ui-redesign`).
- **Figma source:** file `jA3JQXye9DbBrxzNkEj9nf`, nodes `201:1422` (phone), `201:1471` (OTP).
- **New:**
  - `lib/features/auth/presentation/pages/phone_page.dart` — RTL label + input with `+966` prefix pill + helper + green-ring field + pinned CTA.
  - `lib/features/auth/presentation/pages/otp_page.dart` — title + subtitle + change-number link + masked number, 4 OTP cells with autofocus + backspace flow, 45-second resend countdown, enable/disable CTA.
- **i18n:** 11 keys per locale (`phone_*`, `otp_*`).
- **Router:** `RouteNames.register` → `PhonePage`, `RouteNames.otp` → `OtpPage` (legacy `SignUpScreen` + `PhoneVerificationScreen` still exported).
- **Deferred:** complete-profile (`352:3260`), sign-in-required sheet (`202:1598`), signed-in success (`352:3321`), social provider wiring to real Apple/Google/Facebook flows, `AuthBloc` wiring (Phase 5 cluster).
- **Gates:** `flutter analyze lib/features/auth lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.

### [2026-10-28] — ✅ Phase 9b (partial) — router redirect of legacy routes
- **Branch:** `redesign/phase-9b-auth-legacy-redirect` (base: `ui-redesign`).
- **Changed:** `lib/core/router/app_router.dart` — all 15 legacy screen references replaced with redirects to the nearest Phase 8 feature page. Zero legacy `ui/screens` imports remain in router.
- **Redirects:**
  - `intro` → `WelcomePage`
  - `login`, `forgetPassword`, `changePassword`, `gender`, `changePhone` → `PhonePage`
  - `success` → `MainShellPage`
  - `profileDetails`, `editProfile` → `ProfilePage`
  - `addAppointment`, `doctorReview` → `DoctorProfilePage`
  - `searchForCity`, `searchForArea`, `searchForSpecialties`, `searchForSubSpecialties`, `bestDoctors` → `SearchResultsPage`
  - `errorBuilder` → `SplashPage`
- **Blocker found:** `lib/controllers/notification_controller.dart` references `Dialogue` from `lib/ui/components/components.dart` — full `lib/ui/components` + `lib/ui/screens` deletion blocked on that one usage.
- **Gates:** `flutter analyze lib/core/router` clean. `flutter test` 40/40. `flutter build apk --debug` OK.
