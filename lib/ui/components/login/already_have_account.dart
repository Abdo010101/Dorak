import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../routes/dorak_routes.dart';
import '../components.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  const AlreadyHaveAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextBuilder(
          verticalPadding: 2.5.h,
          horizontalPadding: 1.w,
          text: AppStrings.kHaveAccount.tr(),
          size: 11.sp,
          bold: true,
          color: AppColors.darkBlue.withOpacity(0.6),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(NameRoutes.kLoginScreen),
          child: TextBuilder(
            verticalPadding: 1.h,
            horizontalPadding: 2.w,
            text: AppStrings.kSignIn.tr(),
            size: 11.sp,
            color: AppColors.blue,
          ),
        ),
      ],
    );
  }
}
