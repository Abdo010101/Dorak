import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class MedicalCenterWidget extends StatelessWidget {
  const MedicalCenterWidget({Key? key, this.home = false}) : super(key: key);
  final bool home;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      radius: 15.0,
      verticalMargin: 0.5.h,
      horizontalMargin: 0,
      verticalPadding: 1.h,
      width: 90.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              GeometricalAvatar(
                path: AppAssets.kDoctorImage,
                radius: 30.sp,
                margin: EdgeInsetsDirectional.only(end: 2.w),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: 'Medical Center Name',
                    size: AppFontSizes.kS4,
                    color: AppColors.navyBlue,
                    horizontalPadding: 0.5.w,
                    bold: true,
                    verticalPadding: 0,
                  ),
                  const GeneralLine(),
                ],
              ),
            ],
          ),
          TextBuilder(
            text:
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrystandard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
            verticalPadding: 0.75.h,
            size: AppFontSizes.kS2,
            maxLin: 3,
            color: AppColors.darkGray,
          ),
          home
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.kLocationIcon,
                          color: AppColors.lightGrey2,
                        ),
                        TextBuilder(
                          width: 30.w,
                          text: "City name and area",
                          size: AppFontSizes.kS2,
                          color: AppColors.lightGrey2,
                          verticalPadding: 0,
                          horizontalPadding: 2.w,
                        ),
                      ],
                    ),
                    const Spacer(),
                    EmptyCard(
                      verticalPadding: 0,
                      verticalMargin: 0.4.h,
                      horizontalPadding: 0,
                      horizontalMargin: 0,
                      height: 22.5.sp,
                      width: 22.5.sp,
                      radius: 50,
                      color: AppColors.lightPurple,
                      child: Image.asset(AppAssets.kCallIcon),
                    ),
                  ],
                )
              : Column(
                  children: [
                    EmptyCard(
                      horizontalMargin: 0,
                      verticalMargin: 1.h,
                      verticalPadding: 0,
                      horizontalPadding: 1.5.w,
                      radius: 50,
                      width: 100.w,
                      height: 4.h,
                      color: AppColors.liteBlue2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(AppAssets.kLocationIcon),
                          TextBuilder(
                            width: 30.w,
                            text: "City name and area",
                            size: AppFontSizes.kS2,
                            color: AppColors.navyBlue,
                            verticalPadding: 0,
                            horizontalPadding: 2.w,
                          ),
                          VerticalDividerBuilder(
                            dividerColor: AppColors.white,
                            width: 0.25.w,
                            height: 3.h,
                            horizontalMargin: 2.5.w,
                          ),
                          SvgPicture.asset(AppAssets.kMoneyIcon),
                          TextBuilder(
                            width: 30.w,
                            text: "Fees: 300 LE",
                            size: AppFontSizes.kS2,
                            color: AppColors.navyBlue,
                            verticalPadding: 0,
                            horizontalPadding: 2.w,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              size: 9.sp,
                              color: AppColors.lightGrey2,
                            ),
                            TextBuilder(
                                text: '${AppStrings.kWaitingTime.tr()} 40 min',
                                size: AppFontSizes.kS2,
                                verticalPadding: 0,
                                horizontalPadding: 1.w,
                                color: AppColors.lightGrey2),
                          ],
                        ),
                        const Spacer(),
                        EmptyCard(
                          verticalPadding: 0,
                          verticalMargin: 0.4.h,
                          horizontalPadding: 0,
                          horizontalMargin: 0,
                          height: 22.5.sp,
                          width: 22.5.sp,
                          radius: 50,
                          color: AppColors.lightPurple,
                          child: Image.asset(AppAssets.kCallIcon),
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
