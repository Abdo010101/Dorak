import 'package:json_annotation/json_annotation.dart';

part 'appointment_response.g.dart';

@JsonSerializable()
class AppointmentResponse {
  int? id;
  String? name;
  String? phone;
  String? status;
  String? rate;
  String? date;
  String? day;
  String? month;
  @JsonKey(name: 'main_specialization')
  String? mainSpecialization;
  @JsonKey(name: 'full_image_path')
  String? image;

  AppointmentResponse({
    this.id,
    this.name,
    this.phone,
    this.status,
    this.rate,
    this.day,
    this.date,
    this.month,
    this.mainSpecialization,
    this.image,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) =>
      _$AppointmentResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AppointmentResponseToJson(this);
}
