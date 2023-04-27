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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['name'] = this.name;
    data['social_id'] = this.socialId;
    data['fcm_token'] = this.firebaseToken;
    return data;
  }
}
