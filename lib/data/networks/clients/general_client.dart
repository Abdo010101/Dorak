import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../models/response/response.dart';
import '../network_constant.dart';

part 'general_client.g.dart';

@RestApi()
abstract class GeneralClient {
  factory GeneralClient(Dio dio, {String baseUrl}) = _GeneralClient;
  @GET(NetworkConstant.kGeneralRequest)
  Future<BaseResponse<GeneralResponse>> getGeneralData();

  @GET(
      '${NetworkConstant.kCitiesRequest}/{id}/${NetworkConstant.kAreasRequest}')
  Future<BaseResponseList<Titles>> getCitiesByArea(@Path('id') int? id);

  @GET(NetworkConstant.kSearchByName)
  Future<BaseResponse<SearchResultData>> getSearchByName(
      @Queries() Map<String, dynamic> prams);

  @GET(
      '${NetworkConstant.kMainSpecialization}/{id}/${NetworkConstant.kSubSpecialization}')
  Future<BaseResponseList<Titles>> getSubSpecilization(@Path('id') int? id);

  /* @GET(
      "${NetworkConstant.kSpecializationRequest}/{special_id}/${NetworkConstant.kSubSpecializationRequest}")
  Future<BaseResponse<SpecializationResponse>> getSubSpecialization(
      @Path('special_id') specialId);



  @GET(NetworkConstant.kMedicalCenterRequest)
  Future<BaseResponseList<MedicalCenterResponse>> getMedicalCenters();*/

  @GET(NetworkConstant.kTerms)
  Future<BaseResponse<TermsPolicyResponse>> getTermsAndService();

  @GET(NetworkConstant.kPolicy)
  Future<BaseResponse<TermsPolicyResponse>> getPrivacyAndPolicy();
}
