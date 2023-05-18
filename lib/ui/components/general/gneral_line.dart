import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class GeneralLine extends StatelessWidget {
  const GeneralLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      horizontalPadding: 0,
      verticalPadding: 0,
      verticalMargin: 0,
      horizontalMargin: 2.w,
      radius: 0,
      color: AppColors.blue,
      height: 0.5.h,
      width: 5.w,
      child: const SizedBox(),
    );
  }
}
