import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/centers_response.dart';
import '../../../data/models/response/discovery_response.dart';
import '../../../data/models/response/home_response.dart' show HomeLocation;
import '../../../data/repository/discovery_repo.dart';

/// Feeds the three Discovery screens (explore list, explore map,
/// location picker) from the real `/patient/*` endpoints (scope §10.1).
///
/// Each page uses the slice it needs:
/// - explore list: [loadCentersAndClinics]
/// - explore map: [loadMap]
/// - location picker: [searchLocations] + [resolveLocation]
class DiscoveryCubit extends Cubit<DiscoveryState> {
  DiscoveryCubit({required DiscoveryRepository repo})
      : _repo = repo,
        super(const DiscoveryState());

  final DiscoveryRepository _repo;

  Future<void> loadCentersAndClinics({
    double? lat,
    double? lng,
    int? cityId,
    int? areaId,
    int? specializationId,
    String? search,
  }) async {
    emit(state.copyWith(listStatus: Status.loading, clearError: true));
    try {
      // Not strictly discovery, but convenient to co-locate.
      final map = await _repo.exploreMap(
        lat: lat,
        lng: lng,
        cityId: cityId,
        specializationId: specializationId,
        search: search,
      );
      if (map.data != null) {
        emit(state.copyWith(
          listStatus: Status.success,
          medicalCenters: map.data!.medicalCenters ?? const [],
          clinics: map.data!.clinics ?? const [],
        ));
      } else {
        emit(state.copyWith(
          listStatus: Status.failure,
          errorMessage: map.error?.message,
        ));
      }
    } on DioException catch (e) {
      emit(state.copyWith(listStatus: Status.failure, errorMessage: e.message));
    }
  }

  Future<void> loadMap({
    double? lat,
    double? lng,
    double? radiusKm,
    int? cityId,
    int? specializationId,
    String? search,
  }) async {
    emit(state.copyWith(mapStatus: Status.loading, clearError: true));
    final result = await _repo.exploreMap(
      lat: lat,
      lng: lng,
      radiusKm: radiusKm,
      cityId: cityId,
      specializationId: specializationId,
      search: search,
    );
    if (result.data != null) {
      emit(state.copyWith(
        mapStatus: Status.success,
        medicalCenters: result.data!.medicalCenters ?? const [],
        clinics: result.data!.clinics ?? const [],
      ));
    } else {
      emit(state.copyWith(
        mapStatus: Status.failure,
        errorMessage: result.error?.message,
      ));
    }
  }

  Future<void> searchLocations(String q) async {
    if (q.trim().isEmpty) {
      emit(state.copyWith(areas: const []));
      return;
    }
    emit(state.copyWith(areaStatus: Status.loading, clearError: true));
    final result = await _repo.locations(q);
    if (result.data != null) {
      emit(state.copyWith(
        areaStatus: Status.success,
        areas: result.data!,
      ));
    } else {
      emit(state.copyWith(
        areaStatus: Status.failure,
        errorMessage: result.error?.message,
      ));
    }
  }

  Future<void> resolveLocation({
    required double lat,
    required double lng,
  }) async {
    emit(state.copyWith(resolveStatus: Status.loading, clearError: true));
    final result = await _repo.location(lat: lat, lng: lng);
    if (result.error != null) {
      emit(state.copyWith(
        resolveStatus: Status.failure,
        errorMessage: result.error?.message,
      ));
      return;
    }
    emit(state.copyWith(
      resolveStatus: Status.success,
      resolved: result.data,
    ));
  }
}

class DiscoveryState extends Equatable {
  const DiscoveryState({
    this.listStatus = Status.initial,
    this.mapStatus = Status.initial,
    this.areaStatus = Status.initial,
    this.resolveStatus = Status.initial,
    this.medicalCenters = const [],
    this.clinics = const [],
    this.areas = const [],
    this.resolved,
    this.errorMessage,
  });

  final Status listStatus;
  final Status mapStatus;
  final Status areaStatus;
  final Status resolveStatus;
  final List<MedicalCenterCard> medicalCenters;
  final List<MedicalCenterCard> clinics;
  final List<LocationArea> areas;
  final HomeLocation? resolved;
  final String? errorMessage;

  DiscoveryState copyWith({
    Status? listStatus,
    Status? mapStatus,
    Status? areaStatus,
    Status? resolveStatus,
    List<MedicalCenterCard>? medicalCenters,
    List<MedicalCenterCard>? clinics,
    List<LocationArea>? areas,
    HomeLocation? resolved,
    String? errorMessage,
    bool clearError = false,
  }) =>
      DiscoveryState(
        listStatus: listStatus ?? this.listStatus,
        mapStatus: mapStatus ?? this.mapStatus,
        areaStatus: areaStatus ?? this.areaStatus,
        resolveStatus: resolveStatus ?? this.resolveStatus,
        medicalCenters: medicalCenters ?? this.medicalCenters,
        clinics: clinics ?? this.clinics,
        areas: areas ?? this.areas,
        resolved: resolved ?? this.resolved,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [
        listStatus,
        mapStatus,
        areaStatus,
        resolveStatus,
        medicalCenters,
        clinics,
        areas,
        resolved,
        errorMessage,
      ];
}
