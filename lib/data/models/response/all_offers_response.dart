import 'package:dorakpattient/data/models/response/offer_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'all_offers_response.g.dart';

@JsonSerializable()
class AllOffersResponse {
  List<OfferResponse>? offers;
  @JsonKey(name: 'max_price')
  String? maxPrice;
  @JsonKey(name: 'min_price')
  String? minPrice;

  AllOffersResponse({this.offers, this.maxPrice, this.minPrice});

  factory AllOffersResponse.fromJson(Map<String, dynamic> json) =>
      _$AllOffersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllOffersResponseToJson(this);
}
