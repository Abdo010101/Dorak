import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';

import 'package:retrofit/retrofit.dart';

import '../../models/request/request.dart';
import '../../models/response/response.dart';

part 'auth_client.g.dart';

@RestApi()
abstract class AuthenticationClient {
  factory AuthenticationClient(Dio dio, {String baseUrl}) =
      _AuthenticationClient;

  @POST(NetworkConstant.kLoginRequest)
  Future<BaseResponse<UserResponse>> login(
    @Body() LoginRequest model,
  );

  @POST(NetworkConstant.kRegisterRequest)
  Future<BaseResponse<UserResponse>> register(
    @Body() var model,
  );
}
