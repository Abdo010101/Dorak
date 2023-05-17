import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class SwitchButton extends StatelessWidget {
  const SwitchButton(
      {Key? key,
      required this.choose,
      required this.fTitle,
      required this.sTitle,
      required this.fBOnPressed,
      required this.sBOnPressed,
      this.color})
      : super(key: key);

  final String choose;
  final String fTitle;
  final String sTitle;
  final Color? color;
  final Function() fBOnPressed;
  final Function() sBOnPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      color: color,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 45.w,
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: fBOnPressed,
              child: Text(
                fTitle.tr(),
                style: AppStyles.kSwitchButtonTextStyle.copyWith(
                  color:
                      choose == fTitle ? AppColors.blue : AppColors.lightGrey2,
                  fontSize: AppFontSizes.kS5,
                ),
              ),
            ),
          ),
          Container(
            color: AppColors.blue,
            width: 0.5.w,
            height: 2.5.h,
          ),
          SizedBox(
            width: 45.w,
            child: MaterialButton(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              enableFeedback: false,
              onPressed: sBOnPressed,
              child: Text(
                sTitle.tr(),
                style: AppStyles.kSwitchButtonTextStyle.copyWith(
                  color:
                      choose == sTitle ? AppColors.blue : AppColors.lightGrey2,
                  fontSize: AppFontSizes.kS5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
