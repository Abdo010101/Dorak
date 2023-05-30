import 'response.dart';

class HomeResponse {
  List<Doctor>? bestDoctors;
  List<OfferResponse>? latestOffers;
  List<PatientReservations>? patientReservations;
  HomeResponse({
    this.bestDoctors,
    this.latestOffers,
    /*this.patientReservations*/
  });

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['best_doctors'] != null) {
      bestDoctors = <Doctor>[];
      json['best_doctors'].forEach((v) {
        bestDoctors!.add(Doctor.fromJson(v));
      });
    }
    if (json['patient_reservations'] != null) {
      patientReservations = <PatientReservations>[];
      json['patient_reservations'].forEach((v) {
        patientReservations!.add(PatientReservations.fromJson(v));
      });
    }
    if (json['latest_offers'] != null) {
      latestOffers = <OfferResponse>[];
      json['latest_offers'].forEach((v) {
        latestOffers!.add(new OfferResponse.fromJson(v));
      });
    }
/*    if (json['patient_reservations'] != null) {
      patientReservations = <Null>[];
      json['patient_reservations'].forEach((v) {
        patientReservations!.add(new Null.fromJson(v));
      });
    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bestDoctors != null) {
      data['best_doctors'] = this.bestDoctors!.map((v) => v.toJson()).toList();
    }
    if (this.latestOffers != null) {
      data['latest_offers'] =
          this.latestOffers!.map((v) => v.toJson()).toList();
    }
    /* if (this.patientReservations != null) {
      data['patient_reservations'] =
          this.patientReservations!.map((v) => v.toJson()).toList();
    }*/
    return data;
  }
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

  BestDoctors(
      {this.id,
      this.name,
      this.image,
      this.bio,
      this.examinationPrice,
      this.examinationDuration,
      this.address,
      this.rate,
      this.ratingsCount});

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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['bio'] = this.bio;
    data['examination_price'] = this.examinationPrice;
    data['examination_duration'] = this.examinationDuration;
    data['address'] = this.address;
    data['rate'] = this.rate;
    data['ratings_count'] = this.ratingsCount;
    return data;
  }
}

class PatientReservations {
  int? id;
  String? mainSpecialization;
  String? fullImagePath;
  String? name;
  String? rate;
  String? phone;
  String? status;
  String? date;
  String? time;
  String? day;
  String? month;

  PatientReservations(
      {this.id,
      this.mainSpecialization,
      this.fullImagePath,
      this.name,
      this.rate,
      this.phone,
      this.status,
      this.date,
      this.time,
      this.day,
      this.month});

  PatientReservations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainSpecialization = json['main_specialization'];
    fullImagePath = json['full_image_path'];
    name = json['name'];
    rate = json['rate'];
    phone = json['phone'];
    status = json['status'];
    date = json['date'];
    time = json['time'];
    day = json['day'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_specialization'] = this.mainSpecialization;
    data['full_image_path'] = this.fullImagePath;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['date'] = this.date;
    data['time'] = this.time;
    data['day'] = this.day;
    data['month'] = this.month;
    return data;
  }
}
