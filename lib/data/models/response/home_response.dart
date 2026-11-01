import 'response.dart';

/// Mirrors `GET /patient/home`.
///
/// Backend returns:
///   location, unread_notifications_count, specializations, latest_offers,
///   nearest_medical_centers (4), nearest_clinics (4), best_doctors (15,
///   sponsored first), patient_reservations (up to 5).
class HomeResponse {
  HomeLocation? location;
  int? unreadNotificationsCount;
  List<Titles>? specializations;
  List<HomePlaceCard>? nearestMedicalCenters;
  List<HomePlaceCard>? nearestClinics;
  List<Doctor>? bestDoctors;
  List<OfferResponse>? latestOffers;
  List<AppointmentResponse>? patientReservations;

  HomeResponse({
    this.location,
    this.unreadNotificationsCount,
    this.specializations,
    this.nearestMedicalCenters,
    this.nearestClinics,
    this.bestDoctors,
    this.latestOffers,
    this.patientReservations,
  });

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['location'] is Map<String, dynamic>) {
      location = HomeLocation.fromJson(json['location'] as Map<String, dynamic>);
    }
    unreadNotificationsCount = json['unread_notifications_count'] as int?;
    if (json['specializations'] != null) {
      specializations = <Titles>[];
      json['specializations'].forEach((v) {
        specializations!.add(Titles.fromJson(v));
      });
    }
    if (json['nearest_medical_centers'] != null) {
      nearestMedicalCenters = <HomePlaceCard>[];
      json['nearest_medical_centers'].forEach((v) {
        nearestMedicalCenters!.add(HomePlaceCard.fromJson(v));
      });
    }
    if (json['nearest_clinics'] != null) {
      nearestClinics = <HomePlaceCard>[];
      json['nearest_clinics'].forEach((v) {
        nearestClinics!.add(HomePlaceCard.fromJson(v));
      });
    }
    if (json['best_doctors'] != null) {
      bestDoctors = <Doctor>[];
      json['best_doctors'].forEach((v) {
        bestDoctors!.add(Doctor.fromJson(v));
      });
    }
    if (json['latest_offers'] != null) {
      latestOffers = <OfferResponse>[];
      json['latest_offers'].forEach((v) {
        latestOffers!.add(OfferResponse.fromJson(v));
      });
    }
    if (json['patient_reservations'] != null) {
      patientReservations = <AppointmentResponse>[];
      json['patient_reservations'].forEach((v) {
        patientReservations!.add(AppointmentResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (location != null) data['location'] = location!.toJson();
    if (unreadNotificationsCount != null) {
      data['unread_notifications_count'] = unreadNotificationsCount;
    }
    if (specializations != null) {
      data['specializations'] =
          specializations!.map((v) => v.toJson()).toList();
    }
    if (nearestMedicalCenters != null) {
      data['nearest_medical_centers'] =
          nearestMedicalCenters!.map((v) => v.toJson()).toList();
    }
    if (nearestClinics != null) {
      data['nearest_clinics'] =
          nearestClinics!.map((v) => v.toJson()).toList();
    }
    if (bestDoctors != null) {
      data['best_doctors'] = bestDoctors!.map((v) => v.toJson()).toList();
    }
    if (latestOffers != null) {
      data['latest_offers'] = latestOffers!.map((v) => v.toJson()).toList();
    }
    if (patientReservations != null) {
      data['patient_reservations'] =
          patientReservations!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// Resolved location returned under `/patient/home.location`.
///
/// Same shape as `GET /patient/location` (`Location` resource):
/// `{area_id, area, city_id, city, label, lat, lng}`.
class HomeLocation {
  int? areaId;
  String? area;
  int? cityId;
  String? city;
  String? label;
  double? lat;
  double? lng;

  HomeLocation({
    this.areaId,
    this.area,
    this.cityId,
    this.city,
    this.label,
    this.lat,
    this.lng,
  });

  HomeLocation.fromJson(Map<String, dynamic> json) {
    areaId = json['area_id'] as int?;
    area = json['area'] as String?;
    cityId = json['city_id'] as int?;
    city = json['city'] as String?;
    label = json['label'] as String?;
    lat = _toDouble(json['lat']);
    lng = _toDouble(json['lng']);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (areaId != null) 'area_id': areaId,
        if (area != null) 'area': area,
        if (cityId != null) 'city_id': cityId,
        if (city != null) 'city': city,
        if (label != null) 'label': label,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
      };
}

/// Card variant used by `/patient/home.nearest_medical_centers` and
/// `.nearest_clinics`. Mirrors `MedicalCenterCardResource` / the clinic
/// variant that adds `doctor` + `is_sponsored`.
class HomePlaceCard {
  String? type; // "medical_center" or "clinic"
  int? id;
  String? name;
  String? image;
  String? rating;
  int? ratingsCount;
  double? distanceKm;
  List<String>? specializations;
  String? city;
  String? area;
  String? address;
  bool? availableToday;
  String? phone;
  double? lat;
  double? lng;
  HomePlaceDoctor? doctor;
  bool? isSponsored;

  HomePlaceCard({
    this.type,
    this.id,
    this.name,
    this.image,
    this.rating,
    this.ratingsCount,
    this.distanceKm,
    this.specializations,
    this.city,
    this.area,
    this.address,
    this.availableToday,
    this.phone,
    this.lat,
    this.lng,
    this.doctor,
    this.isSponsored,
  });

  HomePlaceCard.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    rating = json['rating']?.toString();
    ratingsCount = json['ratings_count'] as int?;
    distanceKm = _toDouble(json['distance_km']);
    if (json['specializations'] is List) {
      specializations = (json['specializations'] as List)
          .map((v) => v.toString())
          .toList();
    }
    city = json['city'] as String?;
    area = json['area'] as String?;
    address = json['address'] as String?;
    availableToday = json['available_today'] as bool?;
    phone = json['phone'] as String?;
    lat = _toDouble(json['lat']);
    lng = _toDouble(json['lng']);
    if (json['doctor'] is Map<String, dynamic>) {
      doctor = HomePlaceDoctor.fromJson(json['doctor'] as Map<String, dynamic>);
    }
    isSponsored = json['is_sponsored'] as bool?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (type != null) 'type': type,
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (image != null) 'image': image,
        if (rating != null) 'rating': rating,
        if (ratingsCount != null) 'ratings_count': ratingsCount,
        if (distanceKm != null) 'distance_km': distanceKm,
        if (specializations != null) 'specializations': specializations,
        if (city != null) 'city': city,
        if (area != null) 'area': area,
        if (address != null) 'address': address,
        if (availableToday != null) 'available_today': availableToday,
        if (phone != null) 'phone': phone,
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (doctor != null) 'doctor': doctor!.toJson(),
        if (isSponsored != null) 'is_sponsored': isSponsored,
      };
}

/// Doctor summary attached to a clinic `HomePlaceCard`.
class HomePlaceDoctor {
  int? id;
  String? name;
  String? image;

  HomePlaceDoctor({this.id, this.name, this.image});

  HomePlaceDoctor.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (id != null) 'id': id,
        if (name != null) 'name': name,
        if (image != null) 'image': image,
      };
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

class BestDoctors {
  int? id;
  String? name;
  String? image;
  String? bio;
  String? examinationPrice;
  int? examinationDuration;
  String? address;
  String? rate;
  int? ratingsCount;

  BestDoctors({
    this.id,
    this.name,
    this.image,
    this.bio,
    this.examinationPrice,
    this.examinationDuration,
    this.address,
    this.rate,
    this.ratingsCount,
  });

  BestDoctors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    bio = json['bio'];
    examinationPrice = json['examination_price'];
    examinationDuration = json['examination_duration'];
    address = json['address'];
    rate = json['rate'];
    ratingsCount = json['ratings_count'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['bio'] = bio;
    data['examination_price'] = examinationPrice;
    data['examination_duration'] = examinationDuration;
    data['address'] = address;
    data['rate'] = rate;
    data['ratings_count'] = ratingsCount;
    return data;
  }
}
