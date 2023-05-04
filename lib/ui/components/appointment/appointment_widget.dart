import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      horizontalMargin: 0,
      verticalMargin: 1.h,
      verticalPadding: 2.h,
      color: AppColors.white,
      child: Column(
        children: [
          EmptyCard(
            horizontalMargin: 0,
            verticalMargin: 0,
            verticalPadding: 1.h,
            horizontalPadding: 2.w,
            height: 10.h,
            color: AppColors.liteWight2,
            child: Row(
              children: [
                Container(
                  height: 50.sp,
                  width: 50.sp,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.bGreen.withOpacity(0.75),
                          AppColors.bGreen,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle),
                  padding: EdgeInsets.all(10.sp),
                  child: Center(
                    child: Text(
                      '20 \n May',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.white, fontSize: 11.sp),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextBuilder(
                      text: 'ENT Specialist',
                      verticalPadding: 1.h,
                      horizontalPadding: 2.w,
                      color: AppColors.navyBlue,
                    ),
                    TextBuilder(
                      text: '20 April, 2021 , 12:30 PM',
                      verticalPadding: 0,
                      horizontalPadding: 2.w,
                      size: AppFontSizes.kS3,
                    )
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 1.5.h,
          ),
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
                    text: 'Dr. Doctor Name',
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
                        text: '4.5',
                        verticalPadding: 0,
                        horizontalPadding: 0.5.w,
                        color: AppColors.navyBlue,
                        size: AppFontSizes.kS1,
                      )
                    ],
                  )
                ],
              ),
              const Spacer(),
              EmptyCard(
                verticalPadding: 0,
                verticalMargin: 0,
                horizontalPadding: 0,
                horizontalMargin: 0,
                height: 30.sp,
                width: 30.sp,
                radius: 50,
                color: AppColors.lightPurple,
                child: Image.asset(AppAssets.kCallIcon),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
