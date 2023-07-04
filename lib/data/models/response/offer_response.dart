class OfferResponse {
  int? id;
  String? mainPic;
  String? title;
  String? description;
  String? priceAfter;
  String? priceBefore;
  int? isActive;
  Doctor? doctor;

  OfferResponse(
      {this.id,
      this.mainPic,
      this.title,
      this.description,
      this.priceAfter,
      this.priceBefore,
      this.isActive,
      this.doctor});

  OfferResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainPic = json['main_pic'];
    title = json['title'];
    description = json['description'];
    priceAfter = json['price_after'];
    priceBefore = json['price_before'];
    isActive = json['is_active'];
    doctor =
        json['doctor'] != null ? new Doctor.fromJson(json['doctor']) : null;
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

class Doctor {
  int? id;
  String? name;
  String? image;
  String? bio;
  String? examinationPrice;
  int? examinationDuration;
  String? address;
  String? rate;
  int? ratingsCount;
  bool? canRate;
  bool? isSponsored;

  Doctor(
      {this.id,
      this.name,
      this.image,
      this.bio,
      this.examinationPrice,
      this.examinationDuration,
      this.address,
      this.rate,
      this.ratingsCount,
      this.isSponsored,
      this.canRate});

  Doctor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    bio = json['bio'];
    examinationPrice = json['examination_price'];
    examinationDuration = json['examination_duration'];
    address = json['address'];
    rate = json['rate'];
    ratingsCount = json['ratings_count'];
    canRate = json['can_rate'];
    isSponsored = json['is_sponsored'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    data['bio'] = bio;
    data['examination_price'] = examinationPrice;
    data['examination_duration'] = examinationDuration;
    data['address'] = address;
    data['rate'] = rate;
    data['ratings_count'] = ratingsCount;
    data['can_rate'] = canRate;
    data['is_sponsored'] = isSponsored;

    return data;
  }
}
