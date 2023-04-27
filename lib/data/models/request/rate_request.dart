import 'package:json_annotation/json_annotation.dart';

part 'rate_request.g.dart';

@JsonSerializable()
class RateRequest {
  String? comment;
  int? rate;

  RateRequest({this.comment, this.rate});

  factory RateRequest.fromJson(Map<String, dynamic> json) =>
      _$RateRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RateRequestToJson(this);
}
