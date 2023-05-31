import 'package:dorakpattient/data/models/response/home_response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../data/models/response/response.dart';
import '../components.dart';

class DoctorWidget extends StatelessWidget {
  const DoctorWidget({Key? key, this.home = false, this.cardOnTab, this.model})
      : super(key: key);
  final bool home;
  final VoidCallback? cardOnTab;
  final Doctor? model;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: cardOnTab,
      child: EmptyCard(
        radius: 15.0,
        verticalMargin: 0.5.h,
        horizontalMargin: 0,
        verticalPadding: 2.h,
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
                      text: '${model?.name}',
                      size: AppFontSizes.kS3,
                      color: AppColors.navyBlue,
                      horizontalPadding: 0.5.w,
                      verticalPadding: 0,
                    ),
                    Row(
                      children: [
                        RatingBarWidget(
                          initialRating: 4.5,
                          itemSize: 10.sp,
                        ),
                        TextBuilder(
                          text:
                              '${model?.rate} ( ${model?.ratingsCount} review)',
                          verticalPadding: 0,
                          horizontalPadding: 0.5.w,
                          color: AppColors.navyBlue,
                          size: AppFontSizes.kS1,
                        )
                      ],
                    )
                  ],
                ),
              ],
            ),
            TextBuilder(
              text: '${model?.bio ?? ''}',
              verticalPadding: 1.h,
              size: AppFontSizes.kS3,
              maxLin: 3,
              color: AppColors.darkGray,
            ),
            home
                ? EmptyCard(
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
                          text: "${model?.address}",
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
                          text: "Fees: ${model?.examinationPrice} LE",
                          size: AppFontSizes.kS2,
                          color: AppColors.navyBlue,
                          verticalPadding: 0,
                          horizontalPadding: 2.w,
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            home
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 9.sp,
                        color: AppColors.lightGrey2,
                      ),
                      TextBuilder(
                          text:
                              '${AppStrings.kWaitingTime.tr()} ${model?.examinationDuration} min',
                          size: AppFontSizes.kS2,
                          verticalPadding: 0,
                          horizontalPadding: 1.w,
                          color: AppColors.lightGrey2),
                      const Spacer(),
                      ButtonBuilder(
                        title: "Book",
                        width: 35.w,
                        height: 4.h,
                        titleStyle: AppStyles.kButtonTextStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                            fontSize: AppFontSizes.kS3),
                        onPressed: () {},
                      ),
                    ],
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
