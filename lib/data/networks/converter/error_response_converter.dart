import 'package:json_annotation/json_annotation.dart';

import '../base_model.dart';

class ErrorResponseConverter extends JsonConverter<ErrorResponse?, Object?> {
  const ErrorResponseConverter();

  @override
  ErrorResponse fromJson(Object? json) {
    return json as ErrorResponse;
  }

  @override
  Object? toJson(ErrorResponse? object) => object;
}
