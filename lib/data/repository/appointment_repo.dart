import 'package:dio/dio.dart';

import '../models/response/response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'base_repo.dart';

class AppointmentsRepository extends BaseRepository {
  final AppointmentClient appointmentClient;

  AppointmentsRepository({required this.appointmentClient});

  Future<BaseModel<List<AppointmentResponse>>> getAllAppointments(String type,
      {int? pageKey}) async {
    if (await checkForConnectivity()) {
      try {
        return BaseModel(
            data: await appointmentClient
                .getAllAppointments(type, pageKey)
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

  /// `GET /patient/reservations/{id}`.
  Future<BaseModel<AppointmentResponse>> getReservation(int id) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final res = await appointmentClient.getReservation(id);
      return BaseModel(data: res.data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  /// `POST /patient/reservations/{id}/reschedule {date, time}` — keeps the
  /// same id, flips status back to `pending`.
  Future<BaseModel<AppointmentResponse>> reschedule(
    int id, {
    required String date,
    required String time,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final res = await appointmentClient
          .rescheduleReservation(id, {'date': date, 'time': time});
      return BaseModel(data: res.data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }
}
