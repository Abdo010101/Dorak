import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../models/request/request.dart';
import '../models/response/response.dart';
import '../networks/clients/clients.dart';

class AuthenticationRepository extends BaseRepository {
  final AuthenticationClient authenticationClient;

  AuthenticationRepository({required this.authenticationClient});

  Future<BaseModel<Patient>> completeData({required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.completeData(body).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

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

  Future<BaseModel<UserResponse>> loginWithSocial(
      LoginWithSocialRequest model) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await authenticationClient.loginWithSocial(model).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> sendOtp({required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.sendOtp(body).then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> checkOtp(
      {required String phone, required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await authenticationClient.checkOtp(phone, body).then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> verifyOtp({required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.verifyOtp(body).then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> changePhone({required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.changePhone(body).then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> changePassword(
      {required String phone, required var body}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient
                .changePassword(phone, body)
                .then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<dynamic>> logout() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await authenticationClient.logout().then((value) {
          return value;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }
}
