import 'package:dio/dio.dart';

import '../models/response/appointment_response.dart';
import '../models/response/booking_response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class BookingRepository extends BaseRepository {
  BookingRepository({required this.client});

  final BookingClient client;

  Future<BaseModel<List<BookingDay>>> days({
    int? doctorId,
    int? medicalCenterId,
    int? specializationId,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.days(
        doctorId: doctorId,
        medicalCenterId: medicalCenterId,
        specializationId: specializationId,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<BookingSlotsResponse>> slots({
    required String date,
    int? doctorId,
    int? medicalCenterId,
    int? specializationId,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.slots(
        date: date,
        doctorId: doctorId,
        medicalCenterId: medicalCenterId,
        specializationId: specializationId,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<AppointmentResponse>> preview({
    required int doctorId,
    required int? medicalCenterId,
    required String date,
    required String time,
    String? note,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.preview(
        doctorId: doctorId,
        medicalCenterId: medicalCenterId,
        date: date,
        time: time,
        note: note,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<AppointmentResponse>> createReservation({
    required int doctorId,
    required int? medicalCenterId,
    required String date,
    required String time,
    String? note,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.createReservation(
        doctorId: doctorId,
        medicalCenterId: medicalCenterId,
        date: date,
        time: time,
        note: note,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }
}
