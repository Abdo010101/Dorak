/// Body for `POST /patient/social-login`.
///
/// Spec: `{provider, id_token, fcm_token, name?}` where
/// `provider` is one of `google|apple`.
class LoginWithSocialRequest {
  LoginWithSocialRequest({
    required this.provider,
    required this.idToken,
    required this.fcmToken,
    this.name,
  });

  String provider;
  String idToken;
  String fcmToken;
  String? name;

  LoginWithSocialRequest.fromJson(Map<String, dynamic> json)
      : provider = json['provider'] as String,
        idToken = json['id_token'] as String,
        fcmToken = json['fcm_token'] as String,
        name = json['name'] as String?;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'provider': provider,
        'id_token': idToken,
        'fcm_token': fcmToken,
        if (name != null) 'name': name,
      };
}
