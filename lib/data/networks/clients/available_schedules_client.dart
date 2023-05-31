import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import '../../models/response/response.dart';
import '../network_constant.dart';

part 'available_schedules_client.g.dart';

@RestApi()
abstract class AvailableAppointmentClient {
  factory AvailableAppointmentClient(Dio dio, {String baseUrl}) =
      _AvailableAppointmentClient;

  @GET('{doctorId}${NetworkConstant.kAvailableSchedulesRequest}/{id}')
  Future<BaseResponse<AvailableSchedulesResponse>> getAvailableSchedulesByPlace(
      {@Path('id') int? doctorId, @Path('id') int? id});

  /*@POST(NetworkConstant.kMakeReservations)
  Future<BaseResponse<ReservationResponse>> makeReservations(@Body() data);*/
}
