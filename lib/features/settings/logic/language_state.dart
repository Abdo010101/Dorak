import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class LanguageState extends Equatable {
  const LanguageState({required this.locale});

  const LanguageState.initial() : locale = const Locale('ar');

  final Locale locale;

  bool get isArabic => locale.languageCode == 'ar';

  LanguageState copyWith({Locale? locale}) =>
      LanguageState(locale: locale ?? this.locale);

  @override
  List<Object?> get props => [locale];
}
