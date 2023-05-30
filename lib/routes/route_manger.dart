import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/ui/screens/screens.dart';
import 'package:flutter/material.dart';

class RouteManger {
  static Route<dynamic> generateRouter(RouteSettings settings) {
    switch (settings.name) {
      case NameRoutes.kSplashScreen:
        return MaterialPageRoute(builder: (context) => SplashScreen());

      case NameRoutes.kSuccessScreen:
        return MaterialPageRoute(builder: (context) => const SuccessScreen());

      case NameRoutes.kIntroScreen:
        return MaterialPageRoute(builder: (context) => const IntroScreen());

      case NameRoutes.kWelcomeScreen:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());

      case NameRoutes.kAppReview:
        return MaterialPageRoute(builder: (context) => const AppReview());

      case NameRoutes.kHomeScreen:
        return MaterialPageRoute(builder: (context) => const MainScreen());

      case NameRoutes.kNotificationScreen:
        return MaterialPageRoute(
            builder: (context) => const NotificationScreen());

      case NameRoutes.kProfileDetailsScreen:
        return MaterialPageRoute(builder: (context) => ProfileDetailsScreen());

      case NameRoutes.kProfileScreen:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());

      case NameRoutes.kRegisterScreen:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());

      case NameRoutes.kLoginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());

      case NameRoutes.kAppointmentsScreen:
        return MaterialPageRoute(
            builder: (context) => const AppointmentsScreen());

      case NameRoutes.kSettingScreen:
        return MaterialPageRoute(builder: (context) => SettingsScreen());

      case NameRoutes.kSearchForSpecialtiesScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForSpecialtiesScreen());

      case NameRoutes.kSearchForCityScreen:
        return MaterialPageRoute(
            builder: (context) => const SearchForCityScreen());

      case NameRoutes.kResultOfSearch:
        return MaterialPageRoute(
            builder: (context) => const ResultOfSearchScreen());
      case NameRoutes.kDoctorScreen:
        return MaterialPageRoute(builder: (context) => const DoctorScreen());

      case NameRoutes.kGenderScreen:
        return MaterialPageRoute(builder: (context) => const GenderScreen());

      default:
        return MaterialPageRoute(builder: (context) => const MainTestScreen());
    }
  }
}
