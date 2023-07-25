import 'package:dorakpattient/utis/util.dart';
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
    bool isRated =
        model?.ratingsCount != null && model!.ratingsCount! > 0 ? true : false;
    return InkWell(
      onTap: cardOnTab,
      child: EmptyCard(
        radius: 15.0,
        verticalMargin: 0.5.h,
        horizontalMargin: 0,
        verticalPadding: 1.h,
        width: 90.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    home
                        ? GeometricalAvatar(
                            //path: AppAssets.kDoctorImage,
                            url: model?.image,
                            radius: 40.sp,
                            margin: EdgeInsetsDirectional.only(end: 2.w),
                          )
                        : FullScreenWidgetBuilder(
                            url: model!.image!,
                            radius: 35.sp,
                          ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: model?.name ?? '',
                          size: AppFontSizes.kS4,
                          color: AppColors.navyBlue,
                          horizontalPadding: 0.5.w,
                          verticalPadding: 0,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Util.isNumeric(model?.rate)
                                ? RatingBarWidget(
                                    initialRating:
                                        double.parse(model?.rate ?? '0.0'),
                                    itemSize: 12.sp,
                                  )
                                : const SizedBox(),
                            TextBuilder(
                              text: isRated
                                  ? '${model?.rate} ( ${model?.ratingsCount} ${AppStrings.kReview.tr()} )'
                                  : "${model?.rate}",
                              verticalPadding: 0,
                              horizontalPadding: 0.5.w,
                              color: AppColors.navyBlue,
                              size: AppFontSizes.kS2,
                            )
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Visibility(
                  visible: model?.isSponsored ?? false,
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppAssets.kSponsoredIcon,
                        width: 2.5.w,
                        height: 2.5.w,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 1.0.w,
                      ),
                      Text(
                        AppStrings.kSponsored.tr(),
                        style:
                            TextStyle(color: AppColors.orange, fontSize: 10.sp),
                      )
                    ],
                  ),
                )
              ],
            ),
            TextBuilder(
              height: 27.5.sp,
              text: model?.bio ?? '',
              verticalPadding: 0.5.h,
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
                    height: 20.sp,
                    color: AppColors.liteBlue2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          AppAssets.kLocationIcon,
                          width: 3.0.w,
                          height: 3.0.w,
                        ),
                        TextBuilder(
                          width: 30.w,
                          text: "${model?.address}",
                          size: AppFontSizes.kS3,
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
                        SvgPicture.asset(
                          AppAssets.kMoneyIcon,
                          width: 3.0.w,
                          height: 3.0.w,
                        ),
                        TextBuilder(
                          width: 30.w,
                          text:
                              "${double.parse(model?.examinationPrice ?? '0').toStringAsFixed(1)} ${AppStrings.kCurrency.tr()}",
                          size: AppFontSizes.kS3,
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
                              '${AppStrings.kWaitingTime.tr()} ${model?.examinationDuration ?? '--'} ${AppStrings.kMin.tr()}',
                          size: AppFontSizes.kS2,
                          verticalPadding: 0,
                          horizontalPadding: 1.w,
                          color: AppColors.lightGrey2),
                      const Spacer(),
                      ButtonBuilder(
                        title: AppStrings.kBookNow.tr(),
                        margin: EdgeInsets.symmetric(horizontal: 0.5.w),
                        width: 35.w,
                        height: 25.sp,
                        titleStyle: AppStyles.kButtonTextStyle.copyWith(
                            fontWeight: FontWeight.normal,
                            color: AppColors.white,
                            fontSize: AppFontSizes.kS3),
                        onPressed: cardOnTab,
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
