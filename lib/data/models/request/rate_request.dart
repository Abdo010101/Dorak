import 'package:json_annotation/json_annotation.dart';

part 'rate_request.g.dart';

@JsonSerializable()
class RateRequest {
  String? comment;
  int? rate;
  @JsonKey(name: 'doctor_id')
  int? doctorId;

  RateRequest({this.comment, this.rate, this.doctorId});

  factory RateRequest.fromJson(Map<String, dynamic> json) =>
      _$RateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RateRequestToJson(this);
}
