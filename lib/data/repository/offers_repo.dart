import 'package:dio/dio.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../../utis/util.dart';
import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';

class OffersRepository extends BaseRepository {
  final OffersClint offersClient;

  OffersRepository({required this.offersClient});

  Future<BaseModel<AllOffersResponse>> getAllOffers(var data,
      {int? pageKey}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await offersClient.getAllOffers(data, pageKey).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      Util.kToastNOInternet();
      return BaseModel.noNetworkConnection();
    }
  }
}
