import 'package:json_annotation/json_annotation.dart';

part 'terms_policy_response.g.dart';

@JsonSerializable()
class TermsPolicyResponse {
  String? terms;
  String? privacy;
  TermsPolicyResponse({this.privacy, this.terms});

  factory TermsPolicyResponse.fromJson(Map<String, dynamic> json) =>
      _$TermsPolicyResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TermsPolicyResponseToJson(this);
}
