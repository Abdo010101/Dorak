import 'package:dio/dio.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class RateRepository extends BaseRepository {
  final RateClient rateClient;

  RateRepository({required this.rateClient});

  /// `POST /patient/app-ratings` — rate the app itself.
  Future<BaseModel> appRate(var body) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await rateClient.appRate(body).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<Ratings>> doctorRate(var body) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await rateClient.doctorRate(body).then((value) {
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
