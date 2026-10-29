import 'package:dorakpattient/core/router/route_names.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class OfferCard extends StatefulWidget {
  const OfferCard({
    super.key,
    required this.title,
    required this.centerName,
    required this.price,
    required this.imageAsset,
    this.centerId = 1,
  });

  final String title;
  final String centerName;
  final String price;
  final String imageAsset;
  final int centerId;

  @override
  State<OfferCard> createState() => _OfferCardState();
}

class _OfferCardState extends State<OfferCard> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (_pressed != v) setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(16);
    return AnimatedScale(
      scale: _pressed ? 0.96 : 1.0,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: Material(
      color: Colors.white,
      elevation: _pressed ? 1 : 2,
      shadowColor: const Color(0x1F000000),
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTapDown: (_) => _setPressed(true),
        onTapUp: (_) => _setPressed(false),
        onTapCancel: () => _setPressed(false),
        onTap: () {
          debugPrint('[OfferCard tap] id=${widget.centerId} → centerDetails');
          context.pushNamed(
            RouteNames.centerDetails,
            queryParameters: {'id': '${widget.centerId}'},
          );
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: const Color(0xFFE5E5E5)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 171 / 116,
                child: Image.asset(widget.imageAsset, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D1D1D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.centerName,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF4C4C4C),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBFEE3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/images/home/sar.svg',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.price,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1F8046),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5EFFF),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      width: double.infinity,
                      child: Text(
                        'offer_book_cta'.tr(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF175CD3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
