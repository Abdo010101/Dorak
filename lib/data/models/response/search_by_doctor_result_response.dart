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
        specialization!.add(Titles.fromJson(v));
      });
    }
    if (json['doctors'] != null) {
      doctors = <Doctor>[];
      json['doctors'].forEach((v) {
        doctors!.add(Doctor.fromJson(v));
      });
    }
    if (json['medicals_centers'] != null) {
      medicalsCenters = <MedicalsCenter>[];
      json['medicals_centers'].forEach((v) {
        medicalsCenters!.add(MedicalsCenter.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (specialization != null) {
      data['specialization'] = specialization!.map((v) => v.toJson()).toList();
    }
    if (doctors != null) {
      data['doctors'] = doctors!.map((v) => v.toJson()).toList();
    }
    if (medicalsCenters != null) {
      data['medicals_centers'] =
          medicalsCenters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
