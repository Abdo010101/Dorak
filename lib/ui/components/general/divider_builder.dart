import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DividerBuilder extends StatelessWidget {
  const DividerBuilder({
    Key? key,
    required this.dividerColor,
    this.width,
    this.thickness,
  }) : super(key: key);
  final Color dividerColor;
  final double? width;
  final double? thickness;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 20.w,
      child: Divider(
        thickness: thickness ?? 0.25.h,
        indent: 0.5.w,
        endIndent: 0.5.w,
        color: dividerColor,
      ),
    );
  }
}
