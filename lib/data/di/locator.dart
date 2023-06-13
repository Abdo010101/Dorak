import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/clients/general_client.dart';
import 'package:dorakpattient/data/repository/home_repo.dart';
import 'package:get_it/get_it.dart';

import '../networks/clients/clients.dart';
import '../networks/logging_interceptor.dart';
import '../networks/network_constant.dart';
import '../repository/repository.dart';
import '../shared/shared_pref.dart';

final locator = GetIt.instance;

Future setupLocator() async {
  /// retrofit clients
  ///

  ///Shared prefrences
  var instance = await SharedPref.getInstance();
  locator.registerSingleton<SharedPref>(instance);

  locator.registerFactory(() => AuthenticationClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => HomeClient(
        InjectionClass.dio,
      ));

  locator.registerFactory(() => GeneralClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => OffersClint(
        InjectionClass.dio,
      ));

  locator.registerFactory(() => DoctorProfileClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => ProfileClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => AppointmentClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => RateClient(
        InjectionClass.dio,
      ));

  locator.registerFactory(() => DoctorsSearchResultClient(
        InjectionClass.dio,
      ));

  locator.registerFactory(() => AvailableAppointmentClient(
        InjectionClass.dio,
      ));
  locator.registerFactory(() => NotificationClient(
        InjectionClass.dio,
      ));

  locator.registerFactory<AuthenticationRepository>(() =>
      AuthenticationRepository(
          authenticationClient: locator<AuthenticationClient>()));

  locator.registerFactory<HomeRepository>(
      () => HomeRepository(homeClient: locator<HomeClient>()));

  locator.registerFactory<GeneralRepository>(
      () => GeneralRepository(generalClient: locator<GeneralClient>()));

  locator.registerFactory<DoctorProfileRepository>(() =>
      DoctorProfileRepository(
          doctorProfileClient: locator<DoctorProfileClient>()));

  locator.registerFactory<OffersRepository>(
      () => OffersRepository(offersClient: locator<OffersClint>()));

  locator.registerFactory<ProfileRepository>(
      () => ProfileRepository(profileClient: locator<ProfileClient>()));

  locator.registerFactory<AppointmentsRepository>(() =>
      AppointmentsRepository(appointmentClient: locator<AppointmentClient>()));
  locator.registerFactory<DoctorsSearchResultRepository>(() =>
      DoctorsSearchResultRepository(
          searchResultClient: locator<DoctorsSearchResultClient>()));
  locator.registerFactory<RateRepository>(
      () => RateRepository(rateClient: locator<RateClient>()));

  locator.registerFactory<AvailableAppointmentRepository>(() =>
      AvailableAppointmentRepository(
          availableAppointmentClient: locator<AvailableAppointmentClient>()));

  locator.registerFactory<NotificationsRepository>(() =>
      NotificationsRepository(
          notificationsClient: locator<NotificationClient>()));
}

abstract class InjectionClass {
  static final Dio dio = Dio()
    ..interceptors.add(LoggingInterceptor())
    ..options.connectTimeout = 50000
    ..options.receiveTimeout = 50000
    ..options.receiveDataWhenStatusError = true
    ..options.baseUrl = NetworkConstant.kBaseUrl
    ..options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json, text/plain, /',
      'X-Requested-With': 'XMLHttpRequest',
      'Content-language': 'ar',
    };
}
