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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email_or_phone'] = this.emailOrPhone;
    data['password'] = this.password;
    data['fcm_token'] = this.token;
    return data;
  }
}
