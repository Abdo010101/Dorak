import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../data/di/locator.dart';
import '../routes/dorak_routes.dart';

class LanguageController extends ChangeNotifier {
  static final allLocales = [
    const Locale('en'),
    const Locale('ar'),
  ];
  String checkStatus = 'عربى';

  void changeCheckStatus(value, BuildContext context) {
    if (value != checkStatus) {
      checkStatus = value;
      changeLocale('English' == value ? allLocales[0] : allLocales[1], context);
    }
    notifyListeners();
  }

  void changeLocale(Locale value, BuildContext context) {
    context.setLocale(value);
    InjectionClass.dio.options.headers['Content-language'] = value.languageCode;
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
          context, NameRoutes.kSplashScreen, (_) => false);
    }
  }
}
