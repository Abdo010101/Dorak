import 'package:flutter/widgets.dart';

/// Picks the font family by active locale.
///
/// Arabic uses Tajawal (already shipped in `assets/fonts/`).
/// Latin falls back to Plus Jakarta Sans (DS). If the Plus Jakarta
/// Sans asset is not bundled, the default system font is used.
class AppFontFamilies {
  const AppFontFamilies._();

  static const String arabic = 'Tajawal';
  static const String latin = 'Plus Jakarta Sans';

  static String resolve(BuildContext context) {
    final locale = Localizations.localeOf(context);
    return locale.languageCode == 'ar' ? arabic : latin;
  }

  static String resolveLocale(Locale? locale) {
    return (locale?.languageCode == 'ar') ? arabic : latin;
  }
}
