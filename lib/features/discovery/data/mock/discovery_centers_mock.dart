import 'dart:ui';

/// Lat/Lng tuple. Simple inline value to avoid pulling a maps dep.
class LatLng {
  const LatLng(this.lat, this.lng);
  final double lat;
  final double lng;
}

class LatLngBounds {
  const LatLngBounds({required this.sw, required this.ne});
  final LatLng sw;
  final LatLng ne;

  Offset project(LatLng p, Size size) {
    final x =
        ((p.lng - sw.lng) / (ne.lng - sw.lng)).clamp(0.0, 1.0) * size.width;
    final y =
        ((ne.lat - p.lat) / (ne.lat - sw.lat)).clamp(0.0, 1.0) * size.height;
    return Offset(x, y);
  }
}

class DiscoveryCenterPin {
  const DiscoveryCenterPin({
    required this.id,
    required this.name,
    required this.shortLabel,
    required this.rating,
    required this.specialties,
    required this.location,
    required this.imageAsset,
    required this.latLng,
    this.availableToday = true,
  });

  final int id;
  final String name;
  final String shortLabel;
  final String rating;
  final String specialties;
  final String location;
  final String imageAsset;
  final LatLng latLng;
  final bool availableToday;
}

/// Figma `203:1881` sample pins. Replace once `getMedicalCenters` is live.
class DiscoveryCentersMock {
  const DiscoveryCentersMock._();

  /// Approximate Dammam bbox used for the mock projection.
  static const LatLngBounds bounds = LatLngBounds(
    sw: LatLng(26.3700, 50.0700),
    ne: LatLng(26.4600, 50.1700),
  );

  static const LatLng userLocation = LatLng(26.4180, 50.1130);

  static const List<DiscoveryCenterPin> pins = [
    DiscoveryCenterPin(
      id: 1,
      name: 'مركز العناية الطبي',
      shortLabel: 'العناية',
      rating: '٤٫٨',
      specialties: 'الأسنان ، الجلدية',
      location: 'الدمام · حي الشاطئ',
      imageAsset: 'assets/images/home/center1.png',
      latLng: LatLng(26.4420, 50.1280),
    ),
    DiscoveryCenterPin(
      id: 2,
      name: 'مجمع النور الطبي',
      shortLabel: 'النور',
      rating: '٤٫٦',
      specialties: 'الأسنان ، الأطفال',
      location: 'الدمام · حي الفيصلية',
      imageAsset: 'assets/images/home/center2.png',
      latLng: LatLng(26.4300, 50.0860),
    ),
    DiscoveryCenterPin(
      id: 3,
      name: 'مركز الحياة الطبي',
      shortLabel: 'الحياة',
      rating: '٤٫٥',
      specialties: 'العيون ، الجلدية',
      location: 'الدمام · حي المزروعية',
      imageAsset: 'assets/images/home/center2.png',
      latLng: LatLng(26.4070, 50.1340),
    ),
    DiscoveryCenterPin(
      id: 4,
      name: 'عيادة الدكتور أحمد',
      shortLabel: 'عيادة دكتور احمد',
      rating: '٤٫٨',
      specialties: 'الأسنان',
      location: 'الدمام · حي الفيصلية',
      imageAsset: 'assets/images/home/center1.png',
      latLng: LatLng(26.3860, 50.0790),
    ),
  ];
}
