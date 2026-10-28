import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (actionLabel != null)
          InkWell(
            onTap: onAction,
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/home/chevron_left.svg',
                  width: 16,
                  height: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1F8046),
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox.shrink(),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D1D1D),
          ),
        ),
      ],
    );
  }
}
