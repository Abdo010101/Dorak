import 'package:dio/dio.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';

import '../../data/repository/repository.dart';
import '../data/models/response/response.dart';

class OffersController extends DisposableProvider {
  bool isLoading = false;
  AllOffersResponse searchResult = AllOffersResponse();
  List<OfferResponse> offers = [];
  final _offersRepository = locator<OffersRepository>();

  Future<void> getAllOffers() async {
    try {
      isLoading = true;
      notifyListeners();
      var data = {
        'title': '',
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
