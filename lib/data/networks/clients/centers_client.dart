import 'package:dio/dio.dart';

import '../../models/response/centers_response.dart';
import '../network_constant.dart';

/// Dio-direct client for medical-center + clinic endpoints (scope §10.1).
///
/// - `GET /patient/medical-centers` (paginated list, full filter set)
/// - `GET /patient/medical-centers/{id}` (details)
/// - `GET /patient/medical-centers/{id}/doctors` (?specialization_id)
/// - `GET /patient/medical-centers/{id}/specializations`
/// - `GET /patient/clinics` (paginated list; `search` also matches doctor)
/// - `GET /patient/clinics/{doctor_id}` (details)
class CentersClient {
  CentersClient(this._dio);

  final Dio _dio;

  Future<List<MedicalCenterCard>> listMedicalCenters({
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
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kMedicalCenters,
      queryParameters: _nonNull({
        'lat': lat,
        'lng': lng,
        'city_id': cityId,
        'area_id': areaId,
        'specialization_id': specializationId,
        'search': search,
        'available_today': availableToday,
        'radius_km': radiusKm,
        'per_page': perPage,
        'page': page,
      }),
    );
    return _parseList(res.data?['data']);
  }

  Future<List<MedicalCenterCard>> listClinics({
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
    final res = await _dio.get<Map<String, dynamic>>(
      NetworkConstant.kClinics,
      queryParameters: _nonNull({
        'lat': lat,
        'lng': lng,
        'city_id': cityId,
        'area_id': areaId,
        'specialization_id': specializationId,
        'search': search,
        'available_today': availableToday,
        'radius_km': radiusKm,
        'per_page': perPage,
        'page': page,
      }),
    );
    return _parseList(res.data?['data']);
  }

  Future<MedicalCenterDetails> medicalCenter(int id,
      {double? lat, double? lng}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '${NetworkConstant.kMedicalCenters}/$id',
      queryParameters: _nonNull({'lat': lat, 'lng': lng}),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return MedicalCenterDetails.fromJson(data ?? const {});
  }

  Future<MedicalCenterDetails> clinic(int doctorId,
      {double? lat, double? lng}) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '${NetworkConstant.kClinics}/$doctorId',
      queryParameters: _nonNull({'lat': lat, 'lng': lng}),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return MedicalCenterDetails.fromJson(data ?? const {});
  }

  Future<DoctorsAtCenterResponse> doctorsAtCenter(
    int centerId, {
    int? specializationId,
  }) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '${NetworkConstant.kMedicalCenters}/$centerId/${NetworkConstant.kDoctorsAtCenter}',
      queryParameters: _nonNull({'specialization_id': specializationId}),
    );
    final data = res.data?['data'] as Map<String, dynamic>?;
    return DoctorsAtCenterResponse.fromJson(data ?? const {});
  }

  Future<List<CenterSpecialization>> medicalCenterSpecializations(
      int centerId) async {
    final res = await _dio.get<Map<String, dynamic>>(
      '${NetworkConstant.kMedicalCenters}/$centerId/${NetworkConstant.kSpecializations}',
    );
    final data = res.data?['data'];
    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(CenterSpecialization.fromJson)
          .toList();
    }
    return const <CenterSpecialization>[];
  }

  List<MedicalCenterCard> _parseList(Object? raw) {
    final rows = <MedicalCenterCard>[];
    if (raw is List) {
      for (final e in raw) {
        if (e is Map<String, dynamic>) rows.add(MedicalCenterCard.fromJson(e));
      }
    } else if (raw is Map<String, dynamic> && raw['data'] is List) {
      // Paginated envelope: `{data: [...], links, meta}`
      for (final e in raw['data'] as List) {
        if (e is Map<String, dynamic>) rows.add(MedicalCenterCard.fromJson(e));
      }
    }
    return rows;
  }

  Map<String, dynamic> _nonNull(Map<String, dynamic> src) {
    return <String, dynamic>{
      for (final e in src.entries)
        if (e.value != null) e.key: e.value,
    };
  }
}
