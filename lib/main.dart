import 'dart:io';

import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/controllers/home_controller.dart';
import 'package:dorakpattient/controllers/offers_controller.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/routes/route_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/constants.dart';
import 'data/di/locator.dart';
import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "onBackGround: ${message.notification?.title}/${message.notification?.body}/${message.notification?.titleLocKey}");
  print("Handling a background message: ${message.messageId}");
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await setupLocator();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final RemoteMessage? remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {}
    await NotificationController.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {}
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
        ChangeNotifierProvider<DoctorProfileController>(
            create: (_) => DoctorProfileController()),
        ChangeNotifierProvider<MainScreenController>(
            create: (_) => MainScreenController()),
        ChangeNotifierProvider(create: (context) => GeneralController()),
        ChangeNotifierProvider(create: (context) => OffersController()),
        ChangeNotifierProvider(create: (context) => PatientProfileController()),
        ChangeNotifierProvider(create: (context) => AppointmentsController()),
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
            initialRoute: NameRoutes.kSplashScreen,
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

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
