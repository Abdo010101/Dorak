import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'rate_client.g.dart';

@RestApi()
abstract class RateClient {
  factory RateClient(Dio dio, {String baseUrl}) = _RateClient;

  @POST(NetworkConstant.kAppRatings)
  Future<BaseResponse> addRate(@Body() var body);
  @POST(NetworkConstant.kRatings)
  Future<BaseResponse<Ratings>> doctorRate(@Body() var body);
}
