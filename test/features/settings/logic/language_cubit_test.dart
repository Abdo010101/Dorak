import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:dorakpattient/features/settings/logic/language_state.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LanguageCubit', () {
    late Dio dio;
    setUp(() {
      dio = Dio();
    });

    blocTest<LanguageCubit, LanguageState>(
      'emits new locale and updates Dio header',
      build: () => LanguageCubit(dio: dio),
      act: (c) => c.setLocale(const Locale('en')),
      expect: () => const [LanguageState(locale: Locale('en'))],
      verify: (_) =>
          expect(dio.options.headers['Content-language'], 'en'),
    );

    blocTest<LanguageCubit, LanguageState>(
      'no emit when locale unchanged',
      build: () => LanguageCubit(dio: dio),
      act: (c) => c.setLocale(const Locale('ar')),
      expect: () => const <LanguageState>[],
    );

    blocTest<LanguageCubit, LanguageState>(
      'setByLabel("English") switches to en',
      build: () => LanguageCubit(dio: dio),
      act: (c) => c.setByLabel('English'),
      expect: () => const [LanguageState(locale: Locale('en'))],
    );
  });
}
