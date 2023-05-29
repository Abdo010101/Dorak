import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'general_client.g.dart';

@RestApi()
abstract class GeneralClient {
  factory GeneralClient(Dio dio, {String baseUrl}) = _GeneralClient;
  @GET(NetworkConstant.kGeneralRequest)
  Future<BaseResponse<GeneralResponse>> getGeneralData();

  /* @GET(
      "${NetworkConstant.kSpecializationRequest}/{special_id}/${NetworkConstant.kSubSpecializationRequest}")
  Future<BaseResponse<SpecializationResponse>> getSubSpecialization(
      @Path('special_id') specialId);

  @GET(
      "${NetworkConstant.kCitiesRequest}/{city_id}/${NetworkConstant.kAreasRequest}")
  Future<BaseResponseList<GeneralData>> getAreas(@Path('city_id') cityId);

  @GET(NetworkConstant.kMedicalCenterRequest)
  Future<BaseResponseList<MedicalCenterResponse>> getMedicalCenters();

  @GET(NetworkConstant.kTerms)
  Future<BaseResponse<TermsPolicyResponse>> getTermsAndService();

  @GET(NetworkConstant.kPolicy)
  Future<BaseResponse<TermsPolicyResponse>> getPrivacyAndPolicy();*/
}
