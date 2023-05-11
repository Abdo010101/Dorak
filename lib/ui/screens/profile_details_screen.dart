import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leadingWidth: 40.w,
        leading: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.blue,
              ),
            ),
            TextBuilder(
              text: 'My profile',
              color: AppColors.navyBlue,
              verticalPadding: 2.h,
              bold: true,
            ),
          ],
        ),
      ),
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        color: AppColors.transparent,
        verticalPadding: 0,
        verticalMargin: 1.h,
        horizontalMargin: 4.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                EmptyCard(
                  verticalMargin: 1.h,
                  horizontalMargin: 0,
                  verticalPadding: 1.5.h,
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GeometricalAvatar(
                        path: AppAssets.kDoctorImage,
                        radius: 60.sp,
                        margin: EdgeInsets.symmetric(vertical: 1.5.h),
                      ),
                      InformationText(
                        title: AppStrings.kName.tr(),
                        subTitle: 'Full Name',
                      ),
                      InformationText(
                        title: AppStrings.kPhone.tr(),
                        subTitle: '00123456789',
                      ),
                      InformationText(
                        title: AppStrings.kEmail.tr(),
                        subTitle: 'example@mail.com',
                      ),
                      InformationText(
                        title: AppStrings.kGender.tr(),
                        subTitle: 'Male',
                        divider: false,
                      ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  end: 3.5.w,
                  top: 1.5.h,
                  child: MaterialButton(
                    minWidth: 5.w,
                    padding: EdgeInsets.zero,
                    onPressed: () {},
                    child: Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 0.25.w),
                          child: SvgPicture.asset(
                            AppAssets.kPen,
                            width: 4.w,
                          ),
                        ),
                        Text(
                          AppStrings.kEdit.tr(),
                          style: TextStyle(
                              color: AppColors.blue,
                              fontSize: AppFontSizes.kS3),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
