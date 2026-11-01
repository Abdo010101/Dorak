import 'package:flutter/material.dart';

import '../../../data/models/response/centers_response.dart';
import '../domain/entities/center_entity.dart';

/// Adapts `MedicalCenterDetails` (and the card list variant) to the UI's
/// [CenterEntity] / [ClinicEntity] types. The UI still renders assets, so
/// `heroImageAsset` falls back to the Figma mock asset when the backend
/// returns a URL — a Round 5 ticket switches the top image to Image.network.
class CenterEntityMapper {
  const CenterEntityMapper._();

  static CenterEntity fromDetails(MedicalCenterDetails d) {
    final card = d.card;
    final imageUrl = card?.image ??
        (d.images != null && d.images!.isNotEmpty ? d.images!.first : null);
    return CenterEntity(
      id: card?.id ?? 0,
      name: card?.name ?? '',
      heroImageAsset: 'assets/images/home/center1.png',
      heroImageUrl: imageUrl,
      address: card?.address ?? [card?.city, card?.area].whereType<String>().join(' · '),
      city: card?.city ?? '',
      distanceKm: card?.distanceKm?.toStringAsFixed(1) ?? '',
      about: d.description ?? '',
      specialties: (d.specializations ?? const <CenterSpecialization>[])
          .map((s) => SpecialtyEntity(
                key: (s.id ?? 0).toString(),
                label: s.name ?? '',
                iconData: Icons.local_hospital_outlined.codePoint,
              ))
          .toList(),
      offers: (d.offers ?? const <CenterOffer>[])
          .map((o) => OfferEntity(
                id: o.id ?? 0,
                title: o.title ?? '',
                centerName: card?.name ?? '',
                priceLabel: o.priceAfter ?? o.priceBefore ?? '',
                imageAsset: 'assets/images/home/offer1.png',
              ))
          .toList(),
      reviews: (d.ratings?.data ?? const <CenterRatingRow>[])
          .map((r) => ReviewEntity(
                id: r.id ?? 0,
                reviewer: r.name ?? '',
                body: r.comment ?? '',
                filledStars: (r.rating ?? 0).round(),
              ))
          .toList(),
      pinLabel:
          [card?.area, card?.city].whereType<String>().join(' · '),
      doctors: const <DoctorAtCenter>[],
    );
  }

  static ClinicEntity clinicFromDetails(MedicalCenterDetails d) {
    final card = d.card;
    final imageUrl = card?.image ??
        (d.images != null && d.images!.isNotEmpty ? d.images!.first : null);
    return ClinicEntity(
      id: card?.id ?? 0,
      name: card?.name ?? '',
      heroImageAsset: 'assets/images/home/center1.png',
      heroImageUrl: imageUrl,
      address: card?.address ?? '',
      city: card?.city ?? '',
      distanceKm: card?.distanceKm?.toStringAsFixed(1) ?? '',
      about: d.description ?? '',
      phone: card?.phone ?? '',
      offers: (d.offers ?? const <CenterOffer>[])
          .map((o) => OfferEntity(
                id: o.id ?? 0,
                title: o.title ?? '',
                centerName: card?.name ?? '',
                priceLabel: o.priceAfter ?? o.priceBefore ?? '',
                imageAsset: 'assets/images/home/offer1.png',
              ))
          .toList(),
      reviews: (d.ratings?.data ?? const <CenterRatingRow>[])
          .map((r) => ReviewEntity(
                id: r.id ?? 0,
                reviewer: r.name ?? '',
                body: r.comment ?? '',
                filledStars: (r.rating ?? 0).round(),
              ))
          .toList(),
      pinLabel:
          [card?.area, card?.city].whereType<String>().join(' · '),
    );
  }

  static List<DoctorAtCenter> fromDoctorsResponse(DoctorsAtCenterResponse r) {
    return (r.doctors ?? const <DoctorCard>[])
        .map((d) => DoctorAtCenter(
              id: d.id ?? 0,
              name: d.name ?? '',
              specialty: d.specialization ?? d.headline ?? '',
              specialtyKey: '',
              ratingValue: d.rating ?? '',
              reviewsCount: (d.ratingsCount ?? 0).toString(),
              avatarAsset: null,
            ))
        .toList();
  }
}
