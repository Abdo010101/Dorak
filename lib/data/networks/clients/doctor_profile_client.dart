import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';

part 'doctor_profile_client.g.dart';

@RestApi()
abstract class DoctorProfileClient {
  factory DoctorProfileClient(Dio dio, {String baseUrl}) = _DoctorProfileClient;
  @GET("${NetworkConstant.kDoctorProfileRequest}/{id}")
  Future<BaseResponse<DoctorProfileResponse>> getDoctorProfile(
      {@Path('id') int? id});

  @GET(
      "${NetworkConstant.kDoctorProfileRequest}/{id}/${NetworkConstant.kAllOffers}")
  Future<BaseResponseList<OfferResponse>> getDoctorOffers(
      {@Path('id') int? id});
}
