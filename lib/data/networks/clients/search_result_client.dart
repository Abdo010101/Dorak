import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';

part 'search_result_client.g.dart';

@RestApi()
abstract class DoctorsSearchResultClient {
  factory DoctorsSearchResultClient(Dio dio, {String baseUrl}) =
      _DoctorsSearchResultClient;

  @GET('${NetworkConstant.kDoctorsRequest}')
  Future<BaseResponse<SearchResultResponse>> getDoctorsResults(
      @Queries() Map<String, dynamic> prams,);
}
