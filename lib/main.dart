import 'package:dorakpattient/controllers/auth/login_controller.dart';
import 'package:dorakpattient/controllers/auth/register_controller.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/controllers/home_controller.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/routes/route_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/constants.dart';
import 'data/di/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale("ar"),
        Locale("en"),
      ],
      path: 'assets/translations',
      startLocale: const Locale("en"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>(
            create: (_) => LoginController()),
        ChangeNotifierProvider<HomeController>(create: (_) => HomeController()),
        ChangeNotifierProvider<AuthController>(create: (_) => AuthController()),
        ChangeNotifierProvider<RegisterController>(
            create: (_) => RegisterController()),
        ChangeNotifierProvider<MainScreenController>(
            create: (_) => MainScreenController())
      ],
      child: Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          return MaterialApp(
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: EasyLocalization.of(context)?.currentLocale,
            onGenerateRoute: RouteManger.generateRouter,
            debugShowCheckedModeBanner: false,
            title: AppStrings.kAppName.tr(),
            initialRoute: NameRoutes.kMainTestScreen,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            //   home: const MainTestScreen(),
          );
        },
      ),
    );
  }
}
