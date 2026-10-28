import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/features/home/presentation/pages/main_shell_page.dart';
import 'package:dorakpattient/features/intro/presentation/pages/splash_page.dart';
import 'package:dorakpattient/features/intro/presentation/pages/welcome_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/app_review_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/language_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/settings_page.dart';
import 'package:dorakpattient/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'route_names.dart';

/// Shared root navigator key — used by FCM deep-link handler in `main.dart`.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Single `GoRouter` for the app. Each `GoRoute.name` matches `RouteNames.*`
/// (and the legacy `NameRoutes.k*` string). Phase 8 moves screen imports to
/// the feature-first `lib/features/<name>/presentation` tree.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: RouteNames.splash,
    debugLogDiagnostics: false,
    routes: <RouteBase>[
      GoRoute(
        path: RouteNames.splash,
        name: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: RouteNames.welcome,
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.intro,
        name: RouteNames.intro,
        builder: (_, __) => const IntroScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (context, __) {
          context.read<LoginController>().resetController();
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (context, __) {
          context.read<RegisterController>().resetController();
          return const SignUpScreen();
        },
      ),
      GoRoute(
        path: RouteNames.otp,
        name: RouteNames.otp,
        builder: (_, __) => const PhoneVerificationScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (_, __) => const MainShellPage(),
      ),
      GoRoute(
        path: RouteNames.notification,
        name: RouteNames.notification,
        builder: (_, __) => const NotificationScreen(),
      ),
      GoRoute(
        path: RouteNames.setting,
        name: RouteNames.setting,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.forgetPassword,
        name: RouteNames.forgetPassword,
        builder: (context, __) {
          context.read<VerifyController>().resetController();
          return const ForgetPasswordScreen();
        },
      ),
      GoRoute(
        path: RouteNames.appointments,
        name: RouteNames.appointments,
        builder: (_, __) => const AppointmentsScreen(),
      ),
      GoRoute(
        path: RouteNames.searchForCity,
        name: RouteNames.searchForCity,
        builder: (_, __) => const SearchForCityScreen(),
      ),
      GoRoute(
        path: RouteNames.searchForArea,
        name: RouteNames.searchForArea,
        builder: (_, __) => const SearchForAreaScreen(),
      ),
      GoRoute(
        path: RouteNames.resultOfSearch,
        name: RouteNames.resultOfSearch,
        builder: (_, __) => const ResultOfSearchScreen(),
      ),
      GoRoute(
        path: RouteNames.searchForSpecialties,
        name: RouteNames.searchForSpecialties,
        builder: (_, __) => const SearchForSpecialtiesScreen(),
      ),
      GoRoute(
        path: RouteNames.searchForSubSpecialties,
        name: RouteNames.searchForSubSpecialties,
        builder: (_, __) => const SearchForSubSpecialtiesScreen(),
      ),
      GoRoute(
        path: RouteNames.doctor,
        name: RouteNames.doctor,
        builder: (_, __) => const DoctorScreen(),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (_, __) => const ProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.profileDetails,
        name: RouteNames.profileDetails,
        builder: (_, __) => const ProfileDetailsScreen(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (_, __) => const EditProfileScreen(),
      ),
      GoRoute(
        path: RouteNames.success,
        name: RouteNames.success,
        builder: (_, __) => const SuccessScreen(),
      ),
      GoRoute(
        path: RouteNames.appReview,
        name: RouteNames.appReview,
        builder: (_, __) => const AppReviewPage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        builder: (_, __) => const ChangePasswordScreen(),
      ),
      GoRoute(
        path: RouteNames.gender,
        name: RouteNames.gender,
        builder: (_, __) => const GenderScreen(),
      ),
      GoRoute(
        path: RouteNames.language,
        name: RouteNames.language,
        builder: (_, __) => const LanguagePage(),
      ),
      GoRoute(
        path: RouteNames.addAppointment,
        name: RouteNames.addAppointment,
        builder: (_, __) => ReservationScreen(),
      ),
      GoRoute(
        path: RouteNames.bestDoctors,
        name: RouteNames.bestDoctors,
        builder: (_, __) => const BestDoctorsScreen(),
      ),
      GoRoute(
        path: RouteNames.doctorReview,
        name: RouteNames.doctorReview,
        builder: (_, __) => const DoctorReview(),
      ),
      GoRoute(
        path: RouteNames.changePhone,
        name: RouteNames.changePhone,
        builder: (_, __) => const ChangePhoneScreen(),
      ),
      GoRoute(
        path: RouteNames.searchDoctor,
        name: RouteNames.searchDoctor,
        builder: (_, __) => const SearchByDoctorScreen(),
      ),
      GoRoute(
        path: RouteNames.offers,
        name: RouteNames.offers,
        builder: (_, __) => const OffersScreen(),
      ),
    ],
    errorBuilder: (_, __) => const SplashScreen(),
  );
}
