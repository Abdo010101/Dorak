import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'rate_client.g.dart';

@RestApi()
abstract class RateClient {
  factory RateClient(Dio dio, {String baseUrl}) = _RateClient;

  /// `POST /patient/app-ratings {rate, comment?}` — rates the app itself.
  @POST(NetworkConstant.kAppRatings)
  Future<BaseResponse> appRate(@Body() var body);

  /// `POST /patient/ratings {doctor_id, rate, comment?}` — rates a doctor
  /// (requires a `completed` reservation, one per doctor).
  @POST(NetworkConstant.kRatings)
  Future<BaseResponse<Ratings>> doctorRate(@Body() var body);
}
