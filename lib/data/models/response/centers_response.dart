/// Shared card/detail resources for medical centers and clinics.
///
/// Scope §11 names them `MedicalCenterCardResource`, `ClinicCardResource`,
/// `MedicalCenterResource`, `DoctorCardResource`, `PlaceRatings`.
///
/// All models are hand-written (no `json_serializable`) because this
/// repo's `build_runner` toolchain is pinned to incompatible versions
/// (`retrofit 4.10.0` vs `retrofit_generator 10.0.6` — Round 1 note).

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  if (v is String) return double.tryParse(v);
  return null;
}

/// Returned by `GET /patient/medical-centers` and
/// `GET /patient/clinics` list rows (clinic variant adds [doctor] + [isSponsored]).
class MedicalCenterCard {
  String? type; // "medical_center" | "clinic"
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
  CardDoctor? doctor;
  bool? isSponsored;

  MedicalCenterCard({
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

  MedicalCenterCard.fromJson(Map<String, dynamic> json) {
    type = json['type'] as String?;
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    rating = json['rating']?.toString();
    ratingsCount = json['ratings_count'] as int?;
    distanceKm = _toDouble(json['distance_km']);
    if (json['specializations'] is List) {
      specializations =
          (json['specializations'] as List).map((v) => v.toString()).toList();
    }
    city = json['city'] as String?;
    area = json['area'] as String?;
    address = json['address'] as String?;
    availableToday = json['available_today'] as bool?;
    phone = json['phone'] as String?;
    lat = _toDouble(json['lat']);
    lng = _toDouble(json['lng']);
    if (json['doctor'] is Map<String, dynamic>) {
      doctor = CardDoctor.fromJson(json['doctor'] as Map<String, dynamic>);
    }
    isSponsored = json['is_sponsored'] as bool?;
  }
}

class CardDoctor {
  int? id;
  String? name;
  String? image;

  CardDoctor({this.id, this.name, this.image});

  CardDoctor.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?;
}

/// `GET /patient/medical-centers/{id}` detail resource.
class MedicalCenterDetails {
  MedicalCenterCard? card;
  String? description;
  List<String>? images;
  int? doctorsCount;
  List<CenterSpecialization>? specializations;
  List<CenterOffer>? offers;
  CenterRatings? ratings;
  bool? isFavorite;

  MedicalCenterDetails({
    this.card,
    this.description,
    this.images,
    this.doctorsCount,
    this.specializations,
    this.offers,
    this.ratings,
    this.isFavorite,
  });

  MedicalCenterDetails.fromJson(Map<String, dynamic> json) {
    final cardRaw = json['card'];
    if (cardRaw is Map<String, dynamic>) {
      card = MedicalCenterCard.fromJson(cardRaw);
    } else {
      // Some endpoints flatten card fields into the root instead of nesting.
      card = MedicalCenterCard.fromJson(json);
    }
    description = (json['description'] ?? json['about']) as String?;
    if (json['images'] is List) {
      images = (json['images'] as List).map((v) => v.toString()).toList();
    }
    doctorsCount = json['doctors_count'] as int?;
    if (json['specializations'] is List) {
      specializations = (json['specializations'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CenterSpecialization.fromJson)
          .toList();
    }
    if (json['offers'] is List) {
      offers = (json['offers'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CenterOffer.fromJson)
          .toList();
    }
    if (json['ratings'] is Map<String, dynamic>) {
      ratings = CenterRatings.fromJson(json['ratings'] as Map<String, dynamic>);
    }
    isFavorite = json['is_favorite'] as bool?;
  }
}

class CenterSpecialization {
  int? id;
  String? name;
  String? icon;
  int? doctorsCount;

  CenterSpecialization({this.id, this.name, this.icon, this.doctorsCount});

  CenterSpecialization.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        icon = json['icon'] as String?,
        doctorsCount = json['doctors_count'] as int?;
}

class CenterOffer {
  int? id;
  String? title;
  String? image;
  String? priceBefore;
  String? priceAfter;
  bool? isPriceShown;

  CenterOffer({
    this.id,
    this.title,
    this.image,
    this.priceBefore,
    this.priceAfter,
    this.isPriceShown,
  });

  CenterOffer.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        image = (json['image'] ?? json['main_pic']) as String?,
        priceBefore = json['price_before']?.toString(),
        priceAfter = json['price_after']?.toString(),
        isPriceShown = json['is_price_shown'] as bool?;
}

class CenterRatings {
  int? count;
  double? average;
  List<CenterRatingRow>? data;

  CenterRatings({this.count, this.average, this.data});

  CenterRatings.fromJson(Map<String, dynamic> json) {
    count = json['count'] as int?;
    average = _toDouble(json['average']);
    if (json['data'] is List) {
      data = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CenterRatingRow.fromJson)
          .toList();
    }
  }
}

class CenterRatingRow {
  int? id;
  String? name;
  String? image;
  String? comment;
  double? rating;
  String? time;

  CenterRatingRow({
    this.id,
    this.name,
    this.image,
    this.comment,
    this.rating,
    this.time,
  });

  CenterRatingRow.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?,
        image = json['image'] as String?,
        comment = json['comment'] as String?,
        rating = _toDouble(json['rating']),
        time = json['time'] as String?;
}

/// `GET /patient/medical-centers/{id}/doctors` resource.
/// Scope §11 names it `DoctorCardResource`.
class DoctorCard {
  int? id;
  String? name;
  String? image;
  String? title;
  String? headline;
  String? specialization;
  String? rating;
  int? ratingsCount;
  String? examinationPrice;
  int? examinationDuration;
  bool? isFavorite;

  DoctorCard({
    this.id,
    this.name,
    this.image,
    this.title,
    this.headline,
    this.specialization,
    this.rating,
    this.ratingsCount,
    this.examinationPrice,
    this.examinationDuration,
    this.isFavorite,
  });

  DoctorCard.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    image = json['image'] as String?;
    title = json['title'] as String?;
    headline = json['headline'] as String?;
    specialization = json['specialization'] as String?;
    rating = json['rating']?.toString();
    ratingsCount = json['ratings_count'] as int?;
    examinationPrice = json['examination_price']?.toString();
    examinationDuration = json['examination_duration'] as int?;
    isFavorite = json['is_favorite'] as bool?;
  }
}

/// Full response of `GET /patient/medical-centers/{id}/doctors`.
class DoctorsAtCenterResponse {
  int? doctorsCount;
  int? specializationsCount;
  List<CenterSpecialization>? chips;
  List<DoctorCard>? doctors;

  DoctorsAtCenterResponse({
    this.doctorsCount,
    this.specializationsCount,
    this.chips,
    this.doctors,
  });

  DoctorsAtCenterResponse.fromJson(Map<String, dynamic> json) {
    doctorsCount = json['doctors_count'] as int?;
    specializationsCount = json['specializations_count'] as int?;
    if (json['specializations'] is List) {
      chips = (json['specializations'] as List)
          .whereType<Map<String, dynamic>>()
          .map(CenterSpecialization.fromJson)
          .toList();
    }
    if (json['doctors'] is List) {
      doctors = (json['doctors'] as List)
          .whereType<Map<String, dynamic>>()
          .map(DoctorCard.fromJson)
          .toList();
    } else if (json['data'] is List) {
      doctors = (json['data'] as List)
          .whereType<Map<String, dynamic>>()
          .map(DoctorCard.fromJson)
          .toList();
    }
  }
}
