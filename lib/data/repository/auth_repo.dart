import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../models/request/request.dart';
import '../models/response/response.dart';
import '../networks/clients/clients.dart';

class AuthenticationRepository extends BaseRepository {
  final AuthenticationClient authenticationClient;

  AuthenticationRepository({required this.authenticationClient});

  Future<BaseModel<UserResponse>> loginWithEmailAndPassword(
      LoginRequest model) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.login(model).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<UserResponse>> register(var model) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.register(model).then((value) {
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
