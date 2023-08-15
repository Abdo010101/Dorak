import 'response.dart';

class HomeResponse {
  List<Doctor>? bestDoctors;
  List<OfferResponse>? latestOffers;
  List<AppointmentResponse>? patientReservations;
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
      patientReservations = <AppointmentResponse>[];
      json['patient_reservations'].forEach((v) {
        patientReservations!.add(AppointmentResponse.fromJson(v));
      });
    }
    if (json['latest_offers'] != null) {
      latestOffers = <OfferResponse>[];
      json['latest_offers'].forEach((v) {
        latestOffers!.add(OfferResponse.fromJson(v));
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
    final Map<String, dynamic> data = <String, dynamic>{};
    if (bestDoctors != null) {
      data['best_doctors'] = bestDoctors!.map((v) => v.toJson()).toList();
    }
    if (latestOffers != null) {
      data['latest_offers'] = latestOffers!.map((v) => v.toJson()).toList();
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
    final Map<String, dynamic> data = <String, dynamic>{};
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
