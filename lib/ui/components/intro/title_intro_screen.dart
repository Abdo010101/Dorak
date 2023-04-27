import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class TitleIntroScreen extends StatelessWidget {
  const TitleIntroScreen({
    Key? key,
    required this.title,
  }) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(0.5.h),
      height: 5.h,
      alignment: Alignment.center,
      child: Text(
        title.tr(),
        style: AppStyles.kTitleTextStyle,
      ),
    );
  }
}
