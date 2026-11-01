import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'language_state.dart';

/// Owns the app locale. Side-effects (easy_localization setLocale,
/// Dio header, router reset) are performed by the caller inside a
/// `BlocListener`, so the Cubit itself stays Flutter-free below the
/// `Locale` boundary.
class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit({required Dio dio})
      : _dio = dio,
        super(const LanguageState.initial());

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  final Dio _dio;

  void setLocale(Locale next) {
    if (next == state.locale) return;
    _dio.options.headers['Content-Language'] = next.languageCode;
    emit(state.copyWith(locale: next));
  }

  /// Convenience for legacy UI that still passes `'English'` / `'عربى'`.
  void setByLabel(String label) {
    final next = label == 'English' ? const Locale('en') : const Locale('ar');
    setLocale(next);
  }
}
