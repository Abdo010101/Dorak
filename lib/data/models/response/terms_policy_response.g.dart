// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_policy_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsPolicyResponse _$TermsPolicyResponseFromJson(Map<String, dynamic> json) =>
    TermsPolicyResponse(
      privacy: json['privacy'] as String?,
      terms: json['terms'] as String?,
    );

Map<String, dynamic> _$TermsPolicyResponseToJson(
        TermsPolicyResponse instance) =>
    <String, dynamic>{
      'terms': instance.terms,
      'privacy': instance.privacy,
    };
