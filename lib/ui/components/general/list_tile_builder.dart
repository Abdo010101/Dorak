import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class ListTileBuilder extends StatelessWidget {
  const ListTileBuilder({
    Key? key,
    this.child,
    this.width,
    this.height,
    this.radius,
    this.verticalPadding,
    this.verticalMargin,
    required this.title,
    required this.subTitle,
    this.trailing,
    this.onTap,
    this.url,
    this.horizontalPadding,
    this.horizontalMargin,
  }) : super(key: key);

  final Widget? child;
  final double? width;
  final double? height;
  final double? radius;
  final double? verticalPadding;
  final double? horizontalPadding;
  final double? horizontalMargin;
  final double? verticalMargin;
  final String title;
  final String subTitle;
  final String? trailing;
  final VoidCallback? onTap;
  final String? url;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: horizontalMargin ?? 5.w,
            vertical: verticalMargin ?? 1.5.h),
        padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 4.w,
            vertical: verticalPadding ?? 2.h),
        width: width,
        height: height,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 12.5),
            color: AppColors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GeometricalAvatar(
                      radius: 47.5.sp,
                      url: url,
                      child: const SizedBox(),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: title,
                          color: AppColors.blue,
                          verticalPadding: 0,
                          size: 12.5.sp,
                        ),
                        TextBuilder(
                          text: subTitle,
                          color: AppColors.darkGray,
                          size: 10.sp,
                          verticalPadding: 1.h,
                        ),
                        TextBuilder(
                          text: trailing ?? '',
                          size: 10.sp,
                          color: AppColors.darkGray,
                          verticalPadding: 0,
                        ),
                      ],
                    ),
                  ],
                ),

                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.sp,
                  color: AppColors.blue,
                )
                // SvgPicture.asset(AppAssets.kThrowArrow),
              ],
            ),
            child ?? const SizedBox()
          ],
        ),
      ),
    );
  }
}
