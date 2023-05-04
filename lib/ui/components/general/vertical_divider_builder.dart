import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class VerticalDividerBuilder extends StatelessWidget {
  const VerticalDividerBuilder({
    super.key,
    required this.dividerColor,
    this.width,
    this.height,
    this.horizontalMargin,
  });
  final double? width;
  final double? height;
  final Color dividerColor;
  final double? horizontalMargin;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalMargin ?? 0),
      width: width ?? 0.5.w,
      height: height ?? 4.h,
      child: VerticalDivider(
        thickness: width ?? 0.5.w,
        color: dividerColor,
      ),
    );
  }
}
