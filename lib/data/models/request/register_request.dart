class RegisterRequest {
  String? name;
  String? email;
  String? phone;
  String? password;
  String? passwordConfirmation;
  int? accepted;
  String? token;

  RegisterRequest({
    this.name,
    this.email,
    this.phone,
    this.password,
    this.passwordConfirmation,
    this.token,
    this.accepted,
  });

  RegisterRequest.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    accepted = json['accepted'];
    token = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['password'] = password;
    data['password_confirmation'] = passwordConfirmation;
    data['accepted'] = accepted;
    data['fcm_token'] = token;

    return data;
  }
}
