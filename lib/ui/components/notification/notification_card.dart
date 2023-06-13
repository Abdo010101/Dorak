import 'package:dorakpattient/data/models/response/response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    Key? key,
    required this.notification,
  }) : super(key: key);
  final NotificationModel? notification;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      verticalPadding: 1.5.h,
      verticalMargin: 1.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GeometricalAvatar(
            radius: 50.sp,
            child: SvgPicture.asset(notification?.type == "booking_cancel"
                ? AppAssets.kBookingCancel
                : AppAssets.kBookingConfirm),
          ),
          SizedBox(
            width: 5.w,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 0.5.h),
                child: Text(
                  notification?.title ?? '',
                  style:
                      TextStyle(fontSize: 12.5.sp, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                notification?.description ?? '',
                style: const TextStyle(color: AppColors.darkGray),
              ),
              Text(
                notification?.date ?? '',
                style: const TextStyle(color: AppColors.darkGray),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
