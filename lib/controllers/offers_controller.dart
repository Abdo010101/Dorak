import 'package:dio/dio.dart';
import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/material.dart';

import '../../data/repository/repository.dart';
import '../data/models/response/response.dart';

class OffersController extends DisposableProvider {
  bool isLoading = false;
  bool specialtyMainToggle = false;
  bool subSpecialtyToggle = false;
  bool availabilityToggle = false;
  bool genderToggle = false;
  bool titleToggle = false;
  int? mainSpecialtyIndex;
  int? tittleIndex;
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  List<int>? subSpecialtyIndexes;
  List<Titles> mainSpecialtyList = [];
  List<Titles> subSpecialtyList = [];
  List<Titles> titlesList = [];
  List<Titles> availabilityList = [
    Titles(name: 'Any day'),
    Titles(name: AppStrings.kToday),
    Titles(name: 'Tomorrow')
  ];
  List<Titles> genderList = [
    Titles(name: AppStrings.kGenderList[0]),
    Titles(name: AppStrings.kGenderList[1]),
  ];
  List<OfferResponse> offers = [];
  List<int> subSpecialtyChosen = [];
  AllOffersResponse searchResult = AllOffersResponse();
  final _offersRepository = locator<OffersRepository>();
  TextEditingController offerSearchController = TextEditingController();

  openMainSpecialty() {
    specialtyMainToggle = !specialtyMainToggle;
    notifyListeners();
  }

  openSubSpecialty() {
    subSpecialtyToggle = !subSpecialtyToggle;
    notifyListeners();
  }

  openAvailability() {
    availabilityToggle = !availabilityToggle;
    notifyListeners();
  }

  openGender() {
    genderToggle = !genderToggle;
    notifyListeners();
  }

  openTitle() {
    titleToggle = !titleToggle;
    notifyListeners();
  }

  mainSpecialtySelect(int index) {
    if (mainSpecialtyList[index].icon == '1') {
      mainSpecialtyList[index].icon = '0';
      mainSpecialtyIndex = null;
    } else {
      mainSpecialtyList[index].icon = '1';
      subSpecialtyToggle = false;
      subSpecialtyList.clear();
      if (mainSpecialtyIndex != null) {
        mainSpecialtyList[mainSpecialtyIndex!].icon = '0';
      }
      mainSpecialtyIndex = index;
    }
    notifyListeners();
  }

  subSpecialtySelect(int index) {
    if (subSpecialtyList[index].icon == '1') {
      subSpecialtyList[index].icon = '0';
    } else {
      subSpecialtyList[index].icon = '1';
    }
    notifyListeners();
  }

  availabilitySelect(int index) {
    if (availabilityList[index].icon == '1') {
      availabilityList[index].icon = '0';
    } else {
      availabilityList[0].icon = '0';
      availabilityList[1].icon = '0';
      availabilityList[2].icon = '0';
      availabilityList[index].icon = '1';
    }
    notifyListeners();
  }

  genderSelect(int index) {
    if (genderList[index].icon == '1') {
      genderList[index].icon = '0';
    } else {
      genderList[0].icon = '0';
      genderList[1].icon = '0';
      genderList[index].icon = '1';
    }
    notifyListeners();
  }

  tittleSelect(int index) {
    if (titlesList[index].icon == '1') {
      titlesList[index].icon = '0';
      tittleIndex = null;
    } else {
      titlesList[index].icon = '1';
      if (tittleIndex != null) {
        titlesList[tittleIndex!].icon = '0';
      }
      tittleIndex = index;
    }
    notifyListeners();
  }

  changeRange(RangeValues value) {
    currentRangeValues = value;
    notifyListeners();
  }

  Future<void> getAllOffers({bool? home}) async {
    try {
      home == true ? offerSearchController.clear() : null;
      isLoading = true;
      notifyListeners();
      var data = {
        'title': offerSearchController.text,
      };
      final result = await _offersRepository.getAllOffers(data);
      if (result.data != null) {
        searchResult = result.data!;
        offers = searchResult.offers!.data!;
        maxPrice = searchResult.maxPrice;
        minPrice = searchResult.minPrice;
        currentRangeValues = RangeValues(
            double.parse(minPrice ?? '0'), double.parse(maxPrice ?? '0'));
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
