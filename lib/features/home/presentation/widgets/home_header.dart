import 'package:dorakpattient/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key, required this.greeting, required this.subtitle});

  final String greeting;
  final String subtitle;

  static const _textPrimary = Color(0xFF1D1D1D);
  static const _textSecondary = Color(0xFF4C4C4C);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _IconButton(
                asset: 'assets/images/home/notification.svg',
                onTap: () => context.goNamed(RouteNames.notification),
              ),
              const SizedBox(width: 26),
              _IconButton(
                asset: 'assets/images/home/search.svg',
                onTap: () => context.goNamed(RouteNames.searchDoctor),
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    greeting,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              SvgPicture.asset(
                'assets/images/home/dorak_mark.svg',
                width: 36,
                height: 42,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({required this.asset, required this.onTap});
  final String asset;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SvgPicture.asset(asset, width: 24, height: 24),
    );
  }
}
