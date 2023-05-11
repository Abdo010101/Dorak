import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';

import 'package:dorakpattient/data/repository/home_repo.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';
import '../../data/repository/repository.dart';

class HomeController extends ChangeNotifier {
  final _homeRepository = locator<HomeRepository>();
  bool isLoading = false;
  HomeResponse? homeData;

  Future<void> getHomeData(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _homeRepository.getHomeData();
      if (result.data != null) {
        homeData = result.data!;
        isLoading = false;
        notifyListeners();
      }
      {
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
