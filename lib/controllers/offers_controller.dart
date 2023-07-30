import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../data/repository/repository.dart';
import '../data/models/response/response.dart';
import '../data/networks/network_constant.dart';
import '../routes/dorak_routes.dart';
import '../utis/util.dart';

class OffersController extends DisposableProvider {
  bool isLoading = false;
  String? maxPrice;
  String? minPrice;
  RangeValues? currentRangeValues;
  List<OfferResponse> offers = [];
  AllOffersResponse searchResult = AllOffersResponse();
  final _offersRepository = locator<OffersRepository>();
  PagingController<int, OfferResponse>? pagingController;
  TextEditingController offerSearchController = TextEditingController();
  Map<String, dynamic> data = {};

  startPagingControllerListener(
      {required bool? home, required BuildContext context}) {
    pagingController = PagingController<int, OfferResponse>(
      // 2
      firstPageKey: 1,
    );
    if (offerSearchController.text != '') {
      home == true ? offerSearchController.clear() : null;
    }
    pagingController?.addPageRequestListener((pageKey) {
      getAllOffers(pageKey: pageKey, context: context);
    });
  }

  Future getAllOffers(
      {required int pageKey, required BuildContext context}) async {
    try {
      data["title"] = offerSearchController.text;
      final result =
          await _offersRepository.getAllOffers(data, pageKey: pageKey);
      if (result.data != null) {
        searchResult = result.data!;
        offers = searchResult.offers!.data!;
        maxPrice = searchResult.maxPrice;
        minPrice = searchResult.minPrice;
        currentRangeValues =
            RangeValues(double.parse(minPrice!), double.parse(maxPrice!));
        final isLastPage = offers.length < NetworkConstant.kPageSize;
        if (isLastPage) {
          pagingController?.appendLastPage(offers);
        } else {
          final nextPageKey = pageKey + 1;
          pagingController?.appendPage(offers, nextPageKey);
        }
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                NameRoutes.kLoginScreen, (route) => false);
          }
          Util.showSnackBar(context, message: result.error?.message);
        }
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
