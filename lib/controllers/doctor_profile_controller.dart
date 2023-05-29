import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/material.dart';
import '../../data/repository/repository.dart';

class DoctorProfileController extends DisposableProvider {
  bool isLoading = false;
  final _doctorProfileRepository = locator<DoctorProfileRepository>();

  Future<void> getHomeData(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();

      final result = await _doctorProfileRepository.getHomeData();
      if (result.data != null) {
        isLoading = false;
        notifyListeners();
      } else {
        //SnackBar(content: Text(result.error?.message), );
      }
    } on DioError catch (e) {
      //return Error(errorMessage: DioExceptions.fromDioError(e).message);

      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}
