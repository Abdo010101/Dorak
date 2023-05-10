import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/ui/screens/main_screen.dart';
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

      case NameRoutes.kRegisterScreen:
        return MaterialPageRoute(builder: (context) => const SignUpScreen());

      case NameRoutes.kLoginScreen:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      default:
        return MaterialPageRoute(builder: (context) => const MainTestScreen());
    }
  }
}
