import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/material.dart';

import '../../data/repository/repository.dart';
import '../data/models/response/response.dart';

class OffersController extends DisposableProvider {
  bool isLoading = false;
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  List<OfferResponse> offers = [];
  AllOffersResponse searchResult = AllOffersResponse();
  final _offersRepository = locator<OffersRepository>();
  TextEditingController offerSearchController = TextEditingController();
  Map<String, dynamic> data = {};
  Future getAllOffers({bool? home}) async {
    try {
      home == true ? offerSearchController.clear() : null;
      isLoading = true;
      notifyListeners();
      data["title"] = offerSearchController.text;
      final result = await _offersRepository.getAllOffers(data);
      if (result.data != null) {
        searchResult = result.data!;
        offers = searchResult.offers!.data!;
        maxPrice = searchResult.maxPrice;
        minPrice = searchResult.minPrice;
        currentRangeValues =  RangeValues(double.parse(minPrice!), double.parse(maxPrice!));
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
