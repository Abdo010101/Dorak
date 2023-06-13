import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../data/models/response/response.dart';
import '../components.dart';

class Review extends StatelessWidget {
  const Review({Key? key, required this.review}) : super(key: key);

  final ReviewResponse review;

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      radius: 15.0,
      verticalMargin: 0.5.h,
      horizontalMargin: 1.5.w,
      verticalPadding: 1.3.h,
      color: AppColors.liteWight,
      width: 85.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Container(
                margin: EdgeInsets.zero,
                height: 27.sp,
                width: 27.sp,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.bLBlueWO.withOpacity(0.75),
                        AppColors.bBlue,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    color: AppColors.bBlue,
                    shape: BoxShape.circle),
                child: Center(
                  child: TextBuilder(
                    text:
                        '${review.name?.split(' ').first.split('').first}${review.name?.split(' ').last.split('').first}',
                    color: AppColors.white,
                    size: AppFontSizes.kS4,
                    bold: false,
                    verticalPadding: 0,
                    horizontalPadding: 0,
                  ),
                ),
              ),
              TextBuilder(
                text: review.name!,
                size: AppFontSizes.kS3,
                color: AppColors.navyBlue,
                horizontalPadding: 2.5.w,
                verticalPadding: 0,
              ),
              const Spacer(),
              RatingBarWidget(
                initialRating: review.rating?.toDouble(),
                itemSize: 10.sp,
              )
            ],
          ),
          review.comment == null
              ? const SizedBox()
              : TextBuilder(
                  text: "${review.comment}",
                  verticalPadding: 1.h,
                  size: AppFontSizes.kS3,
                  maxLin: 3,
                  color: AppColors.darkGray,
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextBuilder(
                  text: review.time!,
                  size: AppFontSizes.kS1,
                  verticalPadding: 0,
                  horizontalPadding: 1.w,
                  color: AppColors.lightGrey2),
              Icon(
                Icons.access_time,
                size: 9.sp,
                color: AppColors.lightGrey2,
              )
            ],
          )
        ],
      ),
    );
  }
}
