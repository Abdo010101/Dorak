import 'package:dorakpattient/data/models/response/appointment_response.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/appointments_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_confirmed_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_date_time_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_details_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_review_page.dart';
import 'package:dorakpattient/features/appointment/presentation/pages/booking_specialty_doctor_page.dart';
import 'package:dorakpattient/features/auth/presentation/pages/complete_profile_page.dart';
import 'package:dorakpattient/features/auth/presentation/pages/otp_page.dart';
import 'package:dorakpattient/features/auth/presentation/pages/phone_page.dart';
import 'package:dorakpattient/features/auth/presentation/pages/signed_in_page.dart';
import 'package:dorakpattient/features/center/presentation/pages/center_details_page.dart';
import 'package:dorakpattient/features/center/presentation/pages/clinic_details_page.dart';
import 'package:dorakpattient/features/center/presentation/pages/doctors_at_center_page.dart';
import 'package:dorakpattient/features/discovery/presentation/pages/explore_map_page.dart';
import 'package:dorakpattient/features/discovery/presentation/pages/location_picker_page.dart';
import 'package:dorakpattient/features/doctor/presentation/pages/doctor_profile_page.dart';
import 'package:dorakpattient/features/favourites/presentation/pages/favourite_centers_page.dart';
import 'package:dorakpattient/features/home/presentation/pages/main_shell_page.dart';
import 'package:dorakpattient/features/intro/presentation/pages/splash_page.dart';
import 'package:dorakpattient/features/intro/presentation/pages/welcome_page.dart';
import 'package:dorakpattient/features/notification/presentation/pages/notifications_page.dart';
import 'package:dorakpattient/features/offers/presentation/pages/offers_page.dart';
import 'package:dorakpattient/features/profile/presentation/pages/help_support_page.dart';
import 'package:dorakpattient/features/profile/presentation/pages/personal_info_page.dart';
import 'package:dorakpattient/features/profile/presentation/pages/profile_page.dart';
import 'package:dorakpattient/features/search/presentation/pages/search_results_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/app_review_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/language_page.dart';
import 'package:dorakpattient/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_names.dart';

/// Shared root navigator key — used by FCM deep-link handler in `main.dart`.
final GlobalKey<NavigatorState> rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

/// Patient-app page transition: 240 ms fade + 8 px slide-up with
/// `Curves.easeOutCubic`. Direction-neutral so it reads the same in RTL
/// (Arabic) and LTR (English). Calm feel suited to a healthcare app.
CustomTransitionPage<T> _calmPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    transitionDuration: const Duration(milliseconds: 240),
    reverseTransitionDuration: const Duration(milliseconds: 200),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.02),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}

