import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';

/// UI model for a favourite center/clinic row.
class FavouriteCenter extends Equatable {
  const FavouriteCenter({
    required this.id,
    required this.name,
    required this.imageUrl,
    this.distance,
    this.rating,
  });

  final int id;
  final String name;
  final String? imageUrl;
  final String? distance;
  final double? rating;

  @override
  List<Object?> get props => [id, name, imageUrl, distance, rating];
}

class FavouritesState extends Equatable {
  const FavouritesState({
    this.status = Status.initial,
    this.items = const [],
    this.errorMessage,
  });

  final Status status;
  final List<FavouriteCenter> items;
  final String? errorMessage;

  FavouritesState copyWith({
    Status? status,
    List<FavouriteCenter>? items,
    String? errorMessage,
    bool clearError = false,
  }) =>
      FavouritesState(
        status: status ?? this.status,
        items: items ?? this.items,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, items, errorMessage];
}
