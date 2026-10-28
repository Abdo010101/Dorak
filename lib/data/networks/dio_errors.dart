import 'package:dio/dio.dart';
import 'package:dorakpattient/data/networks/base_model.dart';
import 'package:flutter/material.dart';

class DioExceptions implements Exception {
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout with API server';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.connectionError:
        message = 'Connection to API server failed due to internet connection';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout in connection with API server';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
          dioError.response?.statusCode,
          dioError.response?.data,
        );
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout in connection with API server';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.badCertificate:
        message = 'Bad certificate';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      case DioExceptionType.unknown:
        message = 'Something went wrong';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
      default:
        message = 'Something went wrong';
        errorResponse = ErrorResponse(dioError: dioError);
        break;
    }
  }

  String? message;
  ErrorResponse? errorResponse;

  String _handleError(int? statusCode, dynamic error) {
    debugPrint(
      'Handle error for response code: $statusCode, and response : $error',
    );
    switch (statusCode) {
      case 401:
        return 'Not authorized';
      case 422:
        return (error['errors'] as List).first['error'];
      case 400:
        return 'Bad request';
      case 404:
        return error['message'];
      case 500:
        return 'Internal server error';
      default:
        return 'Oops something went wrong';
    }
  }

  @override
  String toString() => message ?? '';
}
