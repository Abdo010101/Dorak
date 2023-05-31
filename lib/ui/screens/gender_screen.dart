import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.transparent,
        flexibleSpace: Image.asset(
          AppAssets.kMask,
          fit: BoxFit.cover,
        ),
        leading: const SizedBox(),
      ),
      backgroundColor: AppColors.blue,
      body: EmptyCard(
        horizontalMargin: 0,
        verticalMargin: 0,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
        color: AppColors.liteWight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBuilder(
              text: 'Which one are you?',
              color: AppColors.navyBlue,
              size: AppFontSizes.kS5,
              verticalPadding: 1.h,
            ),
            TextBuilder(
              text: 'To give you a cusomize experience.',
              verticalPadding: 1.h,
            ),
            const TextBuilder(
              text: 'We need to know your gender.',
              verticalPadding: 0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                EmptyCard(
                  verticalPadding: 2.h,
                  horizontalMargin: 3.w,
                  horizontalPadding: 7.5.w,
                  child: Column(
                    children: [
                      SvgPicture.asset(AppAssets.kMaleIcon),
                      TextBuilder(
                        text: AppStrings.kGenderList[1].tr(),
                        color: AppColors.navyBlue,
                        verticalPadding: 1.5.h,
                      ),
                    ],
                  ),
                ),
                EmptyCard(
                  verticalPadding: 2.h,
                  horizontalMargin: 3.w,
                  horizontalPadding: 7.5.w,
                  child: Column(
                    children: [
                      SvgPicture.asset(AppAssets.kMaleIcon),
                      TextBuilder(
                        text: AppStrings.kGenderList[0].tr(),
                        color: AppColors.navyBlue,
                        verticalPadding: 1.5.h,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            ButtonBuilder(
              title: 'Continue',
              margin: EdgeInsets.symmetric(vertical: 2.5.h),
              borderColor: AppColors.transparent,
              onPressed: () {},
            ),
            ButtonBuilder(
              title: AppStrings.kSkip.tr(),
              titleColor: AppColors.red,
              buttonColor: AppColors.red.withOpacity(0.15),
              borderColor: AppColors.transparent,
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
