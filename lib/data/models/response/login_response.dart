import 'dart:convert';

class UserResponse {
  String? token;
  Patient? patient;

  UserResponse({this.token, this.patient});

  UserResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    if (patient != null) {
      data['patient'] = patient!.toJson();
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
  String? verifiedAt;

  Patient(
      {this.id,
      this.name,
      this.phone,
      this.email,
      this.gender,
      this.weight,
      this.height,
      this.allowNotifications,
      this.countryId,
      this.verifiedAt});

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
    verifiedAt = json['verified_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['email'] = email;
    data['gender'] = gender;
    data['weight'] = weight;
    data['height'] = height;
    data['allow_notifications'] = allowNotifications;
    data['country_id'] = countryId;
    data['country_id'] = verifiedAt;
    return data;
  }
}
