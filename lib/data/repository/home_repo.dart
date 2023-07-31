import 'package:dio/dio.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../../utis/util.dart';
import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';

class HomeRepository extends BaseRepository {
  final HomeClient homeClient;

  HomeRepository({required this.homeClient});

  Future<BaseModel<HomeResponse>> getHomeData() async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await homeClient.getHomeData().then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<List<Doctor>>> getBestDoctors(int? pageKey) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await homeClient.getBestDoctors(pageKey).then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  Future<BaseModel<AppointmentResponse>> declineAppointment(var type) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await homeClient.declineAppointment(type).then((value) {
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
