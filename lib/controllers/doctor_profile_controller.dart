import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:flutter/material.dart';

import '../../data/repository/repository.dart';

class DoctorProfileController extends DisposableProvider {
  bool isLoading = false;
  final _doctorProfileRepository = locator<DoctorProfileRepository>();
  DoctorProfileResponse? doctorProfileResponse;
  Future<void> getDoctorProfile(BuildContext context,
      {required int doctorId}) async {
    try {
      isLoading = true;
      notifyListeners();
      final result =
          await _doctorProfileRepository.getDoctorProfile(doctorId: doctorId);
      if (result.data != null) {
        doctorProfileResponse = result.data;
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
