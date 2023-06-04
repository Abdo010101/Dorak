import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class DividerLogin extends StatelessWidget {
  const DividerLogin({
    Key? key,
    required this.dividerColor,
    this.height,
    this.thickness,
  }) : super(key: key);
  final Color dividerColor;
  final double? height;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 0.5.h,
      child: Divider(
        height: height ?? 0,
        thickness: thickness ?? 0.25.h,
        indent: 2.5.w,
        endIndent: 2.5.w,
        color: dividerColor,
      ),
    );
  }
}
