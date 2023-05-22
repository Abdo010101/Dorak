import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/repository/home_repo.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/utis/helpers/app_providers.dart';
import 'package:flutter/cupertino.dart';
import '../../data/models/response/response.dart';

class HomeController extends ChangeNotifier {
  final _homeRepository = locator<HomeRepository>();
  bool isLoading = false;
  HomeResponse? homeData;
  List<BestDoctors> bestDoctorsList = [];

  // List<BestDoctors> bestDoctorsList = [];
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
        isLoading = false;
        notifyListeners();
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            AppProviders.disposeAllDisposableProviders(context);
            Navigator.of(context).pushNamedAndRemoveUntil(
                NameRoutes.kLoginScreen, (route) => false);
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
}
