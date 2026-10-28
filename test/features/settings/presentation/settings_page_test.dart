import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/settings/logic/app_review_cubit.dart';
import 'package:dorakpattient/features/settings/logic/app_review_state.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:dorakpattient/features/settings/logic/language_state.dart';
import 'package:dorakpattient/features/settings/presentation/pages/app_review_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/language_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _StubLanguageCubit extends MockCubit<LanguageState>
    implements LanguageCubit {}

class _StubAppReviewCubit extends MockCubit<AppReviewState>
    implements AppReviewCubit {}

class _MockRateRepo extends Mock implements RateRepository {}

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('en'), Locale('ar')],
    theme: AppTheme.light(locale: locale),
    home: child,
  );
}

void main() {
  group('SettingsPage', () {
    late _StubLanguageCubit lang;
    late _StubAppReviewCubit review;

    setUp(() {
      lang = _StubLanguageCubit();
      review = _StubAppReviewCubit();
      when(() => lang.state).thenReturn(const LanguageState.initial());
      when(() => review.state).thenReturn(const AppReviewState());
    });

    testWidgets('renders options list', (tester) async {
      await tester.pumpWidget(
        _wrap(
          MultiBlocProvider(
            providers: [
              BlocProvider<LanguageCubit>.value(value: lang),
              BlocProvider<AppReviewCubit>.value(value: review),
            ],
            child: const SettingsPage(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('settings'), findsOneWidget);
      expect(find.text('language'), findsOneWidget);
      expect(find.text('app_review'), findsOneWidget);
    });
  });

  group('LanguagePage', () {
    testWidgets('shows both languages and radio states', (tester) async {
      final cubit = LanguageCubit(dio: Dio());
      await tester.pumpWidget(
        _wrap(
          BlocProvider<LanguageCubit>.value(
            value: cubit,
            child: const LanguagePage(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('العربية'), findsOneWidget);
      expect(find.text('English'), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      expect(find.byIcon(Icons.radio_button_off), findsOneWidget);
      await cubit.close();
    });
  });

  group('AppReviewPage', () {
    testWidgets('renders rating + submit button', (tester) async {
      final cubit = AppReviewCubit(rateRepository: _MockRateRepo());
      await tester.pumpWidget(
        _wrap(
          BlocProvider<AppReviewCubit>.value(
            value: cubit,
            child: const AppReviewPage(),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('submit'), findsOneWidget);
      await cubit.close();
    });
  });
}
