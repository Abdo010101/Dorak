import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class SectionLabel extends StatelessWidget {
  const SectionLabel(
      {Key? key,
      required this.title,
      required this.seeAllPressed,
      this.horizontalPadding,
      this.verticalPadding})
      : super(key: key);
  final String title;
  final Function()? seeAllPressed;
  final double? horizontalPadding;
  final double? verticalPadding;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 5.h,
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0, vertical: verticalPadding ?? 0),
      child: Row(
        children: [
          TextBuilder(
            text: title,
            color: AppColors.navyBlue,
            size: AppFontSizes.kS5,
            verticalPadding: 0.h,
            bold: true,
          ),
          const Spacer(),
          TextButton(
            onPressed: seeAllPressed,
            child: TextBuilder(
              text: AppStrings.kSeeAll.tr(),
              size: AppFontSizes.kS4,
              verticalPadding: 0,
            ),
          ),
        ],
      ),
    );
  }
}
