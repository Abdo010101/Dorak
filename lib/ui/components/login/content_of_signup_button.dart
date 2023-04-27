import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class ContentOfSignUpButton extends StatelessWidget {
  const ContentOfSignUpButton({
    Key? key,
    required this.boldText,
    required this.normalText,
    required this.icon,
    required this.textColor,
  }) : super(key: key);

  final String boldText;
  final String normalText;
  final String icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(
          normalText,
          style: AppStyles.kButtonTextStyle
              .copyWith(color: textColor, fontWeight: FontWeight.normal),
        ),
        SizedBox(
          width: 1.5.w,
        ),
        Text(
          boldText,
          style: AppStyles.kButtonTextStyle.copyWith(
            color: textColor,
          ),
        ),
        SizedBox(
          width: 2.w,
        ),
        icon != ''
            ? SvgPicture.asset(
                icon,
                color: AppColors.blue,
                height: 2.5.h,
              )
            : const SizedBox(),
      ],
    );
  }
}
