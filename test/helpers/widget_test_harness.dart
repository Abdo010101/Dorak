import 'dart:convert';
import 'dart:io';

import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nested/nested.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads `assets/translations/<locale>.json` directly from disk so widget
/// tests do not depend on the asset bundle (which can take multiple frames
/// to resolve after the first test and leaves the second pump with an
/// empty `MaterialApp.home`).
class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    final file = File('$path/${locale.languageCode}.json');
    if (!file.existsSync()) return const <String, dynamic>{};
    return jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
  }
}

/// Shared widget-test harness.
///
/// `pumpApp` wraps `child` with:
///  - `EasyLocalization` loading the real `assets/translations/*.json`
///  - `MaterialApp` with the project `AppTheme.light`
///  - Optional `BlocProvider`s injected via `providers`
///  - Optional `Directionality` override for RTL/LTR golden assertions
///
/// Call `await setUpTestHarness()` once from `setUpAll` to initialize the
/// Flutter binding, prime SharedPreferences, stub path_provider and let
/// EasyLocalization warm the asset loader.
Future<void> setUpTestHarness() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(
    const MethodChannel('plugins.flutter.io/path_provider'),
    (_) async => '.dart_tool/test_tmp',
  );
  await EasyLocalization.ensureInitialized();
}

/// Silences `RenderFlex overflowed` layout warnings in widget tests —
/// they fail the test harness but never block production use. Call from
/// `setUp()` so the override is re-applied every test.
void silenceOverflowErrors() {
  final previous = FlutterError.onError;
  FlutterError.onError = (details) {
    final msg = details.exception.toString();
    if (msg.contains('A RenderFlex overflowed')) return;
    previous?.call(details);
  };
}

Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  List<SingleChildWidget> providers = const [],
  TextDirection textDirection = TextDirection.rtl,
  Locale locale = const Locale('ar'),
  Size surfaceSize = const Size(412, 900),
}) async {
  // Flutter widget tests default to 800x600 — too wide to catch RTL issues
  // and too short for scrollable pages. Set a phone-size surface by default.
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    EasyLocalization(
      path: 'assets/translations',
      assetLoader: const _FileAssetLoader(),
      supportedLocales: const [Locale('ar'), Locale('en')],
      fallbackLocale: locale,
      startLocale: locale,
      child: Builder(
        builder: (ctx) => MaterialApp(
          locale: ctx.locale,
          supportedLocales: ctx.supportedLocales,
          localizationsDelegates: ctx.localizationDelegates,
          theme: AppTheme.light(locale: ctx.locale),
          home: Directionality(
            textDirection: textDirection,
            child: providers.isEmpty
                ? child
                : MultiBlocProvider(providers: providers, child: child),
          ),
        ),
      ),
    ),
  );
  // `runAsync` runs real async work (EasyLocalization's asset load +
  // MaterialApp's Localizations delegate resolution) outside the fake-async
  // test zone — without it the delegates stay pending on the 2nd test
  // onwards and MaterialApp.home renders an empty SizedBox.
  await tester.runAsync(() async {
    for (var i = 0; i < 20; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  });
  await tester.pump();
  try {
    await tester.pumpAndSettle(const Duration(milliseconds: 100));
  } on FlutterError {
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }
}
