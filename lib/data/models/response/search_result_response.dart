import 'response.dart';

class SearchResultResponse {
  String? maxPrice;
  String? minPrice;
  Doctors? doctors;

  SearchResultResponse({this.maxPrice, this.minPrice, this.doctors});

  SearchResultResponse.fromJson(Map<String, dynamic> json) {
    maxPrice = json['max_price'];
    minPrice = json['min_price'];
    doctors =
        json['doctors'] != null ? new Doctors.fromJson(json['doctors']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['max_price'] = this.maxPrice;
    data['min_price'] = this.minPrice;
    if (this.doctors != null) {
      data['doctors'] = this.doctors!.toJson();
    }
    return data;
  }
}

class Doctors {
  List<Doctor>? data;

  Doctors({
    this.data,
  });

  Doctors.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Doctor>[];
      json['data'].forEach((v) {
        data!.add(new Doctor.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }

    return data;
  }
}
