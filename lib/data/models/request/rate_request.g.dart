// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateRequest _$RateRequestFromJson(Map<String, dynamic> json) => RateRequest(
      comment: json['comment'] as String?,
      rate: json['rate'] as int?,
      doctorId: json['doctor_id'] as int?,
    );

Map<String, dynamic> _$RateRequestToJson(RateRequest instance) =>
    <String, dynamic>{
      'comment': instance.comment,
      'rate': instance.rate,
      'doctor_id': instance.doctorId,
    };
