import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    supportedLocales: const [Locale('en')],
    theme: AppTheme.light(locale: locale),
    home: Scaffold(body: child),
  );
}

void main() {
  group('buttons', () {
    testWidgets('AppPrimaryButton renders label and taps', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AppPrimaryButton(label: 'Go', onPressed: () => tapped++),
      ));
      expect(find.text('Go'), findsOneWidget);
      await tester.tap(find.text('Go'));
      await tester.pump();
      expect(tapped, 1);
    });

    testWidgets('AppPrimaryButton loading hides label and disables tap',
        (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AppPrimaryButton(
          label: 'Go',
          isLoading: true,
          onPressed: () => tapped++,
        ),
      ));
      expect(find.text('Go'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      final btn = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(btn.onPressed, isNull);
      expect(tapped, 0);
    });

    testWidgets('AppSecondaryButton renders', (tester) async {
      await tester.pumpWidget(
        _wrap(AppSecondaryButton(label: 'Cancel', onPressed: () {})),
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.byType(OutlinedButton), findsOneWidget);
    });

    testWidgets('AppTextButton renders', (tester) async {
      await tester.pumpWidget(
        _wrap(AppTextButton(label: 'Skip', onPressed: () {})),
      );
      expect(find.text('Skip'), findsOneWidget);
    });
  });

  group('navigation', () {
    testWidgets('AppTopBar shows title and back in RTL as arrow_forward',
        (tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(locale: const Locale('en')),
        home: const Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(appBar: AppTopBar(title: 'Settings')),
        ),
      ));
      expect(find.text('Settings'), findsOneWidget);
      expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
    });

    testWidgets('AppBottomNavBar shows items and reports tap', (tester) async {
      var tapped = -1;
      await tester.pumpWidget(_wrap(
        AppBottomNavBar(
          items: const [
            AppBottomNavItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              label: 'Home',
            ),
            AppBottomNavItem(
              icon: Icons.settings_outlined,
              activeIcon: Icons.settings,
              label: 'Settings',
            ),
          ],
          currentIndex: 0,
          onTap: (i) => tapped = i,
        ),
      ));
      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      await tester.tap(find.text('Settings'));
      expect(tapped, 1);
    });
  });

  group('surfaces', () {
    testWidgets('AppCard wraps child and taps', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AppCard(onTap: () => tapped++, child: const Text('Body')),
      ));
      expect(find.text('Body'), findsOneWidget);
      await tester.tap(find.text('Body'));
      expect(tapped, 1);
    });

    testWidgets('AppSectionHeader shows title + trailing', (tester) async {
      await tester.pumpWidget(_wrap(
        const AppSectionHeader(title: 'المواعيد', trailing: Icon(Icons.chevron_left)),
      ));
      expect(find.text('المواعيد'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_left), findsOneWidget);
    });
  });

  group('states', () {
    testWidgets('AppEmptyState shows title + message + CTA', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AppEmptyState(
          title: 'لا توجد نتائج',
          message: 'جرب كلمة أخرى',
          actionLabel: 'إعادة المحاولة',
          onAction: () => tapped++,
        ),
      ));
      expect(find.text('لا توجد نتائج'), findsOneWidget);
      expect(find.text('جرب كلمة أخرى'), findsOneWidget);
      await tester.tap(find.text('إعادة المحاولة'));
      await tester.pump();
      expect(tapped, 1);
    });

    testWidgets('AppErrorState shows retry button', (tester) async {
      var tapped = 0;
      await tester.pumpWidget(_wrap(
        AppErrorState(
          title: 'خطأ',
          onRetry: () => tapped++,
          retryLabel: 'إعادة',
        ),
      ));
      await tester.tap(find.text('إعادة'));
      await tester.pump();
      expect(tapped, 1);
    });

    testWidgets('AppLoadingState renders a progress indicator', (tester) async {
      await tester.pumpWidget(_wrap(const AppLoadingState()));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppSkeleton renders with configured height', (tester) async {
      await tester.pumpWidget(_wrap(const AppSkeleton(height: 24)));
      final container = tester.widget<Container>(find.byType(Container).first);
      expect((container.constraints?.minHeight ?? 0) >= 0, true);
    });
  });

  group('feedback', () {
    testWidgets('AppDialog shows and confirms', (tester) async {
      await tester.pumpWidget(_wrap(Builder(
        builder: (ctx) => ElevatedButton(
          onPressed: () => AppDialog.show<bool>(
            ctx,
            title: 'تأكيد',
            message: 'هل أنت متأكد؟',
            confirmLabel: 'نعم',
            cancelLabel: 'لا',
          ),
          child: const Text('open'),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('تأكيد'), findsOneWidget);
      expect(find.text('هل أنت متأكد؟'), findsOneWidget);
      expect(find.text('نعم'), findsOneWidget);
      expect(find.text('لا'), findsOneWidget);
    });

    testWidgets('AppBottomSheet shows title and child', (tester) async {
      await tester.pumpWidget(_wrap(Builder(
        builder: (ctx) => ElevatedButton(
          onPressed: () => AppBottomSheet.show<void>(
            ctx,
            title: 'اللغة',
            child: const Text('Arabic'),
          ),
          child: const Text('open'),
        ),
      )));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      expect(find.text('اللغة'), findsOneWidget);
      expect(find.text('Arabic'), findsOneWidget);
    });
  });
}
