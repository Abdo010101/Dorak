import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class SearchResultController extends ChangeNotifier {
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  final _doctorsRepository = locator<DoctorsSearchResultRepository>();
  Map<String, dynamic> prams = {};
  PagingController<int, Doctor>? pagingController;

  void startPagingControllerListener(
      {required int page, Map<String, dynamic>? data}) {
    pagingController = PagingController<int, Doctor>(
      // 2
      firstPageKey: 1,
    );
    if (data != null) {
      prams = data;
    }
    pagingController?.addPageRequestListener((pageKey) {
      getDoctors(pageKey: pageKey);
    });
  }

  Future<void> getDoctors(
      {required int? pageKey,
      int? cityId,
      int? areaId,
      double? lat,
      double? lng,
      int? doctorsBySpecialization,
      int? specializationId,
      int? medicalCenterId}) async {
    try {
      /*   if (cityId != null) {
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
      }*/
      /* if (specializationId != null) {
        if (context.mounted) {
          bool mainSpec = Provider.of<GeneralController>(context, listen: false)
              .isMainSpecialization;

          if (mainSpec) {
            prams['main_specialization_id'] = specializationId;
          } else {
            prams['specializations[]'] = specializationId;
          }
        }
      }*/
      print(prams);
      final result = await _doctorsRepository.getDoctors(prams, pageKey);

      if (result.data != null) {
        List<Doctor>? doctorList = result.data!.doctors?.data;

        if (doctorList == null && doctorList!.isEmpty) {
          return;
        }

        final isLastPage =
            result.data!.doctors!.data!.length < NetworkConstant.kPageSize;
        if (isLastPage) {
          pagingController?.appendLastPage(doctorList);
        } else {
          final nextPageKey = pageKey! + 1;
          pagingController?.appendPage(doctorList, nextPageKey);
        }

        maxPrice = result.data?.maxPrice;
        minPrice = result.data?.minPrice;
        currentRangeValues = RangeValues(
            double.parse(minPrice ?? '0'), double.parse(maxPrice ?? '0'));
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
