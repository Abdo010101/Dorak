import 'package:dio/dio.dart';
import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/repository/home_repo.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/utis/helpers/app_providers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/models/response/response.dart';
import '../utis/util.dart';

class HomeController extends ChangeNotifier {
  final _homeRepository = locator<HomeRepository>();
  bool isLoading = false;
  bool isLoadingAppointment = false;
  HomeResponse? homeData;
  List<Doctor> bestDoctorsList = [];
  List<OfferResponse> latestOfferList = [];
  List<AppointmentResponse> appointmentList = [];
  List<Doctor> allBestDoctorsList = [];
  PagingController<int, Doctor>? pagingController;

  void startPagingController(BuildContext context) {
    pagingController = PagingController<int, Doctor>(
      // 2
      firstPageKey: 1,
    );
    pagingController?.addPageRequestListener((pageKey) {
      getBestDoctors(context, pageKey: pageKey);
    });
  }

  Future<void> getHomeData(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _homeRepository.getHomeData();
      if (result.data != null) {
        homeData = result.data!;
        bestDoctorsList
          ..clear()
          ..addAll(homeData!.bestDoctors!);
        latestOfferList
          ..clear()
          ..addAll(homeData!.latestOffers!);
        appointmentList
          ..clear()
          ..addAll(homeData!.patientReservations!);
        isLoading = false;
        notifyListeners();
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            AppProviders.disposeAllDisposableProviders(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                NameRoutes.kLoginScreen, (route) => false);
            Util.showSnackBar(context, message: result.error?.message);
          }
        }
        if (result.error != null) {
          if (context.mounted && result.error!.statusCode! >= 500) {
            Util.showSnackBar(context, message: AppStrings.kUnknownError.tr(),
                onTap: () async {
              await getHomeData(context);
            });
          }
        }
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  ///TODO Edit here Tomorrow . . . . . . . .
  Future<void> getBestDoctors(BuildContext context, {int? pageKey}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _homeRepository.getBestDoctors(pageKey);
      if (result.data != null) {
        allBestDoctorsList
          ..clear()
          ..addAll(result.data!);
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            AppProviders.disposeAllDisposableProviders(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                NameRoutes.kLoginScreen, (route) => false);
          }
          Util.showSnackBar(context, message: result.error?.message);
        }
        if (result.error != null) {
          if (context.mounted && result.error!.statusCode! >= 500) {
            Util.showSnackBar(context, message: AppStrings.kUnknownError.tr(),
                onTap: () async {
              await getBestDoctors(context, pageKey: pageKey);
            });
          }
        }
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> declineAppointment(int index) async {
    EasyLoading.show();
    notifyListeners();
    try {
      var data = {
        'id': appointmentList[index].id,
      };
      final result = await _homeRepository.declineAppointment(data);
      if (result.data != null) {
        appointmentList[index].status = AppStatus.cancelled.name;
      } else {
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      EasyLoading.dismiss();
      notifyListeners();
    }
  }
}
