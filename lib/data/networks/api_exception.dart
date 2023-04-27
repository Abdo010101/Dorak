import 'package:quiver/strings.dart';

class ApiException implements Exception {
  // Variables
  final int code;
  final String message;
  final String reason;

  // Fixed Code Messages
  static String loginInfoFailedMsg = ('login_info_not_correct_try_again');
  static String authorizationFailedMsg = ('please_login_and_try_again');
  static String timeOutConnectionMsg = ('time_out');
  static String noInternetConnectionMsg = ('no_internet_connection');
  static String unknownErr = ('unknown_error');

  ApiException(
      {required this.code, required this.message, required this.reason});

  @override
  String toString() {
    String _text = "";
//    _text += tr('error');
//    _text += "($code) ";
    if (!isBlank(message)) _text += message;
    if (!isBlank(reason)) _text += " , $reason.";
    return _text;
  }
}
