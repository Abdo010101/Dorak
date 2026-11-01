import 'dart:convert';

/// Returned by `POST /patient/check-otp` and `POST /patient/social-login`.
///
/// `isNewUser` + `profileCompleted` drive post-OTP routing: if
/// `profileCompleted` is false, the mobile app sends the user through
/// `complete-profile-data` before the main shell.
class UserResponse {
  String? token;
  bool? isNewUser;
  bool? profileCompleted;
  Patient? patient;

  UserResponse({
    this.token,
    this.isNewUser,
    this.profileCompleted,
    this.patient,
  });

  UserResponse.fromJson(Map<String, dynamic> json) {
    token = json['token'] as String?;
    isNewUser = json['is_new_user'] as bool?;
    profileCompleted = json['profile_completed'] as bool?;
    patient =
        json['patient'] != null ? Patient.fromJson(json['patient']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['token'] = token;
    if (isNewUser != null) data['is_new_user'] = isNewUser;
    if (profileCompleted != null) data['profile_completed'] = profileCompleted;
    if (patient != null) data['patient'] = patient!.toJson();
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

/// Mirrors `PatientResource` / `PatientModelRaw` on the backend.
///
/// Scope v2 fields: `id, name, phone, full_phone, email, gender, birth_date,
/// city, allow_notifications, verified_at`. `weight`, `height`, `country_id`
/// from v1 are gone.
class Patient {
  int? id;
  String? name;
  String? phone;
  String? fullPhone;
  String? email;
  String? gender;
  String? birthDate;
  PatientCity? city;
  int? allowNotifications;
  String? verifiedAt;

  Patient({
    this.id,
    this.name,
    this.phone,
    this.fullPhone,
    this.email,
    this.gender,
    this.birthDate,
    this.city,
    this.allowNotifications,
    this.verifiedAt,
  });

  Patient.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    name = json['name'] as String?;
    phone = json['phone'] as String?;
    fullPhone = json['full_phone'] as String?;
    email = json['email'] as String?;
    gender = json['gender'] as String?;
    birthDate = json['birth_date'] as String?;
    final cityValue = json['city'];
    if (cityValue is Map<String, dynamic>) {
      city = PatientCity.fromJson(cityValue);
    } else if (cityValue is String) {
      city = PatientCity(name: cityValue);
    }
    allowNotifications = json['allow_notifications'] as int?;
    verifiedAt = json['verified_at'] as String?;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['full_phone'] = fullPhone;
    data['email'] = email;
    data['gender'] = gender;
    data['birth_date'] = birthDate;
    if (city != null) data['city'] = city!.toJson();
    data['allow_notifications'] = allowNotifications;
    data['verified_at'] = verifiedAt;
    return data;
  }
}

/// Nested `city` on `PatientResource`. Backend may send either an object
/// `{id, name}` or (rarely) a bare string — [Patient.fromJson] handles both.
class PatientCity {
  int? id;
  String? name;

  PatientCity({this.id, this.name});

  PatientCity.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        if (id != null) 'id': id,
        if (name != null) 'name': name,
      };
}
