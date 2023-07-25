import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'constants.dart';

class AppStyles {
  // Style of Title of All Screens .
  static final kTitleScreenStyle = TextStyle(
    fontSize: AppFontSizes.kS5,
    fontWeight: FontWeight.bold,
  );
  static final kTitleTextStyle = TextStyle(
    fontSize: AppFontSizes.kS8,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  static final kSubtitleTextStyle = TextStyle(
    fontSize: AppFontSizes.kS6,
    fontWeight: FontWeight.normal,
    color: AppColors.gray,
  );
  static final kSwitchButtonTextStyle = TextStyle(
      fontSize: AppFontSizes.kS5,
      fontWeight: FontWeight.w400,
      color: AppColors.blue);
  static final kButtonTextStyle = TextStyle(
      fontSize: AppFontSizes.kS3,
      fontWeight: FontWeight.bold,
      color: AppColors.blue);
  // BoxDecoration Of All Cards .
  static final kCardBoxDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: AppColors.lightGrey,
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 1,
        blurRadius: 6,
        offset: const Offset(1, 2),
      ),
    ],
  );
  static final kDateTimeDecoration = InputDecoration(
    enabledBorder: const OutlineInputBorder(
      gapPadding: 0.0,
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    focusedBorder: const OutlineInputBorder(
      gapPadding: 0.0,
      borderSide: BorderSide(
        color: Colors.transparent,
      ),
    ),
    hintStyle: TextStyle(fontSize: 12.5.sp, color: AppColors.darkGray),
  );
}
