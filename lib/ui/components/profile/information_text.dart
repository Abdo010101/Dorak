import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class InformationText extends StatelessWidget {
  const InformationText(
      {Key? key,
      required this.title,
      this.subTitle,
      this.divider,
      this.horizontalPadding = 0.0})
      : super(key: key);
  final String title;
  final String? subTitle;
  final bool? divider;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding!),
      child: Column(
        children: [
          Row(
            children: [
              TextBuilder(
                text: title,
                color: AppColors.darkGray,
                size: 10.sp,
                bold: false,
                verticalPadding: 1.h,
                width: 30.w,
              ),
              TextBuilder(
                text: subTitle ?? '',
                color: Colors.black,
                size: 12.5.sp,
                bold: false,
                verticalPadding: 1.h,
                horizontalPadding: 2.5.w,
                width: 52.w,
              ),
            ],
          ),
          divider == null || divider == true
              ? DividerBuilder(
                  dividerColor: AppColors.darkGray.withOpacity(0.5),
                  width: 100.w,
                  thickness: 0.1.h,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
