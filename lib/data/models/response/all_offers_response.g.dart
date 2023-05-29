// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_offers_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllOffersResponse _$AllOffersResponseFromJson(Map<String, dynamic> json) =>
    AllOffersResponse(
      offers: (json['offers'] as List<dynamic>?)
          ?.map((e) => OfferResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxPrice: json['max_price'] as String?,
      minPrice: json['min_price'] as String?,
    );

Map<String, dynamic> _$AllOffersResponseToJson(AllOffersResponse instance) =>
    <String, dynamic>{
      'offers': instance.offers,
      'max_price': instance.maxPrice,
      'min_price': instance.minPrice,
    };
