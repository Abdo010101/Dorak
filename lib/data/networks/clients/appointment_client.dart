import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'appointment_client.g.dart';

@RestApi()
abstract class AppointmentClient {
  factory AppointmentClient(Dio dio, {String baseUrl}) = _AppointmentClient;

  @GET('{type}')
  Future<BaseResponse<List<AppointmentResponse>>> getAllAppointments(
      @Path() String type);

  @POST(NetworkConstant.kCancelReservation)
  Future<BaseResponse<AppointmentResponse>> declineAppointment(
      @Body() var body);
}
