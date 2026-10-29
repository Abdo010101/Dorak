import 'package:geocoding/geocoding.dart' as gc;
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Permission + service enablement outcome from `ensurePermission()`.
enum LocationStatus { granted, denied, deniedForever, serviceDisabled }

/// Device-location boundary. Implementation wraps `geolocator`, `geocoding`
/// and `permission_handler` statics so cubits can be unit-tested with a fake.
abstract class LocationService {
  Future<LocationStatus> ensurePermission();
  Future<({double lat, double lng})> currentPosition();
  Future<({String city, String area})?> reverseGeocode(
    double lat,
    double lng, {
    required String localeCode,
  });
  Future<void> openSystemSettings();
}

class GeolocatorLocationService implements LocationService {
  const GeolocatorLocationService();

  @override
  Future<LocationStatus> ensurePermission() async {
    final serviceOn = await Geolocator.isLocationServiceEnabled();
    if (!serviceOn) return LocationStatus.serviceDisabled;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    switch (permission) {
      case LocationPermission.always:
      case LocationPermission.whileInUse:
        return LocationStatus.granted;
      case LocationPermission.deniedForever:
        return LocationStatus.deniedForever;
      case LocationPermission.denied:
      case LocationPermission.unableToDetermine:
        return LocationStatus.denied;
    }
  }

  @override
  Future<({double lat, double lng})> currentPosition() async {
    final pos = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.medium,
        timeLimit: Duration(seconds: 10),
      ),
    );
    return (lat: pos.latitude, lng: pos.longitude);
  }

  @override
  Future<({String city, String area})?> reverseGeocode(
    double lat,
    double lng, {
    required String localeCode,
  }) async {
    try {
      await gc.setLocaleIdentifier(localeCode);
      final placemarks = await gc.placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty) return null;
      final p = placemarks.first;
      final city = p.locality ?? p.administrativeArea ?? '';
      final area =
          p.subLocality ?? p.thoroughfare ?? p.subAdministrativeArea ?? '';
      if (city.isEmpty && area.isEmpty) return null;
      return (city: city, area: area);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> openSystemSettings() async {
    await ph.openAppSettings();
  }
}
