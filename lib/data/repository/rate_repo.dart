import 'package:dio/dio.dart';

import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class RateRepository extends BaseRepository {
  final RateClient rateClient;

  RateRepository({required this.rateClient});

  Future<BaseModel> addRate(var body) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await rateClient.addRate(body).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }
}
