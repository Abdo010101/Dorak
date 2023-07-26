// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_client.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _AppointmentClient implements AppointmentClient {
  _AppointmentClient(
    this._dio, {
    this.baseUrl,
  });

  final Dio _dio;

  String? baseUrl;

  @override
  Future<BaseResponse<List<AppointmentResponse>>> getAllAppointments(
    type,
    pageKey,
  ) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<List<AppointmentResponse>>>(Options(
      method: 'GET',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              '${type}?page=${pageKey}',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<List<AppointmentResponse>>.fromJson(
      _result.data!,
      (json) => (json as List<dynamic>)
          .map<AppointmentResponse>(
              (i) => AppointmentResponse.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
    return value;
  }

  @override
  Future<BaseResponse<AppointmentResponse>> declineAppointment(body) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = body;
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<BaseResponse<AppointmentResponse>>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
    )
            .compose(
              _dio.options,
              'reservations/cancel-reservation',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = BaseResponse<AppointmentResponse>.fromJson(
      _result.data!,
      (json) => AppointmentResponse.fromJson(json as Map<String, dynamic>),
    );
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
