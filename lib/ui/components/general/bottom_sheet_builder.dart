import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class BottomSheetBuilder extends StatelessWidget {
  const BottomSheetBuilder(
      {Key? key,
      required this.children,
      this.crossAlignment,
      this.bottomWidget,
      this.height,
      this.radius,
      this.onPop})
      : super(key: key);

  final List<Widget> children;
  final CrossAxisAlignment? crossAlignment;
  final double? radius;
  final double? height;
  final Widget? bottomWidget;
  final Function()? onPop;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 95.h,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                child: FloatingActionButton.small(
                  backgroundColor: AppColors.white,
                  onPressed: onPop ?? () => Navigator.pop(context),
                  child: Icon(
                    Icons.close_rounded,
                    size: 20.sp,
                    color: AppColors.darkGray,
                  ),
                ),
              ),
              Container(
                decoration: AppStyles.kCardBoxDecoration.copyWith(
                    borderRadius: radius != null
                        ? BorderRadius.circular(radius ?? 25)
                        : const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                    color: AppColors.liteWight),
                height: height != null ? height! * 0.67 : 82.5.h,
                padding: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 4.w),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment:
                        crossAlignment ?? CrossAxisAlignment.center,
                    children: children,
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: bottomWidget,
      ),
    );
  }
}
