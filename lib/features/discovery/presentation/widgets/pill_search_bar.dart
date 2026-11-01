import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Rounded 48-pt green-bordered search pill — used in Explore, Location picker,
/// and Search results. Figma `173:685`.
class PillSearchBar extends StatelessWidget {
  const PillSearchBar({
    super.key,
    this.controller,
    this.hint,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final String? hint;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool autofocus;

  static const _accent = Color(0xFF1F8046);
  static const _hint = Color(0xFF9A9A9A);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsetsDirectional.only(start: 14, end: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _accent, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/images/home/search.svg',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: readOnly,
              autofocus: autofocus,
              onTap: onTap,
              onChanged: onChanged,
              textAlign: TextAlign.end,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1D1D1D)),
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                hintText: hint,
                hintStyle: const TextStyle(color: _hint, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
