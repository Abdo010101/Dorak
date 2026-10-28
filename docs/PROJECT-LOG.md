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
