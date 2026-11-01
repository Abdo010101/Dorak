import 'centers_response.dart';
import 'general_response.dart';
import 'home_response.dart' show HomeLocation;

/// `GET /patient/search?search&lat&lng&specialization_id&per_page`
/// returns `{specializations, medical_centers{total,data}, clinics{total,data}}`
/// (scope §10.1.4).
class SearchResponse {
  List<Titles>? specializations;
  SearchSection? medicalCenters;
  SearchSection? clinics;

  SearchResponse({this.specializations, this.medicalCenters, this.clinics});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    if (json['specializations'] is List) {
      specializations = (json['specializations'] as List)
          .whereType<Map<String, dynamic>>()
          .map(Titles.fromJson)
          .toList();
    }
    if (json['medical_centers'] is Map<String, dynamic>) {
      medicalCenters =
          SearchSection.fromJson(json['medical_centers'] as Map<String, dynamic>);
    }
    if (json['clinics'] is Map<String, dynamic>) {
      clinics = SearchSection.fromJson(json['clinics'] as Map<String, dynamic>);
    }
  }
}

class SearchSection {
  int? total;
  List<MedicalCenterCard>? data;

  SearchSection({this.total, this.data});

  SearchSection.fromJson(Map<String, dynamic> json) {
    total = json['total'] as int?;
    if (json['data'] is List) {
      data = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(MedicalCenterCard.fromJson)
          .toList();
    }
  }
}

/// `GET /patient/explore/map` returns both buckets, unpaginated, capped at
/// 100 each (scope §10.1.5).
class ExploreMapResponse {
  List<MedicalCenterCard>? medicalCenters;
  List<MedicalCenterCard>? clinics;

  ExploreMapResponse({this.medicalCenters, this.clinics});

  ExploreMapResponse.fromJson(Map<String, dynamic> json) {
    if (json['medical_centers'] is List) {
      medicalCenters = (json['medical_centers'] as List)
          .whereType<Map<String, dynamic>>()
          .map(MedicalCenterCard.fromJson)
          .toList();
    }
    if (json['clinics'] is List) {
      clinics = (json['clinics'] as List)
          .whereType<Map<String, dynamic>>()
          .map(MedicalCenterCard.fromJson)
          .toList();
    }
  }
}

/// `GET /patient/locations?search=` row — area with its parent city and
/// centre lat/lng (scope §10.1.7).
class LocationArea {
  int? areaId;
  String? area;
  int? cityId;
  String? city;
  String? label;
  double? lat;
  double? lng;

  LocationArea({
    this.areaId,
    this.area,
    this.cityId,
    this.city,
    this.label,
    this.lat,
    this.lng,
  });

  LocationArea.fromJson(Map<String, dynamic> json) {
    areaId = json['area_id'] as int?;
    area = json['area'] as String?;
    cityId = json['city_id'] as int?;
    city = json['city'] as String?;
    label = json['label'] as String?;
    final lv = json['lat'];
    final gv = json['lng'];
    lat = lv is num
        ? lv.toDouble()
        : (lv is String ? double.tryParse(lv) : null);
    lng = gv is num
        ? gv.toDouble()
        : (gv is String ? double.tryParse(gv) : null);
  }
}

typedef ResolvedLocation = HomeLocation;
