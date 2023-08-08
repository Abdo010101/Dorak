class LoginRequest {
  String? emailOrPhone;
  String? password;
  String? token;
  LoginRequest({
    this.emailOrPhone,
    this.password,
    this.token,
  });

  LoginRequest.fromJson(Map<String, dynamic> json) {
    emailOrPhone = json['email_or_phone'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email_or_phone'] = emailOrPhone;
    data['password'] = password;
    data['fcm_token'] = token;
    return data;
  }
}
