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
        builder: (_, __) => const WelcomePage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: RouteNames.login,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: RouteNames.register,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.otp,
        name: RouteNames.otp,
        builder: (_, __) => const OtpPage(),
      ),
      GoRoute(
        path: RouteNames.completeInfo,
        name: RouteNames.completeInfo,
        builder: (_, __) => const CompleteProfilePage(),
      ),
      GoRoute(
        path: RouteNames.signedIn,
        name: RouteNames.signedIn,
        builder: (_, __) => const SignedInPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: RouteNames.home,
        builder: (_, __) => const MainShellPage(),
      ),
      GoRoute(
        path: RouteNames.notification,
        name: RouteNames.notification,
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(
        path: RouteNames.setting,
        name: RouteNames.setting,
        builder: (_, __) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.forgetPassword,
        name: RouteNames.forgetPassword,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.appointments,
        name: RouteNames.appointments,
        builder: (_, __) => const AppointmentsPage(),
      ),
      GoRoute(
        path: RouteNames.searchForCity,
        name: RouteNames.searchForCity,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.searchForArea,
        name: RouteNames.searchForArea,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.resultOfSearch,
        name: RouteNames.resultOfSearch,
        builder: (_, state) => SearchResultsPage(
          initialQuery: state.uri.queryParameters['q'] ?? 'أسنان',
        ),
      ),
      GoRoute(
        path: RouteNames.searchForSpecialties,
        name: RouteNames.searchForSpecialties,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.searchForSubSpecialties,
        name: RouteNames.searchForSubSpecialties,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.doctor,
        name: RouteNames.doctor,
        builder: (_, state) => DoctorProfilePage(
          doctorId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: RouteNames.profile,
        name: RouteNames.profile,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.profileDetails,
        name: RouteNames.profileDetails,
        builder: (_, __) => const ProfilePage(),
      ),
      GoRoute(
        path: RouteNames.editProfile,
        name: RouteNames.editProfile,
        builder: (_, __) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: RouteNames.personalInfo,
        name: RouteNames.personalInfo,
        builder: (_, __) => const PersonalInfoPage(),
      ),
      GoRoute(
        path: RouteNames.favouriteCenters,
        name: RouteNames.favouriteCenters,
        builder: (_, __) => const FavouriteCentersPage(),
      ),
      GoRoute(
        path: RouteNames.helpSupport,
        name: RouteNames.helpSupport,
        builder: (_, __) => const HelpSupportPage(),
      ),
      GoRoute(
        path: RouteNames.bookingDetails,
        name: RouteNames.bookingDetails,
        builder: (_, state) => BookingDetailsPage(
          appointment: state.extra as AppointmentResponse?,
        ),
      ),
      GoRoute(
        path: RouteNames.success,
        name: RouteNames.success,
        builder: (_, __) => const MainShellPage(),
      ),
      GoRoute(
        path: RouteNames.appReview,
        name: RouteNames.appReview,
        builder: (_, __) => const AppReviewPage(),
      ),
      GoRoute(
        path: RouteNames.changePassword,
        name: RouteNames.changePassword,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.gender,
        name: RouteNames.gender,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.language,
        name: RouteNames.language,
        builder: (_, __) => const LanguagePage(),
      ),
      GoRoute(
        path: RouteNames.addAppointment,
        name: RouteNames.addAppointment,
        builder: (_, __) => const BookingSpecialtyDoctorPage(),
      ),
      GoRoute(
        path: RouteNames.bookingDateTime,
        name: RouteNames.bookingDateTime,
        builder: (_, __) => const BookingDateTimePage(),
      ),
      GoRoute(
        path: RouteNames.bookingReview,
        name: RouteNames.bookingReview,
        builder: (_, __) => const BookingReviewPage(),
      ),
      GoRoute(
        path: RouteNames.bookingConfirmed,
        name: RouteNames.bookingConfirmed,
        builder: (_, __) => const BookingConfirmedPage(),
      ),
      GoRoute(
        path: RouteNames.bestDoctors,
        name: RouteNames.bestDoctors,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.doctorReview,
        name: RouteNames.doctorReview,
        builder: (_, state) => DoctorProfilePage(
          doctorId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: RouteNames.changePhone,
        name: RouteNames.changePhone,
        builder: (_, __) => const PhonePage(),
      ),
      GoRoute(
        path: RouteNames.searchDoctor,
        name: RouteNames.searchDoctor,
        builder: (_, __) => const SearchResultsPage(),
      ),
      GoRoute(
        path: RouteNames.offers,
        name: RouteNames.offers,
        builder: (_, __) => const OffersPage(),
      ),
      GoRoute(
        path: RouteNames.discoveryExploreMap,
        name: RouteNames.discoveryExploreMap,
        builder: (_, __) => const ExploreMapPage(),
      ),
      GoRoute(
        path: RouteNames.discoveryLocationPicker,
        name: RouteNames.discoveryLocationPicker,
        builder: (_, __) => const LocationPickerPage(),
      ),
      GoRoute(
        path: RouteNames.centerDetails,
        name: RouteNames.centerDetails,
        builder: (_, state) => CenterDetailsPage(
          centerId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: RouteNames.doctorsAtCenter,
        name: RouteNames.doctorsAtCenter,
        builder: (_, state) => DoctorsAtCenterPage(
          centerId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: RouteNames.clinicDetails,
        name: RouteNames.clinicDetails,
        builder: (_, state) => ClinicDetailsPage(
          clinicId: int.tryParse(state.uri.queryParameters['id'] ?? '') ?? 100,
        ),
      ),
    ],
    errorBuilder: (_, __) => const SplashPage(),
  );
}
