import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

/// Which CTA copy to show inside [LocationOptInSheet]:
/// - `allow`    : primary CTA requests OS permission.
/// - `settings` : primary CTA opens app settings (used when the user already
///                marked the permission "don't ask again").
enum LocationOptInVariant { allow, settings }

/// Modal bottom sheet asking the user to allow device-location access.
///
/// Returns `true` when the user tapped the primary CTA, `false` on dismiss.
/// Styled on `sign_in_required_sheet.dart` — 24 px top-radius, lock-pin icon
/// in a brand-tint circle, primary CTA with glow, secondary dismiss.
class LocationOptInSheet extends StatelessWidget {
  const LocationOptInSheet._(this.variant);
  final LocationOptInVariant variant;

  static const _accent = Color(0xFF1F8046);
  static const _accentGlow = Color(0xFF98F3B2);
  static const _accentBg50 = Color(0xFFDBFEE3);
  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);
  static const _borderNeutralSecondary = Color(0xFFD2D2D2);
  static const _scrim = Color(0x4D161616);

  static Future<bool> show(
    BuildContext context, {
    LocationOptInVariant variant = LocationOptInVariant.allow,
  }) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: _scrim,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => LocationOptInSheet._(variant),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final ctaKey = variant == LocationOptInVariant.allow
        ? 'location_opt_in_cta'
        : 'location_opt_in_settings_cta';
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: _borderNeutralSecondary,
                borderRadius: BorderRadius.circular(9999),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: _accentBg50,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.location_on_outlined,
                size: 28,
                color: _accent,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'location_opt_in_title'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'location_opt_in_body'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: _textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 48,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: _accentGlow,
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: _accent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.my_location, size: 20),
                      const SizedBox(width: 10),
                      Text(
                        ctaKey.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              style: TextButton.styleFrom(
                foregroundColor: _textSecondary,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              child: Text('location_opt_in_dismiss'.tr()),
            ),
          ],
        ),
      ),
    );
  }
}
