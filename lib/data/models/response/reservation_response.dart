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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['main_specialization'] = this.mainSpecialization;
    data['full_image_path'] = this.fullImagePath;
    data['name'] = this.name;
    data['rate'] = this.rate;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['date'] = this.date;
    data['day'] = this.day;
    data['month'] = this.month;
    return data;
  }
}
