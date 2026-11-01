import 'package:dio/dio.dart';

import '../models/response/centers_response.dart';
import '../models/response/discovery_response.dart';
import '../models/response/home_response.dart' show HomeLocation;
import '../networks/base_model.dart';
import '../networks/clients/clients.dart';
import 'repository.dart';

class DiscoveryRepository extends BaseRepository {
  DiscoveryRepository({required this.client});

  final DiscoveryClient client;

  Future<BaseModel<SearchResponse>> search({
    required String search,
    double? lat,
    double? lng,
    int? specializationId,
    int? perPage,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.search(
        search: search,
        lat: lat,
        lng: lng,
        specializationId: specializationId,
        perPage: perPage,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<ExploreMapResponse>> exploreMap({
    double? lat,
    double? lng,
    double? radiusKm,
    int? cityId,
    int? specializationId,
    String? search,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.exploreMap(
        lat: lat,
        lng: lng,
        radiusKm: radiusKm,
        cityId: cityId,
        specializationId: specializationId,
        search: search,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<HomeLocation?>> location({
    required double lat,
    required double lng,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.location(lat: lat, lng: lng);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<List<LocationArea>>> locations(String search) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.locations(search);
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }

  Future<BaseModel<List<MedicalCenterCard>>> nearestMedicalCenters({
    required double lat,
    required double lng,
    int? perPage,
    double? radiusKm,
    double? maxRadiusKm,
    int? page,
  }) async {
    if (!await checkForConnectivity()) return BaseModel.noNetworkConnection();
    try {
      final data = await client.nearestMedicalCenters(
        lat: lat,
        lng: lng,
        perPage: perPage,
        radiusKm: radiusKm,
        maxRadiusKm: maxRadiusKm,
        page: page,
      );
      return BaseModel(data: data);
    } on DioError catch (e) {
      return BaseModel(error: ErrorResponse(dioError: e));
    }
  }
}
