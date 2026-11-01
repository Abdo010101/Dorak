import 'package:dio/dio.dart';

import '../../models/response/appointment_response.dart';
import '../../models/response/booking_response.dart';
import '../network_constant.dart';

/// Dio-direct client for the new booking stepper (scope §10.1 + §10.2).
///
/// Flow: `GET /patient/booking/days` → `GET /patient/booking/slots?date=`
/// → `POST /patient/booking/preview` → `POST /patient/reservations`.
///
/// Clinic variant omits `medical_center_id` (post as explicit `null`).
class BookingClient {
  BookingClient(this._dio);

  final Dio _dio;

  Future<List<BookingDay>> days({
    int? doctorId,
    int? medicalCenterId,
    int? specializationId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kBookingDays,
      queryParameters: _nonNull({
        'doctor_id': doctorId,
        'medical_center_id': medicalCenterId,
        'specialization_id': specializationId,
      }),
    );
    final raw = res.data?['data'];
    if (raw is List) {
      return raw
          .whereType<Map<String, dynamic>>()
          .map(BookingDay.fromJson)
          .toList();
    }
    return const <BookingDay>[];
  }

  Future<BookingSlotsResponse> slots({
    required String date,
    int? doctorId,
    int? medicalCenterId,
    int? specializationId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kBookingSlots,
      queryParameters: _nonNull({
        'date': date,
        'doctor_id': doctorId,
        'medical_center_id': medicalCenterId,
        'specialization_id': specializationId,
      }),
    );
    final raw = res.data?['data'];
    if (raw is Map<String, dynamic>) {
      return BookingSlotsResponse.fromJson(raw);
    }
    return BookingSlotsResponse();
  }

  Future<AppointmentResponse> preview({
    required int doctorId,
    required int? medicalCenterId,
    required String date,
    required String time,
    String? note,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      NetworkConstant.kBookingPreview,
      data: <String, dynamic>{
        'doctor_id': doctorId,
        'medical_center_id': medicalCenterId, // explicit null for clinic
        'date': date,
        'time': time,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
    final raw = res.data?['data'];
    return AppointmentResponse.fromJson(
      raw is Map<String, dynamic> ? raw : const {},
    );
  }

  /// Final step. `POST /patient/reservations` (scope §10.2).
  Future<AppointmentResponse> createReservation({
    required int doctorId,
    required int? medicalCenterId,
    required String date,
    required String time,
    String? note,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      NetworkConstant.kAppointment,
      data: <String, dynamic>{
        'doctor_id': doctorId,
        'medical_center_id': medicalCenterId,
        'date': date,
        'time': time,
        if (note != null && note.isNotEmpty) 'note': note,
      },
    );
    final raw = res.data?['data'];
    return AppointmentResponse.fromJson(
      raw is Map<String, dynamic> ? raw : const {},
    );
  }

  Map<String, dynamic> _nonNull(Map<String, dynamic> src) => <String, dynamic>{
        for (final e in src.entries)
          if (e.value != null) e.key: e.value,
      };
}
