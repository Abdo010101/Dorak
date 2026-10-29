import 'package:bloc_test/bloc_test.dart';
import 'package:dorakpattient/core/services/location_service.dart';
import 'package:dorakpattient/data/repository/repository.dart';
import 'package:dorakpattient/features/home/logic/general_cubit.dart';
import 'package:dorakpattient/features/home/logic/general_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGeneralRepo extends Mock implements GeneralRepository {}

class _FakeLocationService implements LocationService {
  _FakeLocationService({
    required this.gate,
    this.position = (lat: 24.712, lng: 46.675),
    this.place,
    this.throwOnPosition = false,
  });

  final LocationStatus gate;
  final ({double lat, double lng}) position;
  final ({String city, String area})? place;
  final bool throwOnPosition;

  @override
  Future<LocationStatus> ensurePermission() async => gate;

  @override
  Future<({double lat, double lng})> currentPosition() async {
    if (throwOnPosition) throw Exception('boom');
    return position;
  }

  @override
  Future<({String city, String area})?> reverseGeocode(
    double lat,
    double lng, {
    required String localeCode,
  }) async =>
      place;

  @override
  Future<void> openSystemSettings() async {}
}

void main() {
  late _MockGeneralRepo repo;

  setUp(() {
    repo = _MockGeneralRepo();
  });

  group('GeneralCubit.resolveDeviceLocation', () {
    blocTest<GeneralCubit, GeneralState>(
      'granted + geocode → loading → resolved with city/area + lat/lng',
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.resolveDeviceLocation(
        svc: _FakeLocationService(
          gate: LocationStatus.granted,
          place: (city: 'الرياض', area: 'العليا'),
        ),
        localeCode: 'ar',
      ),
      expect: () => [
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'loading',
          LocationResolveStatus.loading,
        ),
        isA<GeneralState>()
            .having((s) => s.lat, 'lat', 24.712)
            .having((s) => s.lng, 'lng', 46.675),
        isA<GeneralState>()
            .having(
              (s) => s.locationStatus,
              'resolved',
              LocationResolveStatus.resolved,
            )
            .having((s) => s.resolvedCityName, 'city', 'الرياض')
            .having((s) => s.resolvedAreaName, 'area', 'العليا'),
      ],
    );

    blocTest<GeneralCubit, GeneralState>(
      'denied → emits denied, no lat/lng',
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.resolveDeviceLocation(
        svc: _FakeLocationService(gate: LocationStatus.denied),
        localeCode: 'ar',
      ),
      expect: () => [
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'loading',
          LocationResolveStatus.loading,
        ),
        isA<GeneralState>()
            .having(
              (s) => s.locationStatus,
              'denied',
              LocationResolveStatus.denied,
            )
            .having((s) => s.lat, 'lat', isNull)
            .having((s) => s.lng, 'lng', isNull),
      ],
    );

    blocTest<GeneralCubit, GeneralState>(
      'serviceDisabled → emits serviceDisabled',
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.resolveDeviceLocation(
        svc: _FakeLocationService(gate: LocationStatus.serviceDisabled),
        localeCode: 'ar',
      ),
      expect: () => [
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'loading',
          LocationResolveStatus.loading,
        ),
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'serviceDisabled',
          LocationResolveStatus.serviceDisabled,
        ),
      ],
    );

    blocTest<GeneralCubit, GeneralState>(
      'position throws → emits error',
      build: () => GeneralCubit(generalRepository: repo),
      act: (c) => c.resolveDeviceLocation(
        svc: _FakeLocationService(
          gate: LocationStatus.granted,
          throwOnPosition: true,
        ),
        localeCode: 'ar',
      ),
      expect: () => [
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'loading',
          LocationResolveStatus.loading,
        ),
        isA<GeneralState>().having(
          (s) => s.locationStatus,
          'error',
          LocationResolveStatus.error,
        ),
      ],
    );
  });
}
