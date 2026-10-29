import 'package:flutter/material.dart';

import 'booking_tokens.dart';

/// Doctor row used in the booking Screen 1 doctor picker.
/// Figma `jA3JQXye9DbBrxzNkEj9nf` nodes `177:983` / `177:997` / `177:1015`
/// (358×62). Also used as a single preselected row in variant `209:3179`.
///
/// States: available (default), selected.
class DoctorPickTile extends StatelessWidget {
  const DoctorPickTile({
    super.key,
    required this.name,
    required this.subtitle,
    required this.selected,
    this.avatarAsset,
    this.leading,
    this.onTap,
  });

  /// Convenience factory for the "any available doctor" sentinel row.
  const DoctorPickTile.anyDoctor({
    super.key,
    required this.name,
    required this.subtitle,
    required this.selected,
    this.onTap,
  })  : avatarAsset = null,
        leading = const Icon(
          Icons.groups_2_outlined,
          size: 24,
          color: BookingTokens.accent,
        );

  final String name;
  final String subtitle;
  final bool selected;
  final String? avatarAsset;
  final Widget? leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final border = selected
        ? BookingTokens.accent
        : BookingTokens.borderNeutral;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 62,
        padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
        decoration: BoxDecoration(
          color: selected ? BookingTokens.accentBg25 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            _Avatar(asset: avatarAsset, leading: leading),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: BookingTokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: BookingTokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _Check(selected: selected),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.asset, required this.leading});
  final String? asset;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: const BoxDecoration(
        color: BookingTokens.accentBg25,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      clipBehavior: Clip.antiAlias,
      child: asset != null
          ? Image.asset(
              asset!,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _fallback(),
            )
          : (leading ?? _fallback()),
    );
  }

  Widget _fallback() => const Icon(
        Icons.person,
        size: 22,
        color: BookingTokens.accent,
      );
}

class _Check extends StatelessWidget {
  const _Check({required this.selected});
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: selected ? BookingTokens.accent : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected ? BookingTokens.accent : BookingTokens.borderNeutral,
          width: 1.5,
        ),
      ),
      child: selected
          ? const Icon(Icons.check, size: 14, color: Colors.white)
          : null,
    );
  }
}
