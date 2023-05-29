import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/material.dart';

import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class GeneralController extends ChangeNotifier {
  final _generalRepository = locator<GeneralRepository>();
  GeneralResponse? generalResponse;
  /* List<GeneralData> subSpecializationList = [];
  List<GeneralData> areaList = [];
  List<MedicalCenterResponse> medicalCenterList = [];
  TermsPolicyResponse? terms;
  TermsPolicyResponse? policy;*/
  bool isLoading = false;
  getData() async {
    await getGeneralData();
    /*   await getMedicalCenters();
  */
  }

  Future<void> getGeneralData() async {
    try {
      final result = await _generalRepository.getGeneralData();
      if (result.data != null) {
        generalResponse = result.data;
        notifyListeners();
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  /* Future<void> getSubSpecialization(int specialId) async {
    try {
      final result =
          await _generalRepository.getSupSpecialization(specialId: specialId);
      if (result.data != null) {
        if (result.data!.subSpecializations != null) {
          subSpecializationList
            ..clear()
            ..addAll(result.data!.subSpecializations!);
        }
        notifyListeners();
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> getAreas(int cityId) async {
    try {
      final result = await _generalRepository.getAreas(cityId: cityId);
      if (result.data != null) {
        areaList
          ..clear()
          ..addAll(result.data!);

        notifyListeners();
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> getMedicalCenters() async {
    try {
      final result = await _generalRepository.getMedicalCenters();
      if (result.data != null) {
        medicalCenterList
          ..clear()
          ..addAll(result.data!);
        notifyListeners();
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  getTermsAndPolicy() async {
    await getTermsAndService();
    await getPrivacyAndPolicy();
  }

  Future<void> getTermsAndService() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _generalRepository.getTermsAndService();
      if (result.data != null) {
        terms = result.data;
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

  Future<void> getPrivacyAndPolicy() async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _generalRepository.getPrivacyAndPolicy();
      if (result.data != null) {
        policy = result.data;
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
  }*/
}
