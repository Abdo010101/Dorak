import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/controllers.dart';

@Deprecated('Use AppRouter from lib/core/router/app_router.dart (go_router)')
class RouteManger {
  static Route<dynamic> generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case NameRoutes.kSplashScreen:
        return MaterialPageRoute(builder: (context) => const SplashScreen());

      case NameRoutes.kSuccessScreen:
        return MaterialPageRoute(builder: (context) => const SuccessScreen());

      case NameRoutes.kIntroScreen:
        return MaterialPageRoute(builder: (context) => const IntroScreen());

      case NameRoutes.kWelcomeScreen:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());

      case NameRoutes.kAppReview:
        return MaterialPageRoute(builder: (context) {
          context.read<AppReviewController>().resetController();
          return const AppReview();
        });

      case NameRoutes.kHomeScreen:
        return MaterialPageRoute(builder: (context) => const MainScreen());

      case NameRoutes.kNotificationScreen:
        return MaterialPageRoute(
            builder: (context) => const NotificationScreen());

      case NameRoutes.kEditProfileScreen:
        return MaterialPageRoute(
            builder: (context) => const EditProfileScreen());
      case NameRoutes.kProfileDetailsScreen:
        return MaterialPageRoute(
            builder: (context) => const ProfileDetailsScreen());

      case NameRoutes.kProfileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case NameRoutes.kRegisterScreen:
        return MaterialPageRoute(builder: (context) {
          context.read<RegisterController>().resetController();
          return const SignUpScreen();
        });

      case NameRoutes.kLoginScreen:
        return MaterialPageRoute(
          builder: (context) {
            context.read<LoginController>().resetController();
            return const LoginScreen();
          },
        );

      case NameRoutes.kAppointmentsScreen:
        return MaterialPageRoute(
            builder: (context) => const AppointmentsScreen());

      case NameRoutes.kSettingScreen:
        return MaterialPageRoute(builder: (context) => const SettingsScreen());

      case NameRoutes.kSearchForSpecialtiesScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForSpecialtiesScreen());

      case NameRoutes.kSearchForSubSpecialtiesScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForSubSpecialtiesScreen());

      case NameRoutes.kSearchForCityScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForCityScreen());

      case NameRoutes.kSearchForAreaScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForAreaScreen());

      case NameRoutes.kResultOfSearch:
        return MaterialPageRoute(
            builder: (context) => const ResultOfSearchScreen());
      case NameRoutes.kDoctorScreen:
        return MaterialPageRoute(builder: (context) => const DoctorScreen());

      case NameRoutes.kOTPScreen:
        return MaterialPageRoute(
            builder: (context) => const PhoneVerificationScreen());

      case NameRoutes.kGenderScreen:
        return MaterialPageRoute(builder: (context) => const GenderScreen());

      case NameRoutes.kForgetPasswordScreen:
        return MaterialPageRoute(builder: (context) {
          context.read<VerifyController>().resetController();
          return const ForgetPasswordScreen();
        });
      case NameRoutes.kChangePasswordScreen:
        return MaterialPageRoute(
            builder: (context) => const ChangePasswordScreen());

      case NameRoutes.kLanguageScreen:
        return MaterialPageRoute(builder: (context) => const LanguageScreen());

      case NameRoutes.kAddAppointmentScreen:
        return MaterialPageRoute(builder: (context) => ReservationScreen());

      case NameRoutes.kBestDoctorsScreen:
        return MaterialPageRoute(
            builder: (context) => const BestDoctorsScreen());

      case NameRoutes.kDoctorReviewScreen:
        return MaterialPageRoute(builder: (context) => const DoctorReview());

      case NameRoutes.kChangePhoneScreen:
        return MaterialPageRoute(
            builder: (context) => const ChangePhoneScreen());

      case NameRoutes.kSearchDoctorScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchByDoctorScreen());

      default:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
    }
  }
}
