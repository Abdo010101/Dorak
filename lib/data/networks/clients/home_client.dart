import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';

part 'home_client.g.dart';

@RestApi()
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;
  @GET(NetworkConstant.kHomeRequest)
  Future<BaseResponse<HomeResponse>> getHomeData();

  @GET('${NetworkConstant.kBestDoctors}?page={pageKey}')
  Future<BaseResponseList<Doctor>> getBestDoctors(
      @Path('pageKey') int? pageKey);

  @POST(NetworkConstant.kCancelReservation)
  Future<BaseResponse<AppointmentResponse>> declineAppointment(
      @Body() var body);
}
