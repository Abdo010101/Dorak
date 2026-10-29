import 'package:flutter/material.dart';

import '../../domain/entities/center_entity.dart';

/// Static mock data mirroring Figma `175:861`, `204:1933`, `433:11943`.
/// Replace once backend `getMedicalCenters` endpoint is live.
class CenterMock {
  const CenterMock._();

  static CenterEntity sample() => CenterEntity(
        id: 1,
        name: 'مجمع النور الطبي',
        heroImageAsset: 'assets/images/home/center1.png',
        address: 'الدمام · حي الفيصلية',
        city: 'الدمام',
        distanceKm: '٢٫٤',
        about: 'رعاية طبية متكاملة لك ولعائلتك، في مكان واحد.',
        specialties: const [
          SpecialtyEntity(
              key: 'kids', label: 'اطفال', iconData: 0xe88a /* child_care */),
          SpecialtyEntity(
              key: 'dental',
              label: 'الأسنان',
              iconData: 0xe566 /* medical_services */),
        ],
        offers: const [
          OfferEntity(
            id: 10,
            title: 'تنظيف الأسنان',
            centerName: 'مجمع النور الطبي',
            priceLabel: '١٩٩',
            imageAsset: 'assets/images/home/offer1.png',
          ),
          OfferEntity(
            id: 11,
            title: 'تنظيف الأسنان',
            centerName: 'مجمع النور الطبي',
            priceLabel: '١٩٩',
            imageAsset: 'assets/images/home/offer1.png',
          ),
        ],
        reviews: const [
          ReviewEntity(
            id: 1,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
          ReviewEntity(
            id: 2,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
          ReviewEntity(
            id: 3,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
          ReviewEntity(
            id: 4,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
          ReviewEntity(
            id: 5,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
        ],
        pinLabel: 'حي الفيصلية · الدمام',
        doctors: const [
          DoctorAtCenter(
            id: 1,
            name: 'د. أحمد العلي',
            specialty: 'استشاري طب الأسنان',
            specialtyKey: 'dental',
            ratingValue: '٤٫٨',
            reviewsCount: '٢١٠',
            avatarAsset: 'assets/images/doctor/avatar.png',
          ),
          DoctorAtCenter(
            id: 2,
            name: 'د. سارة الحسن',
            specialty: 'أخصائية طب الأسنان',
            specialtyKey: 'dental',
            ratingValue: '٤٫٧',
            reviewsCount: '٩٨',
            avatarAsset: 'assets/images/doctor/avatar.png',
          ),
          DoctorAtCenter(
            id: 3,
            name: 'د. منى الزهراني',
            specialty: 'استشارية طب الأطفال',
            specialtyKey: 'kids',
            ratingValue: '٤٫٩',
            reviewsCount: '١٥٤',
          ),
        ],
      );

  static ClinicEntity sampleClinic() => ClinicEntity(
        id: 100,
        name: 'عيادة النور',
        heroImageAsset: 'assets/images/home/center1.png',
        address: 'الدمام · حي الفيصلية',
        city: 'الدمام',
        distanceKm: '٢٫٤',
        about: 'رعاية طبية متكاملة لك ولعائلتك، في مكان واحد.',
        phone: '0500000000',
        offers: const [
          OfferEntity(
            id: 20,
            title: 'تنظيف الأسنان',
            centerName: 'عيادة النور',
            priceLabel: '١٩٩',
            imageAsset: 'assets/images/home/offer1.png',
          ),
          OfferEntity(
            id: 21,
            title: 'تنظيف الأسنان',
            centerName: 'عيادة النور',
            priceLabel: '١٩٩',
            imageAsset: 'assets/images/home/offer1.png',
          ),
        ],
        reviews: const [
          ReviewEntity(
            id: 1,
            reviewer: 'أحمد العلي',
            body:
                'استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان استشاري طب الأسنان',
            filledStars: 2,
          ),
        ],
        pinLabel: 'حي الفيصلية · الدمام',
      );

  static List<String> specialtyFilterKeys = const ['all', 'dental', 'kids'];
  static Map<String, String> specialtyLabels = {
    'all': 'الكل',
    'dental': 'طب الأسنان',
    'kids': 'طب الأطفال',
  };

  static IconData iconFor(String key) {
    switch (key) {
      case 'kids':
        return Icons.sentiment_satisfied_alt_outlined;
      case 'dental':
        return Icons.medical_services_outlined;
      default:
        return Icons.local_hospital_outlined;
    }
  }
}
