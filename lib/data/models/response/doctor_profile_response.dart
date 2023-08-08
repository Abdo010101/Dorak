import 'package:dorakpattient/data/models/response/response.dart';

class DoctorProfileResponse {
  Doctor? doctor;
  List<Places>? places;
  List<Ratings>? ratings;

  DoctorProfileResponse({this.doctor, this.places, this.ratings});

  DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (doctor != null) {
      data['doctor'] = doctor!.toJson();
    }
    if (places != null) {
      data['places'] = places!.map((v) => v.toJson()).toList();
    }
    if (ratings != null) {
      data['ratings'] = ratings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
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
