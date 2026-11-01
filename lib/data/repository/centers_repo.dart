import 'package:dio/dio.dart';

import '../models/response/centers_response.dart';
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class CentersRepository extends BaseRepository {
  CentersRepository({required this.client});

  final CentersClient client;

  Future<BaseModel<List<MedicalCenterCard>>> listMedicalCenters({
    double? lat,
    double? lng,
    int? cityId,
    int? areaId,
    int? specializationId,
    String? search,
    bool? availableToday,
    double? radiusKm,
    int? perPage,
    int? page,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.listMedicalCenters(
        lat: lat,
        lng: lng,
        cityId: cityId,
        areaId: areaId,
        specializationId: specializationId,
        search: search,
        availableToday: availableToday,
        radiusKm: radiusKm,
        perPage: perPage,
        page: page,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<List<MedicalCenterCard>>> listClinics({
    double? lat,
    double? lng,
    int? cityId,
    int? areaId,
    int? specializationId,
    String? search,
    bool? availableToday,
    double? radiusKm,
    int? perPage,
    int? page,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.listClinics(
        lat: lat,
        lng: lng,
        cityId: cityId,
        areaId: areaId,
        specializationId: specializationId,
        search: search,
        availableToday: availableToday,
        radiusKm: radiusKm,
        perPage: perPage,
        page: page,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<MedicalCenterDetails>> medicalCenter(int id,
      {double? lat, double? lng}) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.medicalCenter(id, lat: lat, lng: lng);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<MedicalCenterDetails>> clinic(int doctorId,
      {double? lat, double? lng}) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.clinic(doctorId, lat: lat, lng: lng);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<DoctorsAtCenterResponse>> doctorsAtCenter(
    int centerId, {
    int? specializationId,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.doctorsAtCenter(centerId,
          specializationId: specializationId);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }
}
