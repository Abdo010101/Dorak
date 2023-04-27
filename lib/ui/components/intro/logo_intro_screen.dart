import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class LogoIntroScreen extends StatelessWidget {
  const LogoIntroScreen({Key? key, required this.image}) : super(key: key);

  final String image;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 0.8.h),
      margin: EdgeInsets.symmetric(
        horizontal: 1.5.w,
      ),
      color: AppColors.transparent,
      child: Image.asset(
        image,
        fit: BoxFit.fill,
      ),
    );
  }
}
