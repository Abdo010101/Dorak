import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../data/di/locator.dart';
import '../data/models/request/rate_request.dart';
import '../data/repository/repository.dart';
import '../utis/util.dart';

class AppReviewController extends ChangeNotifier {
  double ratting = 0;
  TextEditingController rateController = TextEditingController();

  final _rateRepository = locator<RateRepository>();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<dynamic> addRate(BuildContext context) async {
    notifyListeners();
    if (formKey.currentState?.validate() != true || ratting == 0) return false;
    formKey.currentState?.save();
    isLoading = true;
    notifyListeners();
    try {
      final result = await _rateRepository.addRate(
          RateRequest(comment: rateController.text, rate: ratting.toInt()));
      isLoading = false;
      if (result.data != null) {
        notifyListeners();
        Navigator.pop(context);
        ratting = 0;
        rateController.text = '';
        return true;
      } else {
        notifyListeners();
        Util.showSnackBar(context, message: result.error?.message);
        return false;
      }
    } on DioError catch (e) {
      Util.showSnackBar(context, message: e.message);
      return false;
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  changeRatting(double newRatting) {
    ratting = newRatting;
    notifyListeners();
  }

  void resetController() {
    isLoading = false;
    ratting = 0;
    rateController.clear();
  }
}
