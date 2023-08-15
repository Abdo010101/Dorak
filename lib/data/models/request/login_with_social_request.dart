class LoginWithSocialRequest {
  String? email;
  String? name;
  String? socialId;
  String? firebaseToken;
  LoginWithSocialRequest(
      {this.email, this.name, this.socialId, this.firebaseToken});

  LoginWithSocialRequest.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    socialId = json['social_id'];
    firebaseToken = json['fcm_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['name'] = name;
    data['social_id'] = socialId;
    data['fcm_token'] = firebaseToken;
    return data;
  }
}
