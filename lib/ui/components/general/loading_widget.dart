import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget(
      {Key? key,
      this.backgroundColor,
      this.horizontalPadding,
      this.verticalPadding,
      this.horizontalMargin,
      this.verticalMargin})
      : super(key: key);
  final Color? backgroundColor;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? horizontalMargin;
  final double? verticalMargin;

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      horizontalPadding: horizontalPadding,
      verticalPadding: verticalPadding,
      horizontalMargin: horizontalMargin,
      verticalMargin: verticalMargin,
      color: backgroundColor,
      height: 50.h,
      child: Center(
        child: LoadingAnimationWidget.threeArchedCircle(
          color: AppColors.blue,
          size: 50.sp,
        ),
      ),
    );
  }
}
