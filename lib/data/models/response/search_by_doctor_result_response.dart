import 'package:dorakpattient/data/models/response/response.dart';

class SearchResultData {
  List<Titles>? specialization;
  List<Doctor>? doctors;
  List<MedicalsCenter>? medicalsCenters;

  SearchResultData({this.specialization, this.doctors, this.medicalsCenters});

  SearchResultData.fromJson(Map<String, dynamic> json) {
    if (json['specialization'] != null) {
      specialization = <Titles>[];
      json['specialization'].forEach((v) {
        specialization!.add(new Titles.fromJson(v));
      });
    }
    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(new Doctor.fromJson(v));
      });
    }
    if (json['medicals_centers'] != null) {
      medicalsCenters = <MedicalsCenter>[];
      json['medicals_centers'].forEach((v) {
        medicalsCenters!.add(new MedicalsCenter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.specialization != null) {
      data['specialization'] =
          this.specialization!.map((v) => v.toJson()).toList();
    }
    if (this.doctors != null) {
      data['doctors'] = this.doctors!.map((v) => v.toJson()).toList();
    }
    if (this.medicalsCenters != null) {
      data['medicals_centers'] =
          this.medicalsCenters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
