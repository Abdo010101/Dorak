import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

import '../constants/strings.dart';
import '../data/models/response/response.dart';
import 'controllers.dart';

class FilterController extends DisposableProvider {
  bool specialtyMainToggle = false;
  bool subSpecialtyToggle = false;
  bool availabilityToggle = false;
  bool genderToggle = false;
  bool titleToggle = false;
  int? mainSpecialtyIndex;
  String? arrangeBy;
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  List<int>? subSpecialtyIndexes;
  List<Titles> mainSpecialtyList = [];
  List<Titles> subSpecialtyList = [];
  List<Titles> titlesList = [];
  List<Titles> availabilityList = [
    Titles(name: AppStrings.kAnyDay.tr()),
    Titles(name: AppStrings.kToday.tr()),
    Titles(name: AppStrings.kTomorrow.tr())
  ];
  List<Titles> genderList = [
    Titles(name: AppStrings.kGenderList[0].tr()),
    Titles(name: AppStrings.kGenderList[1].tr()),
  ];

  resetData() {
    if (mainSpecialtyIndex != null) {
      mainSpecialtyList[mainSpecialtyIndex!].icon = '0';
    }
    subSpecialtyList = [];
    availabilityList = [
      Titles(name: AppStrings.kAnyDay.tr()),
      Titles(name: AppStrings.kToday.tr()),
      Titles(name: AppStrings.kTomorrow.tr())
    ];
    genderList = [
      Titles(name: AppStrings.kGenderList[0].tr()),
      Titles(name: AppStrings.kGenderList[1].tr()),
    ];
    specialtyMainToggle = false;
    subSpecialtyToggle = false;
    availabilityToggle = false;
    genderToggle = false;
    titleToggle = false;
    mainSpecialtyIndex = null;
    currentRangeValues = RangeValues(
        double.parse(minPrice ?? '0'), double.parse(maxPrice ?? '0'));
    notifyListeners();
  }

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
      EasyLoading.show();
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

  void changeArrangeBy(String? value) {
    arrangeBy = value;
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
    } else {
      titlesList[index].icon = '1';
    }
    notifyListeners();
  }

  changeRange(RangeValues value) {
    currentRangeValues = value;
    notifyListeners();
  }

  filterOffer(BuildContext context) {
    String? genderName;
    for (var gender in genderList) {
      if (gender.icon == '1') {
        genderName = gender.name;
      }
    }
    String? availabilityName;
    for (var availability in availabilityList) {
      if (availability.icon == '1' && availability.name != AppStrings.kAnyDay) {
        availabilityName = availability.name;
      }
    }
    List<int> tittlesId = [];
    for (var tittle in titlesList) {
      if (tittle.icon == '1') {
        tittlesId.add(tittle.id!.toInt());
      }
    }
    List<int> subSpecialtiesId = [];
    for (var subSpecialty in subSpecialtyList) {
      if (subSpecialty.icon == '1') {
        subSpecialtiesId.add(subSpecialty.id!.toInt());
      }
    }
    if (mainSpecialtyIndex != null) {
      subSpecialtiesId.add(mainSpecialtyList[mainSpecialtyIndex!].id!);
    }

    Map<String, dynamic> filterData = {
      'sub_specializations[]': subSpecialtiesId,
      'availability': availabilityName,
      'gender': genderName,
      'title_ids[]': tittlesId,
      'minPrice': currentRangeValues?.start.toInt(),
      'maxPrice': currentRangeValues?.end.toInt(),
      'arrange_by': arrangeBy,
    };
    context.read<OffersController>().data = filterData;
  }

  filterDoctors(BuildContext context,
      {double? lat, double? lng, int? cityId, int? city, int? areaId}) {
    try {
      Map<String, dynamic> filterData = {};

      String? genderName;
      for (var gender in genderList) {
        if (gender.icon == '1') {
          genderName = gender.name;
        }
      }
      if (genderName != null) {
        filterData['gender'] = genderName;
      }

      if (lat != null) {
        filterData['lat'] = lat;
      }
      if (lng != null) {
        filterData['lng'] = lng;
      }
      if (cityId != null) {
        filterData['city_id'] = cityId;
      } else if (areaId != null) {
        filterData['area_id'] = areaId;
      }
      String? availabilityName;
      for (var availability in availabilityList) {
        if (availability.icon == '1' &&
            availability.name != AppStrings.kAnyDay) {
          availabilityName = availability.name;
        }
      }
      if (availabilityName != null) {
        filterData['availability'] = availabilityName;
      }

      List<int> tittlesId = [];
      for (var tittle in titlesList) {
        if (tittle.icon == '1') {
          tittlesId.add(tittle.id!.toInt());
        }
      }
      if (tittlesId.isNotEmpty) {
        filterData['titles[]'] = tittlesId;
      }

      List<int> subSpecialtiesId = [];
      for (var subSpecialty in subSpecialtyList) {
        if (subSpecialty.icon == '1') {
          subSpecialtiesId.add(subSpecialty.id!.toInt());
        }
      }
      if (mainSpecialtyIndex != null) {
        subSpecialtiesId.add(mainSpecialtyList[mainSpecialtyIndex!].id!);
      }
      if (subSpecialtiesId != []) {
        filterData['specializations[]'] = subSpecialtiesId;
      }
      filterData['minPrice'] = currentRangeValues?.start.toInt();
      filterData['maxPrice'] = currentRangeValues?.end.toInt();
      filterData['arrange_by'] = arrangeBy;

      context.read<SearchResultController>().prams = filterData;
    } on DioError catch (e) {
    } finally {}
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}
