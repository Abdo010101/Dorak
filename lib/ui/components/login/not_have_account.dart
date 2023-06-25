import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controller/controllers.dart';
import '../../../routes/dorak_routes.dart';
import '../components.dart';

class NotHaveAccountWidget extends StatelessWidget {
  const NotHaveAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextBuilder(
          verticalPadding: 2.5.h,
          horizontalPadding: 1.w,
          text: AppStrings.kNotHaveAccount.tr(),
          size: 11.sp,
          bold: true,
          color: AppColors.darkBlue.withOpacity(0.6),
        ),
        GestureDetector(
          onTap: () {
            if (generalController.policy?.privacy == null ||
                generalController.terms?.terms == null) {
              generalController.getTermsAndPolicy();
            }
            Navigator.of(context).pushNamed(NameRoutes.kRegisterScreen);
          },
          child: TextBuilder(
            color: AppColors.blue,
            text: AppStrings.kSignUp.tr(),
            size: 11.sp,
            verticalPadding: 1.h,
            horizontalPadding: 1.w,
            bold: false,
          ),
        ),
      ],
    );
  }
}
