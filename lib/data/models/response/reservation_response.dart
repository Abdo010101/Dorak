class ReservationResponse {
  int? id;
  String? mainSpecialization;
  String? fullImagePath;
  String? name;
  String? rate;
  String? phone;
  String? status;
  String? date;
  String? day;
  String? month;

  ReservationResponse(
      {this.id,
      this.mainSpecialization,
      this.fullImagePath,
      this.name,
      this.rate,
      this.phone,
      this.status,
      this.date,
      this.day,
      this.month});

  ReservationResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    mainSpecialization = json['main_specialization'];
    fullImagePath = json['full_image_path'];
    name = json['name'];
    rate = json['rate'];
    phone = json['phone'];
    status = json['status'];
    date = json['date'];
    day = json['day'];
    month = json['month'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['main_specialization'] = mainSpecialization;
    data['full_image_path'] = fullImagePath;
    data['name'] = name;
    data['rate'] = rate;
    data['phone'] = phone;
    data['status'] = status;
    data['date'] = date;
    data['day'] = day;
    data['month'] = month;
    return data;
  }
}
