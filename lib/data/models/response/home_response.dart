class HomeResponse {
  List<BestDoctors>? bestDoctors;
  List<LatestOffers>? latestOffers;
  // List<Null>? patientReservations;

  HomeResponse({
    this.bestDoctors,
    this.latestOffers,
    /*this.patientReservations*/
  });

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['best_doctors'] != null) {
      bestDoctors = <BestDoctors>[];
      json['best_doctors'].forEach((v) {
        bestDoctors!.add(new BestDoctors.fromJson(v));
      });
    }
    if (json['latest_offers'] != null) {
      latestOffers = <LatestOffers>[];
      json['latest_offers'].forEach((v) {
        latestOffers!.add(new LatestOffers.fromJson(v));
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

class LatestOffers {
  int? id;
  String? mainPic;
  String? title;
  String? description;
  String? priceAfter;
  String? priceBefore;
  int? isActive;
  BestDoctors? doctor;

  LatestOffers(
      {this.id,
      this.mainPic,
      this.title,
      this.description,
      this.priceAfter,
      this.priceBefore,
      this.isActive,
      this.doctor});

  LatestOffers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainPic = json['main_pic'];
    title = json['title'];
    description = json['description'];
    priceAfter = json['price_after'];
    priceBefore = json['price_before'];
    isActive = json['is_active'];
    doctor = json['doctor'] != null
        ? new BestDoctors.fromJson(json['doctor'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_pic'] = this.mainPic;
    data['title'] = this.title;
    data['description'] = this.description;
    data['price_after'] = this.priceAfter;
    data['price_before'] = this.priceBefore;
    data['is_active'] = this.isActive;
    if (this.doctor != null) {
      data['doctor'] = this.doctor!.toJson();
    }
    return data;
  }
}
