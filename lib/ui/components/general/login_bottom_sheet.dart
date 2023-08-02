import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../routes/dorak_routes.dart';
import '../components.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomSheetBuilder(
      backgroundColor: AppColors.white,
      crossAlignment: CrossAxisAlignment.center,
      height: 35.h,
      containerHeight: 30.h,
      children: [
        SizedBox(height: 1.h),
        TextBuilder(
          text: AppStrings.kUnauthenticatedTitle.tr(),
          color: AppColors.darkBlue,
          bold: true,
          size: AppFontSizes.kS5,
          verticalPadding: 0,
        ),
        TextBuilder(
          text: AppStrings.kPleaseLogin.tr(),
          maxLin: 2,
          size: AppFontSizes.kS4,
          verticalPadding: 1.75.h,
        ),
        ButtonBuilder(
          title: AppStrings.kLogin.tr(),
          height: 5.h,
          width: 70.w,
          titleStyle: AppStyles.kButtonTextStyle.copyWith(
              fontWeight: FontWeight.normal,
              color: AppColors.white,
              fontSize: AppFontSizes.kS4),
          onPressed: () => Navigator.pushReplacementNamed(
              context, NameRoutes.kWelcomeScreen),
        ),
        ButtonBuilder(
          title: AppStrings.kCancel.tr(),
          buttonColor: AppColors.transparent,
          borderColor: AppColors.transparent,
          titleStyle: AppStyles.kButtonTextStyle.copyWith(
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.normal,
              color: AppColors.red,
              fontSize: AppFontSizes.kS4),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
