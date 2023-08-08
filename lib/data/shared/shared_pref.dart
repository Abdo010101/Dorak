import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';
import '../models/response/response.dart';

class SharedPref {
  static SharedPref? _instance;
  static SharedPreferences? _preferences;

  static Future<SharedPref> getInstance() async {
    _instance ??= SharedPref();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> storeLoginInfo(UserResponse userResponse) async {
    return await _preferences!
        .setString(
            'access_token', NetworkConstant.tokenBuilder(userResponse.token!))
        /*  .then((value) =>
            sharedPref.setInt('expires_in', loginResponse.expiresIn!))
        .then((value) =>
            sharedPref.setString('refresh_token', loginResponse.refreshToken!))*/
        .then((value) {
      return _preferences!.setString(
          'user_data', userResponse.convertUserToSharedPreferencesObject());
    });
  }

  Future<UserResponse> retrieveUserInfo() async {
    return UserResponse.fromSharedPreferencesObject(
        _preferences!.getString('user_data'));
  }

  Future<bool> storeVisitorId(String visitorId) async {
    return await _preferences!.setString('visitor_id', visitorId);
  }

  Future<bool> saveBaseUrl(String baseUrl) async {
    return await _preferences!.setString('base_url', baseUrl);
  }

  Future<String?> getBaseUrl() async {
    return _preferences!.getString('base_url');
  }

  Future<void> saveDraftRequest(String draft) async {
    await _preferences!.setString('draft_request', draft);
  }

  Future<String?> loadDraftRequest() async {
    return _preferences!.getString('draft_request');
  }

  bool isUserLoggedIn() {
    return _preferences!.containsKey('access_token');
  }

  String getAccessToken() {
    return _preferences!.getString('access_token') ?? '';
  }

  String getRefreshToken() {
    return _preferences!.getString('refresh_token') ?? '';
  }

  DateTime getExpirationTime() {
    final expire = _preferences!.getInt('expires_in') ?? 0;
    return DateTime.fromMillisecondsSinceEpoch(expire * 1000);
  }

  void deleteLoginInfo() {
    if (_preferences!.containsKey('access_token')) {
      _preferences!.clear();
    }
  }

  Future<bool> storeFirstTime() async {
    return await _preferences!.setBool('FirstTime', true);
  }

  Future<bool?> getFirstTime() async {
    return _preferences!.getBool('FirstTime');
  }

  void setLoginType(LoginSocialType type) {
    _preferences!.setString('login_type', type.name);
  }

  String getLoginType() {
    return _preferences!.getString('login_type') ?? '';
  }
}
