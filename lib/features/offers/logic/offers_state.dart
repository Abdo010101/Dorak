import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class OffersState extends Equatable {
  const OffersState({
    this.status = Status.initial,
    this.offers = const [],
    this.query = '',
    this.minPrice,
    this.maxPrice,
    this.errorMessage,
  });

  final Status status;
  final List<OfferResponse> offers;
  final String query;
  final String? minPrice;
  final String? maxPrice;
  final String? errorMessage;

  OffersState copyWith({
    Status? status,
    List<OfferResponse>? offers,
    String? query,
    String? minPrice,
    String? maxPrice,
    String? errorMessage,
    bool clearError = false,
  }) =>
      OffersState(
        status: status ?? this.status,
        offers: offers ?? this.offers,
        query: query ?? this.query,
        minPrice: minPrice ?? this.minPrice,
        maxPrice: maxPrice ?? this.maxPrice,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props =>
      [status, offers, query, minPrice, maxPrice, errorMessage];
}
