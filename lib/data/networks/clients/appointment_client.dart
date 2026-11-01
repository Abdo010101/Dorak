import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'appointment_client.g.dart';

@RestApi()
abstract class AppointmentClient {
  factory AppointmentClient(Dio dio, {String baseUrl}) = _AppointmentClient;

  @GET('{type}?page={pageKey}')
  Future<BaseResponse<List<AppointmentResponse>>> getAllAppointments(
      @Path() String type, @Path('pageKey') int? pageKey);

  @POST(NetworkConstant.kCancelReservation)
  Future<BaseResponse<AppointmentResponse>> declineAppointment(
      @Body() var body);

  /// `GET /patient/reservations/{id}` — single reservation detail
  /// (scope §10.2). Returns the full `PatientReservationResource`.
  @GET('${NetworkConstant.kAppointment}/{id}')
  Future<BaseResponse<AppointmentResponse>> getReservation(
      @Path('id') int id);

  /// `POST /patient/reservations/{id}/reschedule {date, time}` — scope §10.2.
  /// Keeps the same id, flips status back to `pending`, returns the full
  /// reservation (backend answer Q1 in the gap report).
  @POST(
    '${NetworkConstant.kAppointment}/{id}/${NetworkConstant.kReservationReschedule}',
  )
  Future<BaseResponse<AppointmentResponse>> rescheduleReservation(
    @Path('id') int id,
    @Body() var body,
  );
}
