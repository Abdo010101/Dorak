import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

import 'api_exception.dart';
import 'converter/error_response_converter.dart';

part 'base_model.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseModel<T> {
  @ErrorResponseConverter()
  ErrorResponse? error;
  T? data;

  BaseModel.noNetworkConnection() {
    error = ErrorResponse.noNetworkConnection();
  }

  BaseModel({this.data, this.error});

  factory BaseModel.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseModelFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseModelToJson(this, toJsonT);

  @override
  String toString() {
    return 'BaseModel{error: $error, data: $data}';
  }
}

class ErrorResponse {
  DioError? dioError;
  String? message;
  List<dynamic>? errors;
  int? statusCode;

  ErrorResponse({this.dioError}) {
    debugPrint('Response Error :${dioError?.response?.data.toString()}');

    statusCode = dioError?.response?.statusCode;
    Map<String, dynamic>? errorData = dioError?.response?.data['errors'];
    List? errorsList = errorData?.values.map((e) => e.first).toList();

    message = statusCode == 422
        ? errorsList?.first
        : dioError?.response?.data['error'];
    errors = errorsList ?? List.empty();

    //Special case for Not Default Error Scheme .
    //  message ??= dioError?.response?.data?.values.toString();
  }

  ErrorResponse.noNetworkConnection() {
    message = ApiException.noInternetConnectionMsg;
  }

  @override
  String toString() {
    return 'ErrorResponse{dioError: $dioError, message: $message, errors: $errors, statusCode: $statusCode}';
  }
}
