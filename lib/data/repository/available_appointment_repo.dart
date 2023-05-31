import 'package:dio/dio.dart';
import 'package:dorakpattient/data/repository/repository.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';

class AvailableAppointmentRepository extends BaseRepository {
  final AvailableAppointmentClient availableAppointmentClient;

  AvailableAppointmentRepository({required this.availableAppointmentClient});

  /*Future<BaseModel<AvailableSchedulesResponse>> getAvailableSchedules({
    required int doctorId,
    int? id,
  }) async {
    if (await checkForConnectivity()) {
      try {
        return id == null
            ? BaseModel(
                data: await availableAppointmentClient
                    .getAvailableSchedules()
                    .then((value) {
                return value.data;
              }))
            : BaseModel(
                data: await availableAppointmentClient
                    .getAvailableSchedulesByPlace(data: id)
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
*/
  /* Future<BaseModel<ReservationResponse>> makeReservations(
      {Map<String, dynamic>? data}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await availableAppointmentClient
                .makeReservations(data)
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
