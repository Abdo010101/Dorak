import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class TextBuilder extends StatelessWidget {
  const TextBuilder(
      {Key? key,
      required this.text,
      this.verticalPadding,
      this.horizontalPadding,
      this.color,
      this.maxLin,
      this.size,
      this.bold = false,
      this.width,
      this.align,
      this.underline,
      this.height})
      : super(key: key);
  final double? verticalPadding;
  final double? horizontalPadding;
  final String? text;
  final Color? color;
  final double? size;
  final int? maxLin;
  final bool bold;
  final double? width;
  final TextAlign? align;
  final bool? underline;
  final double? height;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding ?? 2.5.h,
          horizontal: horizontalPadding ?? 0),
      child: Text(
        maxLines: maxLin ?? 1,
        '$text',
        textAlign: align,
        style: AppStyles.kButtonTextStyle.copyWith(
            fontFamily: 'Tajawal',
            decoration: underline == true
                ? TextDecoration.underline
                : underline == false
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
            // height: textHeight ?? 1,
            overflow: TextOverflow.clip,
            color: color ?? AppColors.darkGray,
            fontSize: size ?? 12.5.sp,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }
}
