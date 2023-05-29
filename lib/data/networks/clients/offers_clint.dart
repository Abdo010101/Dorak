import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';

part 'offers_clint.g.dart';

@RestApi()
abstract class OffersClint {
  factory OffersClint(Dio dio, {String baseUrl}) = _OffersClint;

  @GET(NetworkConstant.kAllOffers)
  Future<BaseResponse<AllOffersResponse>> getAllOffers(
      @Queries() Map<String, dynamic> body);
}
