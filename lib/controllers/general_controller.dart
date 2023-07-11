import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../data/models/response/response.dart';
import '../data/repository/repository.dart';

class GeneralController extends ChangeNotifier {
  final _generalRepository = locator<GeneralRepository>();
  GeneralResponse? generalResponse;
  List<Titles> tittleList = [];
  List<Titles> specializationList = [];
  List<Titles> originalSubSpecializationList = [];
  List<Titles> subSpecializationList = [];

  List<Titles> citiesList = [];
  List<Titles> areaList = [];
  List<Titles> originalAreaList = [];
  List<Titles> originalCityList = [];
  SearchResultResponse? searchResultResponse;
  double? lat;
  double? lng;
  String? specializationName;
  int? specializationId;

  // For Save value of SpecializationId
  int? specId;
  int? cityId;
  int? areaId;

  /* List<GeneralData> subSpecializationList = [];
  List<GeneralData> areaList = [];
  List<MedicalCenterResponse> medicalCenterList = [];*/
  TermsPolicyResponse? terms;
  TermsPolicyResponse? policy;
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
        tittleList
          ..clear()
          ..addAll(generalResponse!.titles!);
        specializationList
          ..clear()
          ..addAll(generalResponse!.mainSpecializations!);
        originalAreaList
          ..clear()
          ..addAll(generalResponse!.cities!);
        areaList
          ..clear()
          ..addAll(generalResponse!.cities!);
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

  Future<void> getCities(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _generalRepository.getCityByArea(id);
      if (result.data != null) {
        originalCityList
          ..clear()
          ..addAll(result.data!);

        citiesList
          ..clear()
          ..addAll(result.data!);
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getSubSpeciality(int id) async {
    specializationId = id;
    try {
      isLoading = true;
      notifyListeners();
      final result = await _generalRepository.getSubSpeciality(id);
      if (result.data != null) {
        originalSubSpecializationList
          ..clear()
          ..addAll(result.data!);

        subSpecializationList
          ..clear()
          ..addAll(result.data!);
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> search(String text) async {
    if (text.isNotEmpty) {
      specializationList
        ..clear()
        ..addAll(generalResponse!.mainSpecializations!
            .where((element) => element.name!.toLowerCase().contains(text)));
    } else {
      specializationList
        ..clear()
        ..addAll(generalResponse!.mainSpecializations!);
    }
    notifyListeners();
  }

  Future<void> searchByName(String text) async {
    try {
      Map<String, dynamic> prams = {'name': text, 'lat': lat, 'lng': lng};

      isLoading = true;
      notifyListeners();
      final result = await _generalRepository.getSearchByName(prams);
      if (result.data != null) {
        searchResultResponse = result.data;
      } else {
        // GetSnackBar(message: (result.error?.message));
      }
    } on DioError catch (e) {
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      // GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchSubSpecialization(String text) async {
    if (text.isNotEmpty) {
      subSpecializationList
        ..clear()
        ..addAll(originalSubSpecializationList
            .where((element) => element.name!.toLowerCase().contains(text)));
    } else {
      subSpecializationList
        ..clear()
        ..addAll(originalSubSpecializationList);
    }
    notifyListeners();
  }

  Future<void> areaSearch(String text) async {
    if (text.isNotEmpty) {
      areaList
        ..clear()
        ..addAll(originalAreaList
            .where((element) => element.name!.toLowerCase().contains(text)));
    } else {
      areaList
        ..clear()
        ..addAll(originalAreaList);
    }
    notifyListeners();
  }

  Future<void> citySearch(String text) async {
    if (text.isNotEmpty) {
      citiesList
        ..clear()
        ..addAll(originalCityList
            .where((element) => element.name!.toLowerCase().contains(text)));
    } else {
      citiesList
        ..clear()
        ..addAll(originalCityList);
    }
    notifyListeners();
  }

  void onSpecializationChange(int id, String name) {
    specializationId = id;
    specId = id;
    specializationName = name;
  }

  void onSelectedCity(int id) {
    cityId = id;
  }

  Future<void> getCurrentLocation(BuildContext context) async {
    var result = await handleLocationPermission(context);

    if (result) {
      Position? position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      lat = position.latitude;
      lng = position.longitude;

      Provider.of<SearchResultController>(context, listen: false)
          .getDoctors(lat: lat, lng: lng, specializationId: specializationId);
      Navigator.of(context).pushNamed(NameRoutes.kResultOfSearch);
    }
  }

  Future<bool> handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
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
  }*/

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
  }

  Future<bool> onWillPop(BuildContext context) async {
    specializationId = specId;
    Navigator.pop(context);
    return false;
  }
}
