import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/cupertino.dart';

import '../../data/repository/repository.dart';
import '../data/models/response/response.dart';

class OffersController extends DisposableProvider {
  bool isLoading = false;
  AllOffersResponse searchResult = AllOffersResponse();
  List<OfferResponse> offers = [];
  final _offersRepository = locator<OffersRepository>();

  TextEditingController offerSearchController = TextEditingController();

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
