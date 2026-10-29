import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

/// Lifecycle of the device-location resolve kicked off by `HomePage`.
enum LocationResolveStatus {
  idle,
  loading,
  resolved,
  denied,
  deniedForever,
  serviceDisabled,
  error,
}

class GeneralState extends Equatable {
  const GeneralState({
    this.status = Status.initial,
    this.generalResponse,
    this.titles = const [],
    this.specializations = const [],
    this.subSpecializations = const [],
    this.originalSubSpecializations = const [],
    this.cities = const [],
    this.originalCities = const [],
    this.areas = const [],
    this.originalAreas = const [],
    this.terms,
    this.policy,
    this.searchResult,
    this.specId,
    this.specializationId,
    this.specializationName,
    this.cityId,
    this.areaId,
    this.lat,
    this.lng,
    this.isMainSpecialization = false,
    this.errorMessage,
    this.locationStatus = LocationResolveStatus.idle,
    this.resolvedCityName,
    this.resolvedAreaName,
  });

  final Status status;
  final GeneralResponse? generalResponse;
  final List<Titles> titles;
  final List<Titles> specializations;
  final List<Titles> subSpecializations;
  final List<Titles> originalSubSpecializations;
  final List<Titles> cities;
  final List<Titles> originalCities;
  final List<Titles> areas;
  final List<Titles> originalAreas;
  final TermsPolicyResponse? terms;
  final TermsPolicyResponse? policy;
  final SearchResultData? searchResult;
  final int? specId;
  final int? specializationId;
  final String? specializationName;
  final int? cityId;
  final int? areaId;
  final double? lat;
  final double? lng;
  final bool isMainSpecialization;
  final String? errorMessage;
  final LocationResolveStatus locationStatus;
  final String? resolvedCityName;
  final String? resolvedAreaName;

  GeneralState copyWith({
    Status? status,
    GeneralResponse? generalResponse,
    List<Titles>? titles,
    List<Titles>? specializations,
    List<Titles>? subSpecializations,
    List<Titles>? originalSubSpecializations,
    List<Titles>? cities,
    List<Titles>? originalCities,
    List<Titles>? areas,
    List<Titles>? originalAreas,
    TermsPolicyResponse? terms,
    TermsPolicyResponse? policy,
    SearchResultData? searchResult,
    int? specId,
    int? specializationId,
    String? specializationName,
    int? cityId,
    int? areaId,
    double? lat,
    double? lng,
    bool? isMainSpecialization,
    String? errorMessage,
    bool clearError = false,
    LocationResolveStatus? locationStatus,
    String? resolvedCityName,
    String? resolvedAreaName,
  }) =>
      GeneralState(
        status: status ?? this.status,
        generalResponse: generalResponse ?? this.generalResponse,
        titles: titles ?? this.titles,
        specializations: specializations ?? this.specializations,
        subSpecializations: subSpecializations ?? this.subSpecializations,
        originalSubSpecializations:
            originalSubSpecializations ?? this.originalSubSpecializations,
        cities: cities ?? this.cities,
        originalCities: originalCities ?? this.originalCities,
        areas: areas ?? this.areas,
        originalAreas: originalAreas ?? this.originalAreas,
        terms: terms ?? this.terms,
        policy: policy ?? this.policy,
        searchResult: searchResult ?? this.searchResult,
        specId: specId ?? this.specId,
        specializationId: specializationId ?? this.specializationId,
        specializationName: specializationName ?? this.specializationName,
        cityId: cityId ?? this.cityId,
        areaId: areaId ?? this.areaId,
        lat: lat ?? this.lat,
        lng: lng ?? this.lng,
        isMainSpecialization: isMainSpecialization ?? this.isMainSpecialization,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
        locationStatus: locationStatus ?? this.locationStatus,
        resolvedCityName: resolvedCityName ?? this.resolvedCityName,
        resolvedAreaName: resolvedAreaName ?? this.resolvedAreaName,
      );

  @override
  List<Object?> get props => [
        status,
        generalResponse,
        titles,
        specializations,
        subSpecializations,
        originalSubSpecializations,
        cities,
        originalCities,
        areas,
        originalAreas,
        terms,
        policy,
        searchResult,
        specId,
        specializationId,
        specializationName,
        cityId,
        areaId,
        lat,
        lng,
        isMainSpecialization,
        errorMessage,
        locationStatus,
        resolvedCityName,
        resolvedAreaName,
      ];
}
