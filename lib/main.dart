import 'dart:async';
import 'dart:io';

import 'package:dorakpattient/core/router/app_router.dart';
import 'package:dorakpattient/core/services/notification_service.dart';
import 'package:dorakpattient/core/theme/app_theme.dart';
import 'package:dorakpattient/core/ui_kit/ui_kit.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/features/appointment/logic/appointments_cubit.dart';
import 'package:dorakpattient/features/appointment/logic/booking_cubit.dart';
import 'package:dorakpattient/features/auth/logic/auth_cubit.dart';
import 'package:dorakpattient/features/discovery/logic/discovery_cubit.dart';
import 'package:dorakpattient/features/center/presentation/cubit/center_details_cubit.dart';
import 'package:dorakpattient/features/center/presentation/cubit/clinic_details_cubit.dart';
import 'package:dorakpattient/features/center/presentation/cubit/doctors_at_center_cubit.dart';
import 'package:dorakpattient/features/doctor/logic/doctor_profile_cubit.dart';
import 'package:dorakpattient/features/favourites/logic/favourites_cubit.dart';
import 'package:dorakpattient/features/home/logic/bottom_nav_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/home_cubit.dart';
import 'package:dorakpattient/features/notification/logic/notification_cubit.dart';
import 'package:dorakpattient/features/offers/logic/offers_cubit.dart';
import 'package:dorakpattient/features/profile/logic/patient_profile_cubit.dart';
import 'package:dorakpattient/features/search/logic/search_cubit.dart';
import 'package:dorakpattient/features/settings/logic/app_review_cubit.dart';
import 'package:dorakpattient/features/settings/logic/language_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

String? notificationsRoute;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  await EasyLocalization.ensureInitialized();
  AppStatusView.labelsBuilder = (ctx) => AppStatusViewLabels(
        errorTitle: 'something_went_wrong'.tr(),
        retryLabel: 'retry'.tr(),
        emptyTitle: 'no_data_found'.tr(),
      );
  // TODO(auth): remove when mock auth phase ends — wipes stored session so
  // every launch starts from the phone screen. Guarded by kDebugMode to
  // keep release builds safe.
  if (kDebugMode) {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
  await setupLocator();
  HttpOverrides.global = MyHttpOverrides();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  try {
    final remoteMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (remoteMessage != null) {}
    await NotificationService.initialize(flutterLocalNotificationsPlugin);
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  } catch (e) {
    throw 'Notification err: $e';
  }

  runApp(
    EasyLocalization(
      supportedLocales: LanguageCubit.supportedLocales,
      path: 'assets/translations',
      startLocale: const Locale('ar'),
      fallbackLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
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
            favouritesRepository: locator<FavouritesRepository>(),
          ),
        ),
        BlocProvider<SearchCubit>(
          create: (_) => SearchCubit(
            discoveryRepository: locator<DiscoveryRepository>(),
          ),
        ),
        BlocProvider<DiscoveryCubit>(
          create: (_) => DiscoveryCubit(
            repo: locator<DiscoveryRepository>(),
          ),
        ),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(
            authenticationRepository: locator<AuthenticationRepository>(),
            sharedPref: locator<SharedPref>(),
          ),
        ),
        BlocProvider<HomeCubit>(
          create: (_) => HomeCubit(
            homeRepository: locator<HomeRepository>(),
          ),
        ),
        BlocProvider<BottomNavCubit>(create: (_) => BottomNavCubit()),
        BlocProvider<BookingCubit>(
          create: (_) => BookingCubit(
            bookingRepository: locator<BookingRepository>(),
          ),
        ),
        BlocProvider<CenterDetailsCubit>(
          create: (_) => CenterDetailsCubit(
            repo: locator<CentersRepository>(),
            favouritesRepo: locator<FavouritesRepository>(),
          ),
        ),
        BlocProvider<DoctorsAtCenterCubit>(
          create: (_) =>
              DoctorsAtCenterCubit(repo: locator<CentersRepository>()),
        ),
        BlocProvider<ClinicDetailsCubit>(
          create: (_) => ClinicDetailsCubit(
            repo: locator<CentersRepository>(),
            favouritesRepo: locator<FavouritesRepository>(),
          ),
        ),
        BlocProvider<FavouritesCubit>(
          create: (_) => FavouritesCubit(repo: locator<FavouritesRepository>()),
        ),
      ],
      child: Sizer(
        builder: (ctx, _, __) {
          EasyLoading.instance
            ..indicatorColor = const Color(0xFF1F8046)
            ..textColor = Colors.white
            ..maskColor = Colors.transparent
            ..maskType = EasyLoadingMaskType.custom
            ..backgroundColor = Colors.white
            ..loadingStyle = EasyLoadingStyle.custom
            ..indicatorType = EasyLoadingIndicatorType.cubeGrid;

          FirebaseMessaging.onMessageOpenedApp.listen(
            (message) {
              notificationsRoute = message.data['action'];
              if (notificationsRoute != null) {
                AppRouter.router.go('/home');
              }
            },
          );

          return MaterialApp.router(
            builder: EasyLoading.init(),
            localizationsDelegates: ctx.localizationDelegates,
            supportedLocales: ctx.supportedLocales,
            locale: ctx.locale,
            routerConfig: AppRouter.router,
            debugShowCheckedModeBanner: false,
            title: 'Dorak',
            theme: AppTheme.light(locale: ctx.locale),
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
