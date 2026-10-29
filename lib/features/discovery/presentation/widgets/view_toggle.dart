import 'package:flutter/material.dart';

/// Figma `173:731` — two-option segmented control (map/list).
enum DiscoveryView { map, list }

class ViewToggle extends StatelessWidget {
  const ViewToggle({
    super.key,
    required this.value,
    required this.onChanged,
    required this.mapLabel,
    required this.listLabel,
  });

  final DiscoveryView value;
  final ValueChanged<DiscoveryView> onChanged;
  final String mapLabel;
  final String listLabel;

  static const _accent = Color(0xFF1F8046);
  static const _bg = Color(0xFFFAFAFA);
  static const _textSecondary = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: _bg,
        border: Border.all(color: const Color(0xFFE5E5E5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Option(
              label: mapLabel,
              icon: Icons.map_outlined,
              active: value == DiscoveryView.map,
              onTap: () => onChanged(DiscoveryView.map),
            ),
          ),
          Expanded(
            child: _Option(
              label: listLabel,
              icon: Icons.menu,
              active: value == DiscoveryView.list,
              onTap: () => onChanged(DiscoveryView.list),
            ),
          ),
        ],
      ),
    );
  }
}

class _Option extends StatelessWidget {
  const _Option({
    required this.label,
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = active ? Colors.white : ViewToggle._textSecondary;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: active ? ViewToggle._accent : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: fg),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
