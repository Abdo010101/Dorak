import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';

part 'home_client.g.dart';

@RestApi()
abstract class HomeClient {
  factory HomeClient(Dio dio, {String baseUrl}) = _HomeClient;
  @GET(NetworkConstant.kHomeRequest)
  Future<BaseResponse<HomeResponse>> getHomeData();


  @GET(NetworkConstant.kBestDoctors)
  Future<BaseResponseList<Doctor>> getBestDoctors();
}
