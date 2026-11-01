import 'package:dio/dio.dart';

import '../../models/response/centers_response.dart';
import '../../models/response/discovery_response.dart';
import '../../models/response/home_response.dart' show HomeLocation;
import '../network_constant.dart';

/// Dio-direct client for discovery endpoints (scope §10.1):
/// - `GET /patient/search`
/// - `GET /patient/explore/map`
/// - `GET /patient/location` (reverse geocode)
/// - `GET /patient/locations` (search by name)
/// - `GET /patient/nearest-medical-centers`
class DiscoveryClient {
  DiscoveryClient(this._dio);

  final Dio _dio;

  Future<SearchResponse> search({
    required String search,
    double? lat,
    double? lng,
    int? specializationId,
    int? perPage,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kSearch,
      queryParameters: _nonNull({
        'search': search,
        'lat': lat,
        'lng': lng,
        'specialization_id': specializationId,
        'per_page': perPage,
      }),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return SearchResponse.fromJson(data ?? const {});
  }

  Future<ExploreMapResponse> exploreMap({
    double? lat,
    double? lng,
    double? radiusKm,
    int? cityId,
    int? specializationId,
    String? search,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kExploreMap,
      queryParameters: _nonNull({
        'lat': lat,
        'lng': lng,
        'radius_km': radiusKm,
        'city_id': cityId,
        'specialization_id': specializationId,
        'search': search,
      }),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return ExploreMapResponse.fromJson(data ?? const {});
  }

  /// Reverse-geocode device lat/lng → area/city labels.
  /// Returns null if no area matched.
  Future<HomeLocation?> location({
    required double lat,
    required double lng,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kLocation,
      queryParameters: {'lat': lat, 'lng': lng},
    );
    final data = res.data?['data'];
    if (data is Map<String, dynamic>) return HomeLocation.fromJson(data);
    return null;
  }

  Future<List<LocationArea>> locations(String search) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kLocations,
      queryParameters: {'search': search},
    );
    final data = res.data?['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(LocationArea.fromJson)
          .toList();
    }
    return const <LocationArea>[];
  }

  Future<List<MedicalCenterCard>> nearestMedicalCenters({
    required double lat,
    required double lng,
    int? perPage,
    double? radiusKm,
    double? maxRadiusKm,
    int? page,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kNearestMedicalCenters,
      queryParameters: _nonNull({
        'lat': lat,
        'lng': lng,
        'per_page': perPage,
        'radius_km': radiusKm,
        'max_radius_km': maxRadiusKm,
        'page': page,
      }),
    );
    final raw = res.data?['data'];
    final rows = <MedicalCenterCard>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) rows.add(MedicalCenterCard.fromJson(e));
      }
    } else if (raw is Map<String, dynamic> && raw['data'] is List) {
      for (final e in raw['data'] as List) {
        if (e is Map<String, dynamic>) rows.add(MedicalCenterCard.fromJson(e));
      }
    }
    return rows;
  }

  Map<String, dynamic> _nonNull(Map<String, dynamic> src) => <String, dynamic>{
        for (final e in src.entries)
          if (e.value != null) e.key: e.value,
      };
}
