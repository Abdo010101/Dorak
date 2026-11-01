import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'profile_client.g.dart';

@RestApi()
abstract class ProfileClient {
  factory ProfileClient(Dio dio, {String baseUrl}) = _ProfileClient;

  @POST(NetworkConstant.kUpdateProfile)
  Future<BaseResponse<Patient>> updateProfile(@Body() var body);

  @GET(NetworkConstant.kProfile)
  Future<BaseResponse<Patient>> getProfileData();
}
