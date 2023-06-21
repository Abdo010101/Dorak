import 'package:dorakpattient/utis/util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../data/models/response/response.dart';
import '../components.dart';

class ClinicWidget extends StatelessWidget {
  const ClinicWidget({Key? key, required this.place}) : super(key: key);

  final Places? place;
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
          TextBuilder(
            text: place?.name ?? '',
            size: AppFontSizes.kS4,
            color: AppColors.navyBlue,
            horizontalPadding: 0.5.w,
            bold: true,
            verticalPadding: 0,
          ),
          const GeneralLine(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 1.5.h),
            height: 11.h,
            child: ListView.builder(
              itemCount: place?.images?.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                String? image = place?.images?[index];
                return FullScreenWidgetBuilder(
                  url: image!,
                );
              },
            ),
          ),
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
                  text: place?.shortAddress,
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
                  text:
                      "${double.parse(place?.examinationPrice ?? '0').toStringAsFixed(1)} ${AppStrings.kCurrency.tr()}",
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
                      text:
                          '${AppStrings.kWaitingTime.tr()} ${place?.examinationDuration} ${AppStrings.kMin.tr()}',
                      size: AppFontSizes.kS2,
                      verticalPadding: 0,
                      horizontalPadding: 1.w,
                      color: AppColors.lightGrey2),
                ],
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  Util.openCall(place?.phone);
                },
                child: EmptyCard(
                  verticalPadding: 0,
                  verticalMargin: 0.4.h,
                  horizontalPadding: 0,
                  horizontalMargin: 0,
                  height: 25.sp,
                  width: 25.sp,
                  radius: 50,
                  color: AppColors.green,
                  child: Image.asset(
                    AppAssets.kCallIcon,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
