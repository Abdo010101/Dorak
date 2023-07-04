import 'package:dorakpattient/data/models/response/response.dart';

class DoctorProfileResponse {
  Doctor? doctor;
  List<Places>? places;
  List<Ratings>? ratings;

  DoctorProfileResponse({this.doctor, this.places, this.ratings});

  DoctorProfileResponse.fromJson(Map<String, dynamic> json) {
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
    if (json['places'] != null) {
      places = <Places>[];
      json['places'].forEach((v) {
        places!.add(new Places.fromJson(v));
      });
    }
    if (json['ratings'] != null) {
      ratings = <Ratings>[];
      json['ratings'].forEach((v) {
        ratings!.add(new Ratings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    if (this.places != null) {
      data['places'] = this.places!.map((v) => v.toJson()).toList();
    }
    if (this.ratings != null) {
      data['ratings'] = this.ratings!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['images'] = this.images;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['short_address'] = this.shortAddress;
    data['long_address'] = this.longAddress;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['examination_price'] = this.examinationPrice;
    data['examination_duration'] = this.examinationDuration;
    data['reservation_status'] = this.reservationStatus;
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['time'] = this.time;
    return data;
  }
}
