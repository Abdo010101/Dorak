import 'package:equatable/equatable.dart';

import '../../../core/state/status.dart';
import '../../../data/models/response/response.dart';

class SearchState extends Equatable {
  const SearchState({
    this.status = Status.initial,
    this.query = '',
    this.filters = const <String, dynamic>{},
    this.result,
    this.errorMessage,
  });

  final Status status;
  final String query;
  final Map<String, dynamic> filters;
  final SearchResultResponse? result;
  final String? errorMessage;

  SearchState copyWith({
    Status? status,
    String? query,
    Map<String, dynamic>? filters,
    SearchResultResponse? result,
    String? errorMessage,
    bool clearError = false,
  }) =>
      SearchState(
        status: status ?? this.status,
        query: query ?? this.query,
        filters: filters ?? this.filters,
        result: result ?? this.result,
        errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      );

  @override
  List<Object?> get props => [status, query, filters, result, errorMessage];
}