/// Single `GoRouter` for the app. All routes resolve to Phase 8 feature pages.
/// Legacy auth / profile sub-routes (login, forget-password, change-password,
/// gender, success, change-phone, edit-profile, profile-details, best-doctors,
/// doctor-review, 4 search sub-pickers, add-appointment) redirect to their
/// nearest Phase 8 equivalent until BRD-driven replacements land.
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
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SplashPage()),
      ),
      GoRoute(
        path: RouteNames.welcome,
        name: RouteNames.welcome,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const WelcomePage()),
      ),
      GoRoute(
        path: RouteNames.intro,
        name: RouteNames.intro,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const WelcomePage()),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.otp,
        name: RouteNames.otp,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const OtpPage()),
      ),
      GoRoute(
        path: RouteNames.completeInfo,
        name: RouteNames.completeInfo,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const CompleteProfilePage(),
        ),
      ),
      GoRoute(
        path: RouteNames.signedIn,
        name: RouteNames.signedIn,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SignedInPage()),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const MainShellPage()),
      ),
      GoRoute(
        path: RouteNames.notification,
        name: RouteNames.notification,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const NotificationsPage()),
      ),
      GoRoute(
        path: RouteNames.setting,
        name: RouteNames.setting,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SettingsPage()),
      ),
      GoRoute(
        path: RouteNames.forgetPassword,
        name: RouteNames.forgetPassword,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.appointments,
        name: RouteNames.appointments,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const AppointmentsPage()),
      ),
      GoRoute(
        path: RouteNames.searchForCity,
        name: RouteNames.searchForCity,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.searchForArea,
        name: RouteNames.searchForArea,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.resultOfSearch,
        name: RouteNames.resultOfSearch,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: SearchResultsPage(
            initialQuery: state.uri.queryParameters['q'] ?? 'أسنان',
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.searchForSpecialties,
        name: RouteNames.searchForSpecialties,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.searchForSubSpecialties,
        name: RouteNames.searchForSubSpecialties,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.doctor,
        name: RouteNames.doctor,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: DoctorProfilePage(
            doctorId:
                int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const ProfilePage()),
      ),
      GoRoute(
        path: RouteNames.profileDetails,
        name: RouteNames.profileDetails,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const ProfilePage()),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PersonalInfoPage()),
      ),
      GoRoute(
        path: RouteNames.personalInfo,
        name: RouteNames.personalInfo,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PersonalInfoPage()),
      ),
      GoRoute(
        path: RouteNames.favouriteCenters,
        name: RouteNames.favouriteCenters,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const FavouriteCentersPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        name: RouteNames.helpSupport,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const HelpSupportPage()),
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        name: RouteNames.bookingDetails,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: BookingDetailsPage(
            appointment: state.extra as AppointmentResponse?,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.success,
        name: RouteNames.success,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const MainShellPage()),
      ),
      GoRoute(
        path: RouteNames.appReview,
        name: RouteNames.appReview,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const AppReviewPage()),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.gender,
        name: RouteNames.gender,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.language,
        name: RouteNames.language,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const LanguagePage()),
      ),
      GoRoute(
        path: RouteNames.addAppointment,
        name: RouteNames.addAppointment,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const BookingSpecialtyDoctorPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.bookingDateTime,
        name: RouteNames.bookingDateTime,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const BookingDateTimePage(),
        ),
      ),
      GoRoute(
        path: RouteNames.bookingReview,
        name: RouteNames.bookingReview,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const BookingReviewPage()),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmed,
        name: RouteNames.bookingConfirmed,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const BookingConfirmedPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.bestDoctors,
        name: RouteNames.bestDoctors,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.doctorReview,
        name: RouteNames.doctorReview,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: DoctorProfilePage(
            doctorId:
                int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.changePhone,
        name: RouteNames.changePhone,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const PhonePage()),
      ),
      GoRoute(
        path: RouteNames.searchDoctor,
        name: RouteNames.searchDoctor,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const SearchResultsPage()),
      ),
      GoRoute(
        path: RouteNames.offers,
        name: RouteNames.offers,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const OffersPage()),
      ),
      GoRoute(
        path: RouteNames.discoveryExploreMap,
        name: RouteNames.discoveryExploreMap,
        pageBuilder: (_, state) =>
            _calmPage(key: state.pageKey, child: const ExploreMapPage()),
      ),
      GoRoute(
        path: RouteNames.discoveryLocationPicker,
        name: RouteNames.discoveryLocationPicker,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: const LocationPickerPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.centerDetails,
        name: RouteNames.centerDetails,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: CenterDetailsPage(
            centerId:
                int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.doctorsAtCenter,
        name: RouteNames.doctorsAtCenter,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: DoctorsAtCenterPage(
            centerId:
                int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
          ),
        ),
      ),
      GoRoute(
        path: RouteNames.clinicDetails,
        name: RouteNames.clinicDetails,
        pageBuilder: (_, state) => _calmPage(
          key: state.pageKey,
          child: ClinicDetailsPage(
            clinicId:
                int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 100,
          ),
        ),
      ),
    ],
    errorBuilder: (_, __) => const SplashPage(),
  );
}
