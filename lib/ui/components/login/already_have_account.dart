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
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h, top: 2.h),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 11.sp,
            ),
            children: [
              TextSpan(
                text: AppStrings.kNotHaveAccount.tr(),
                style: const TextStyle(
                  color: AppColors.black,
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.middle,
                child: GestureDetector(
                  onTap: () {
                    // if (context.read<GeneralController>().policy?.privacy ==
                    //         null ||
                    //     context.read<GeneralController>().terms?.terms ==
                    //         null) {
                    //   context.read<GeneralController>().getTermsAndPolicy();
                    // }
                    Navigator.of(context).pushNamed(NameRoutes.kRegisterScreen);
                  },
                  child: TextBuilder(
                    color: AppColors.blue,
                    text: AppStrings.kSignUp.tr(),
                    size: AppFontSizes.kS4,
                    verticalPadding: 0,
                    horizontalPadding: 2.w,
                    bold: false,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
