import 'dart:convert';

class UserResponse {
  String? token;
  Patient? patient;

  UserResponse({this.token, this.patient});

  UserResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    patient =
        json['patient'] != null ? new Patient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    if (this.patient != null) {
      data['patient'] = this.patient!.toJson();
    }
    return data;
  }

  String convertUserToSharedPreferencesObject() => jsonEncode(this);

  factory UserResponse.fromSharedPreferencesObject(String? prefObject) {
    if (prefObject != null) {
      return UserResponse.fromJson(jsonDecode(prefObject));
    }
    return UserResponse();
  }
}

class Patient {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? gender;
  String? weight;
  String? height;
  int? allowNotifications;
  String? countryId;

  Patient(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.gender,
      this.weight,
      this.height,
      this.allowNotifications,
      this.countryId});

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    gender = json['gender'];
    weight = json['weight'];
    height = json['height'];
    allowNotifications = json['allow_notifications'];
    countryId = json['country_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['weight'] = this.weight;
    data['height'] = this.height;
    data['allow_notifications'] = this.allowNotifications;
    data['country_id'] = this.countryId;
    return data;
  }
}
