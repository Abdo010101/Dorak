import 'package:json_annotation/json_annotation.dart';

part 'base_response_list.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class BaseResponseList<T> {
  List<T>? data;
  BaseResponseList({
    this.data,
  });

  factory BaseResponseList.fromJson(
          Map<String, dynamic> json, T Function(Object? json) fromJsonT) =>
      _$BaseResponseListFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$BaseResponseListToJson(this, toJsonT);

  @override
  String toString() {
    return 'BaseResponseList{ data: $data}';
  }
}
