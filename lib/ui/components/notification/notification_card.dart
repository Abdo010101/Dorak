import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required notification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h),
      child: EmptyCard(
        height: 12.5.h,
        verticalPadding: 2.5.h,
        verticalMargin: 0.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GeometricalAvatar(
              radius: 50.sp,
              child: SvgPicture.asset(
                  // notification?.type == "reservation_cancel"
                  // ? AppAssets.kBookingCancel
                  // : notification?.type == "new_reservation"
                  //     ? AppAssets.kNewBooking
                  //     : notification?.type == "payment_complete"
                  //         ? AppAssets.kPayment
                  //         :
                  AppAssets.kCallIcon),
            ),
            SizedBox(
              width: 5.w,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.5.sp),
                  child: Text(
                    // notification?.title ??
                    '',
                    style: TextStyle(
                        fontSize: 12.5.sp, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  // notification?.description ??
                  '',
                  style: const TextStyle(color: AppColors.darkGray),
                ),
                Text(
                  // notification?.date ??
                  '',
                  style: const TextStyle(color: AppColors.darkGray),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
