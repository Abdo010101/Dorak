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
  int? currentPlaceSelected;
  Places? selectedPlace;
  Future<void> getDoctorProfile(BuildContext context,
      {required int doctorId}) async {
    try {
      isLoading = true;
      notifyListeners();

      final result =
          await _doctorProfileRepository.getDoctorProfile(doctorId: doctorId);
      if (result.data != null) {
        doctorProfileResponse = result.data;
        if (doctorProfileResponse?.places != null &&
            doctorProfileResponse!.places!.isNotEmpty) {
          selectedPlace = doctorProfileResponse?.places![0];
          currentPlaceSelected = 0;
        }
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

  void onChangedSelectPlace(int index) {
    currentPlaceSelected = index;
    selectedPlace = doctorProfileResponse!.places![index];
    notifyListeners();
  }

  @override
  void disposeValues() {
    currentPlaceSelected = 0;
  }
}
