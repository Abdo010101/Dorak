import 'package:dio/dio.dart';
import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:dorakpattient/features/intro/presentation/pages/welcome_page.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget _wrap(Widget child) {
  return EasyLocalization(
    path: 'assets/translations',
    supportedLocales: const [Locale('ar'), Locale('en')],
    fallbackLocale: const Locale('ar'),
    child: Builder(
      builder: (ctx) => MaterialApp(
        locale: ctx.locale,
        supportedLocales: ctx.supportedLocales,
        localizationsDelegates: ctx.localizationDelegates,
        theme: AppTheme.light(locale: ctx.locale),
        home: BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(dio: Dio()),
          child: child,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => '.dart_tool/test_tmp',
    );
    await EasyLocalization.ensureInitialized();
  });

  testWidgets('WelcomePage renders CTA + divider + 2 social + guest link',
      (tester) async {
    await tester.pumpWidget(_wrap(const WelcomePage()));
    await tester.pumpAndSettle();
    expect(find.byType(FilledButton), findsNWidgets(3));
    expect(find.byType(TextButton), findsOneWidget);
    expect(find.byType(Divider), findsNWidgets(2));
  });
}
