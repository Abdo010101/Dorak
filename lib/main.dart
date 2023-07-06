import 'dart:async';
import 'dart:io';

import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/routes/route_manger.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:uni_links/uni_links.dart';

import 'constants/constants.dart';
import 'data/di/locator.dart';
import 'firebase_options.dart';

//IMPORT THESE PACKAGES ^^^
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(
      "onBackGround: ${message.notification?.title}/${message.notification?.body}");
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
}

String? notificationsRoute;

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
    await NotificationController.initialize(
      flutterLocalNotificationsPlugin,
    );
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    throw 'Notification Error $e';
  }
  runApp(
    EasyLocalization(
      supportedLocales: LanguageController.allLocales,
      path: 'assets/translations',
      startLocale: const Locale("ar"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<void> initUniLinks() async {
    try {
      Uri? initialLink = await getInitialUri();
      print(initialLink);
    } on PlatformException {
      print('platfrom exception unilink');
    }
  }

  @override
  Widget build(BuildContext context) {
    initUniLinks();

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
        ChangeNotifierProvider(create: (context) => SearchController()),
        ChangeNotifierProvider(create: (context) => SearchResultController()),
        ChangeNotifierProvider(create: (context) => AppReviewController()),
        ChangeNotifierProvider(create: (context) => LanguageController()),
        ChangeNotifierProvider(create: (context) => VerifyController()),
        ChangeNotifierProvider(create: (context) => NotificationController()),
        ChangeNotifierProvider(create: (context) => FilterController()),
        ChangeNotifierProvider(
            create: (context) => ReservationAppointmentController()),
      ],
      child: Sizer(
        builder: (BuildContext context, Orientation orientation,
            DeviceType deviceType) {
          context.read<LanguageController>().checkStatus =
              EasyLocalization.of(context)?.currentLocale == const Locale('en')
                  ? 'English'
                  : 'عربى';

          EasyLoading.instance
            ..indicatorColor = AppColors.liteBlueWO
            ..textColor = AppColors.white
            ..maskColor = AppColors.transparent
            ..maskType = EasyLoadingMaskType.custom
            ..backgroundColor = AppColors.white
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorType = EasyLoadingIndicatorType.cubeGrid;

          FirebaseMessaging.onMessageOpenedApp.listen((event) {
            print("${event.data['action']}");
            notificationsRoute = event.data['action'];
            print('Print Open Notification');

            if (notificationsRoute != null) {
              context.read<AppointmentsController>().getAllAppointments();
              context
                  .read<MainScreenController>()
                  .onBottomSheetChanged(1, context);
            }
          });

          return MaterialApp(
            builder: EasyLoading.init(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: EasyLocalization.of(context)?.currentLocale,
            onGenerateRoute: RouteManger.generateRouter,
            debugShowCheckedModeBanner: false,
            title: AppStrings.kAppName,
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
