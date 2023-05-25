import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../data/di/locator.dart';
import '../../data/shared/shared_pref.dart';
import '../../routes/dorak_routes.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    initData();
  }

  final _sharedPref = locator<SharedPref>();

  void initData() async {
    animationController =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    startAnimation();
    // authController = Provider.of<AuthController>(context, listen: false);
    // await authController.checkUserLoggedIn().then((value) => startAnimation());
    // if (context.mounted) {
    //   Provider.of<GeneralController>(context, listen: false).getData();
    // }
  }

  var animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.liteBlueWO,
            AppColors.liteBlue,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Center(
        child: Image.asset(
          AppAssets.kLogo,
          scale: 2,
        ),
      ),
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  startAnimation() async {
    animationController.forward();
    animationController.addListener(() {});
    animationController.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, NameRoutes.kWelcomeScreen);
        // if (authController.isLoggedIn) {
        //   // Doctor? doctor = authController.currentUser?.doctor;
        //   if (doctor?.titleId != null) {
        //
        //     if(doctor?.verifiedAt!=null) {
        //       // context.read<HomeController>().getHomeData(context);
        //       Navigator.pushReplacementNamed(context, NameRoutes.kHomeScreen);
        //     }
        //     else
        //       Navigator.pushReplacementNamed(context, NameRoutes.kWelcomeScreen);
        //
        //   } else {
        //     Navigator.pushReplacementNamed(context, NameRoutes.kWelcomeScreen);
        //   }
        //
        //   //Navigator.pushNamedAndRemoveUntil(context, NameRoutes.kHomeScreen,(_) => false);
        // } else {
        //   // Navigator.pushReplacementNamed(
        //   //     context,
        //   //     await _sharedPref.getFirstTime() ?? false
        //   //         ? NameRoutes.kWelcomeScreen
        //   //         : NameRoutes.kIntroScreen);
        //   // await _sharedPref.storeFirstTime();
        //   //Navigator.pushNamedAndRemoveUntil(context, NameRoutes.kWelcomeScreen,(_)=>false);
        // }
      } else {}
    });
  }
}
