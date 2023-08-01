import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../routes/dorak_routes.dart';
import '../components.dart';

class UnauthenticatedDialog extends StatelessWidget {
  const UnauthenticatedDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: TextBuilder(
        text: AppStrings.kUnauthenticatedTitle.tr(),
        color: AppColors.darkBlue,
        size: AppFontSizes.kS4,
        verticalPadding: 0,
        bold: true,
      ),
      content: EmptyCard(
        verticalPadding: 0,
        verticalMargin: 0,
        horizontalPadding: 0,
        horizontalMargin: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextBuilder(
              text: AppStrings.kUnauthenticatedSubtitle.tr(),
              maxLin: 2,
            ),
            ButtonBuilder(
              title: 'go to login or register ',
              width: 55.w,
              titleStyle: AppStyles.kButtonTextStyle.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.white,
                  fontSize: AppFontSizes.kS4),
              onPressed: () => Navigator.pushReplacementNamed(
                  context, NameRoutes.kWelcomeScreen),
            ),
            SizedBox(
              height: 2.5.h,
            ),
            ButtonBuilder(
              title: AppStrings.kCancel,
              buttonColor: AppColors.red,
              borderColor: AppColors.transparent,
              width: 55.w,
              titleStyle: AppStyles.kButtonTextStyle.copyWith(
                  fontWeight: FontWeight.normal,
                  color: AppColors.white,
                  fontSize: AppFontSizes.kS4),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
