import 'package:json_annotation/json_annotation.dart';

part 'notification_response.g.dart';

@JsonSerializable()
class NotificationModel {
  String? id;
  String? type;
  String? title;
  String? description;
  String? date;

  NotificationModel(
      {this.id, this.type, this.title, this.description, this.date});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
