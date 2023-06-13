import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class SearchResultController extends ChangeNotifier {
  bool isLoading = false;
  List<Doctor> doctorsList = [];
  final _doctorsRepository = locator<DoctorsSearchResultRepository>();

  Future<void> getDoctors(
      {int? cityId, double? lat, double? lng, int? specializationId}) async {
    try {
      Map<String, dynamic> prams = {};
      if (cityId != null) {
        prams['area_id'] = cityId;
      } else if (lat != null && lng != null) {
        prams['lat'] = lat;
        prams['lng'] = lng;
      }
      if (specializationId != null) {
        prams['specializations[]'] = 2;
      }

      isLoading = true;
      final result = await _doctorsRepository.getDoctors(prams);
      if (result.data != null) {
        doctorsList
          ..clear()
          ..addAll(result.data!.doctors!.data!);
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
