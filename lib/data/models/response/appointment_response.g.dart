// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appointment_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppointmentResponse _$AppointmentResponseFromJson(Map<String, dynamic> json) =>
    AppointmentResponse(
      id: json['id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      status: json['status'] as String?,
      rate: json['rate'] as String?,
      day: json['day'] as String?,
      month: json['month'] as String?,
      mainSpecialization: json['main_specialization'] as String?,
      image: json['full_image_path'] as String?,
    );

Map<String, dynamic> _$AppointmentResponseToJson(
        AppointmentResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'status': instance.status,
      'rate': instance.rate,
      'day': instance.day,
      'month': instance.month,
      'main_specialization': instance.mainSpecialization,
      'full_image_path': instance.image,
    };
