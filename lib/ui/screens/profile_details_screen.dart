import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class ProfileDetailsScreen extends StatelessWidget {
  ProfileDetailsScreen({Key? key}) : super(key: key);
  bool edit = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: edit ? 'Edit my profile' : 'My profile',
      ),
      bottomNavigationBar: ButtonBuilder(
        title: AppStrings.kSaveChanges.tr(),
        onPressed: () {},
        borderColor: AppColors.blue,
        buttonColor: AppColors.blue,
        margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
      ),
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        color: AppColors.transparent,
        verticalPadding: 0,
        verticalMargin: 1.h,
        horizontalMargin: 4.w,
        child: edit
            ? EmptyCard(
                verticalMargin: 1.h,
                horizontalMargin: 0,
                verticalPadding: 1.h,
                color: AppColors.white,
                height: 45.h,
                child: Column(
                  children: [
                    GeometricalAvatar(
                      path: AppAssets.kDoctorImage,
                      radius: 60.sp,
                      margin: EdgeInsets.symmetric(vertical: 1.5.h),
                    ),
                    TextFormFieldBuilder(
                      hint: 'Full Name',
                    ),
                    TextFormFieldBuilder(
                      hint: '00123456789',
                    ),
                    TextFormFieldBuilder(
                      hint: 'example@mail.com',
                    ),
                    DropDownBuilder(
                      hint: 'Gender',
                      value: 'meal',
                      items: const ['meal', 'female'],
                      isReport: true,
                      onChanged: (value) {},
                    )
                  ],
                ),
              )
            : Stack(
                children: [
                  EmptyCard(
                    verticalMargin: 1.h,
                    horizontalMargin: 0,
                    verticalPadding: 1.h,
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
      ),
    );
  }
}
