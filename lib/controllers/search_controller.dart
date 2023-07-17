import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class SearchResultController extends ChangeNotifier {
  bool isLoading = false;
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  List<Doctor> doctorsList = [];
  final _doctorsRepository = locator<DoctorsSearchResultRepository>();
  Map<String, dynamic> prams = {};

  Future<void> getDoctors(BuildContext context,
      {Map<String, dynamic>? data,
      int? cityId,
      int? areaId,
      double? lat,
      double? lng,
      int? doctorsBySpecialization,
      int? specializationId,
      int? medicalCenterId}) async {
    try {
      isLoading = true;
      notifyListeners();
      prams = {};

      if (data != null) {
        prams = data;
      }
      if (cityId != null) {
        prams['area_id'] = cityId;
      } else if (areaId != null) {
        prams['city_id'] = areaId;
      } else if (lat != null && lng != null) {
        prams['lat'] = lat;
        prams['lng'] = lng;
      }

      if (medicalCenterId != null) {
        prams['medical_center_id'] = medicalCenterId;
      }
      if (doctorsBySpecialization != null) {
        prams['specialization_id'] = doctorsBySpecialization;
      }
      if (specializationId != null) {
        if (context.mounted) {
          bool mainSpec = Provider.of<GeneralController>(context, listen: false)
              .isMainSpecialization;

          if (mainSpec) {
            prams['main_specialization_id'] = specializationId;
          } else {
            prams['specializations[]'] = specializationId;
          }
        }
      }
      isLoading = true;
      final result = await _doctorsRepository.getDoctors(prams);
      if (result.data != null) {
        doctorsList
          ..clear()
          ..addAll(result.data!.doctors!.data!);
        maxPrice = result.data?.maxPrice;
        minPrice = result.data?.minPrice;
        currentRangeValues = RangeValues(
            double.parse(minPrice ?? '0'), double.parse(maxPrice ?? '0'));
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
