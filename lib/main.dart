import 'dart:async';
import 'dart:io';

import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/core/router/app_router.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/doctor/logic/doctor_profile_cubit.dart';
import 'package:dorakpattient/features/notification/logic/notification_cubit.dart';
import 'package:dorakpattient/features/offers/logic/offers_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/search/logic/search_cubit.dart';
import 'package:dorakpattient/features/settings/logic/app_review_cubit.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import 'constants/constants.dart';
import 'core/theme/app_theme.dart';
import 'data/di/locator.dart';
import 'firebase_options.dart';

//IMPORT THESE PACKAGES ^^^
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
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
    throw 'Notification Err or $e';
  }

  runApp(
    EasyLocalization(
      supportedLocales: LanguageController.allLocales,
      path: 'assets/translations',
      // startLocale: const Locale("ar"),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Future<void> initUniLinks() async {
  //   try {
  //     Uri? initialLink = await getInitialUri();
  //   } on PlatformException {}
  // }

  @override
  Widget build(BuildContext context) {
    // initUniLinks();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(
          create: (_) => LanguageCubit(dio: InjectionClass.dio),
        ),
        BlocProvider<AppReviewCubit>(
          create: (_) => AppReviewCubit(
            rateRepository: locator<RateRepository>(),
          ),
        ),
        BlocProvider<GeneralCubit>(
          create: (_) => GeneralCubit(
            generalRepository: locator<GeneralRepository>(),
          ),
        ),
        BlocProvider<OffersCubit>(
          create: (_) => OffersCubit(
            offersRepository: locator<OffersRepository>(),
          ),
        ),
        BlocProvider<NotificationCubit>(
          create: (_) => NotificationCubit(
            notificationsRepository: locator<NotificationsRepository>(),
          ),
        ),
        BlocProvider<PatientProfileCubit>(
          create: (_) => PatientProfileCubit(
            profileRepository: locator<ProfileRepository>(),
          ),
        ),
        BlocProvider<AppointmentsCubit>(
          create: (_) => AppointmentsCubit(
            appointmentsRepository: locator<AppointmentsRepository>(),
          ),
        ),
        BlocProvider<DoctorProfileCubit>(
          create: (_) => DoctorProfileCubit(
            doctorProfileRepository: locator<DoctorProfileRepository>(),
          ),
        ),
        BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(
            searchResultRepository:
                locator<DoctorsSearchResultRepository>(),
          ),
        ),
      ],
      child: MultiProvider(
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
          //ToDo test And Complete
          FirebaseMessaging.onMessageOpenedApp.listen(
            (RemoteMessage message) {
              notificationsRoute = message.data['action'];
              if (notificationsRoute != null) {
                if (context.mounted) {
                  context
                      .read<MainScreenController>()
                      .onBottomSheetChanged(1, context);
                  AppRouter.router.go('/home');
                }
              }
            },
          );
          return MaterialApp.router(
            builder: EasyLoading.init(),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: AppStrings.kAppName,
            theme: AppTheme.light(locale: context.locale),
          );
        },
      ),
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
