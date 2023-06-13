import 'package:dio/dio.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';

class DoctorProfileRepository extends BaseRepository {
  final DoctorProfileClient doctorProfileClient;

  DoctorProfileRepository({required this.doctorProfileClient});

  Future<BaseModel<DoctorProfileResponse>> getDoctorProfile(
      {int? doctorId}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await doctorProfileClient
                .getDoctorProfile(id: doctorId)
                .then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }

  ///TODO offer here tomorrow  ....
  /*Future<BaseModel<DoctorProfileResponse>> getDoctorProfile(
      {int? doctorId}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await doctorProfileClient
                .getDoctorProfile(id: doctorId)
                .then((value) {
          return value.data;
        }));
      } on DioError catch (e) {
        return BaseModel(error: ErrorResponse(dioError: e));
      }
    } else {
      return BaseModel.noNetworkConnection();
    }
  }*/
}
