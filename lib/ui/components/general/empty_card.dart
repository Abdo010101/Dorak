import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class EmptyCard extends StatelessWidget {
  const EmptyCard({
    Key? key,
    required this.child,
    this.width,
    this.height,
    this.radius,
    this.verticalPadding,
    this.verticalMargin,
    this.horizontalMargin,
    this.color,
    this.horizontalPadding,
    this.url,
  }) : super(key: key);

  final Widget child;
  final double? width;
  final double? height;
  final double? radius;
  final double? verticalPadding;

  final double? horizontalPadding;
  final double? verticalMargin;
  final double? horizontalMargin;
  final Color? color;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: horizontalMargin ?? 5.w,
          vertical: verticalMargin ?? 2.5.h),
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 4.w,
          vertical: verticalPadding ?? 3.h),
      width: width,
      height: height,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 12.5),
          color: color ?? AppColors.white,
          image: url == null
              ? null
              : DecorationImage(
                  image: NetworkImage(
                    url!,
                  ),
                  fit: BoxFit.cover,
                )),
      child: child,
    );
  }
}
