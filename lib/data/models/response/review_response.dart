import 'package:json_annotation/json_annotation.dart';

part 'review_response.g.dart';

@JsonSerializable()
class ReviewResponse {
  int? id;
  String? name;
  String? comment;
  int? rating;
  String? time;

  ReviewResponse({this.id, this.name, this.comment, this.rating, this.time});

  factory ReviewResponse.fromJson(Map<String, dynamic> json) =>
      _$ReviewResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ReviewResponseToJson(this);
}
