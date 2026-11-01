import 'package:dorakpattient/data/models/response/response.dart';

class DoctorProfileResponse {
  Doctor? doctor;
  DoctorProfile? profile;
  List<Places>? places;
  List<Ratings>? ratings;

  DoctorProfileResponse({this.doctor, this.profile, this.places, this.ratings});

  DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    if (json['profile'] is Map<String, dynamic>) {
      profile =
          DoctorProfile.fromJson(json['profile'] as Map<String, dynamic>);
    }
    if (json['places'] != null) {
      places = <Places>[];
      json['places'].forEach((v) {
        places!.add(Places.fromJson(v));
      });
    }
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(Ratings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (doctor != null) data['doctor'] = doctor!.toJson();
    if (profile != null) data['profile'] = profile!.toJson();
    if (places != null) {
      data['places'] = places!.map((v) => v.toJson()).toList();
    }
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

/// `data.profile` on `GET /patient/doctors/{doctor}`.
///
/// Scope §11 `DoctorProfile`: `{headline, rating, ratings_count,
/// experience_years, patients_count, bio, bio_url, branches[], services[],
/// is_favorite, contact_phone}` (last one added 2026-11-01).
class DoctorProfile {
  String? headline;
  String? rating;
  int? ratingsCount;
  int? experienceYears;
  int? patientsCount;
  String? bio;
  String? bioUrl;
  List<String>? branches;
  List<String>? services;
  bool? isFavorite;
  String? contactPhone;

  DoctorProfile({
    this.headline,
    this.rating,
    this.ratingsCount,
    this.experienceYears,
    this.patientsCount,
    this.bio,
    this.bioUrl,
    this.branches,
    this.services,
    this.isFavorite,
    this.contactPhone,
  });

  DoctorProfile.fromJson(Map<String, dynamic> json) {
    headline = json['headline'] as String?;
    rating = json['rating']?.toString();
    ratingsCount = json['ratings_count'] as int?;
    experienceYears = json['experience_years'] as int?;
    patientsCount = json['patients_count'] as int?;
    bio = json['bio'] as String?;
    bioUrl = json['bio_url'] as String?;
    if (json['branches'] is List) {
      branches =
          (json['branches'] as List).map((v) => v.toString()).toList();
    }
    if (json['services'] is List) {
      services =
          (json['services'] as List).map((v) => v.toString()).toList();
    }
    isFavorite = json['is_favorite'] as bool?;
    contactPhone = json['contact_phone'] as String?;
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (headline != null) 'headline': headline,
        if (rating != null) 'rating': rating,
        if (ratingsCount != null) 'ratings_count': ratingsCount,
        if (experienceYears != null) 'experience_years': experienceYears,
        if (patientsCount != null) 'patients_count': patientsCount,
        if (bio != null) 'bio': bio,
        if (bioUrl != null) 'bio_url': bioUrl,
        if (branches != null) 'branches': branches,
        if (services != null) 'services': services,
        if (isFavorite != null) 'is_favorite': isFavorite,
        if (contactPhone != null) 'contact_phone': contactPhone,
      };
}

class Places {
  int? id;
  List<String>? images;
  String? name;
  String? phone;
  String? description;
  String? shortAddress;
  String? longAddress;
  String? lat;
  String? lng;
  String? examinationPrice;
  int? examinationDuration;
  bool? reservationStatus;

  Places(
      {this.id,
      this.images,
      this.name,
      this.phone,
      this.shortAddress,
      this.longAddress,
      this.description,
      this.lat,
      this.lng,
      this.examinationPrice,
      this.examinationDuration,
      this.reservationStatus});

  Places.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    images = json['images'].cast<String>();
    name = json['name'];
    phone = json['phone'];
    shortAddress = json['short_address'];
    longAddress = json['long_address'];
    lat = json['lat'];
    lng = json['lng'];
    description = json['description'];
    examinationPrice = json['examination_price'];
    examinationDuration = json['examination_duration'];
    reservationStatus = json['reservation_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['images'] = images;
    data['name'] = name;
    data['phone'] = phone;
    data['short_address'] = shortAddress;
    data['long_address'] = longAddress;
    data['lat'] = lat;
    data['lng'] = lng;
    data['examination_price'] = examinationPrice;
    data['examination_duration'] = examinationDuration;
    data['reservation_status'] = reservationStatus;
    return data;
  }
}

class Ratings {
  int? id;
  String? name;
  String? comment;
  int? rating;
  String? time;

  Ratings({this.id, this.name, this.comment, this.rating, this.time});

  Ratings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    comment = json['comment'];
    rating = json['rating'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['comment'] = comment;
    data['rating'] = rating;
    data['time'] = time;
    return data;
  }
}
