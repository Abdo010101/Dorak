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
          text:
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
          maxLin: 2,
          size: AppFontSizes.kS4,
          verticalPadding: 1.75.h,
        ),
        ButtonBuilder(
          title: 'go to login or register ',
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
          title: AppStrings.kCancel,
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
