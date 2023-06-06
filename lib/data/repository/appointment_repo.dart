import 'package:dio/dio.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'base_repo.dart';

class AppointmentsRepository extends BaseRepository {
  final AppointmentClient appointmentClient;

  AppointmentsRepository({required this.appointmentClient});

  Future<BaseModel<List<AppointmentResponse>>> getAllAppointments(
      String type) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data:
                await appointmentClient.getAllAppointments(type).then((value) {
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
            data:
                await appointmentClient.declineAppointment(type).then((value) {
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
