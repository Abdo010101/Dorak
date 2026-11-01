import 'package:equatable/equatable.dart';

/// Rich center entity for Center Details screen.
class CenterEntity extends Equatable {
  const CenterEntity({
    required this.id,
    required this.name,
    required this.heroImageAsset,
    required this.address,
    required this.city,
    required this.distanceKm,
    required this.about,
    required this.specialties,
    required this.offers,
    required this.reviews,
    required this.pinLabel,
    required this.doctors,
    this.heroImageUrl,
  });

  final int id;
  final String name;
  final String heroImageAsset;

  /// Backend image URL from `MedicalCenterDetails.card.image` /
  /// `details.images.first`. When present, the UI renders this via
  /// Image.network; otherwise it falls back to [heroImageAsset].
  final String? heroImageUrl;

  final String address;
  final String city;
  final String distanceKm;
  final String about;
  final List<SpecialtyEntity> specialties;
  final List<OfferEntity> offers;
  final List<ReviewEntity> reviews;
  final String pinLabel;
  final List<DoctorAtCenter> doctors;

  @override
  List<Object?> get props => [
        id,
        name,
        heroImageAsset,
        heroImageUrl,
        address,
        city,
        distanceKm,
        about,
        specialties,
        offers,
        reviews,
        pinLabel,
        doctors,
      ];
}

class SpecialtyEntity extends Equatable {
  const SpecialtyEntity(
      {required this.key, required this.label, required this.iconData});
  final String key;
  final String label;
  final int iconData;
  @override
  List<Object?> get props => [key, label, iconData];
}

class OfferEntity extends Equatable {
  const OfferEntity({
    required this.id,
    required this.title,
    required this.centerName,
    required this.priceLabel,
    required this.imageAsset,
  });
  final int id;
  final String title;
  final String centerName;
  final String priceLabel;
  final String imageAsset;
  @override
  List<Object?> get props => [id, title, centerName, priceLabel, imageAsset];
}

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.reviewer,
    required this.body,
    required this.filledStars,
  });
  final int id;
  final String reviewer;
  final String body;
  final int filledStars;
  @override
  List<Object?> get props => [id, reviewer, body, filledStars];
}

class DoctorAtCenter extends Equatable {
  const DoctorAtCenter({
    required this.id,
    required this.name,
    required this.specialty,
    required this.specialtyKey,
    required this.ratingValue,
    required this.reviewsCount,
    this.avatarAsset,
  });
  final int id;
  final String name;
  final String specialty;
  final String specialtyKey;
  final String ratingValue;
  final String reviewsCount;
  final String? avatarAsset;
  @override
  List<Object?> get props => [
        id,
        name,
        specialty,
        specialtyKey,
        ratingValue,
        reviewsCount,
        avatarAsset
      ];
}

/// Clinic variant — one doctor, no "doctors" cta.
class ClinicEntity extends Equatable {
  const ClinicEntity({
    required this.id,
    required this.name,
    required this.heroImageAsset,
    required this.address,
    required this.city,
    required this.distanceKm,
    required this.about,
    required this.phone,
    required this.offers,
    required this.reviews,
    required this.pinLabel,
    this.heroImageUrl,
  });
  final int id;
  final String name;
  final String heroImageAsset;
  final String? heroImageUrl;
  final String address;
  final String city;
  final String distanceKm;
  final String about;
  final String phone;
  final List<OfferEntity> offers;
  final List<ReviewEntity> reviews;
  final String pinLabel;
  @override
  List<Object?> get props => [
        id,
        name,
        heroImageAsset,
        heroImageUrl,
        address,
        city,
        distanceKm,
        about,
        phone,
        offers,
        reviews,
        pinLabel,
      ];
}
