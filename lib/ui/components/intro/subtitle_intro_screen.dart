import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class SubtitleIntroScreen extends StatelessWidget {
  const SubtitleIntroScreen({
    Key? key,
    required this.subtitle,
  }) : super(key: key);
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.5.w),
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      height: 12.5.h,
      alignment: Alignment.center,
      child: Text(
        subtitle.tr(),
        textAlign: TextAlign.center,
        style: AppStyles.kSubtitleTextStyle,
      ),
    );
  }
}
