import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({Key? key, this.backgroundColor, this.text})
      : super(key: key);
  final Color? backgroundColor;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      verticalPadding: 0,
      verticalMargin: 1.h,
      color: backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            text == null
                ? SvgPicture.asset(AppAssets.kNoData)
                : const SizedBox(),
            TextBuilder(
              text: text ?? 'No data found',
              color: AppColors.lightGrey2,
              size: AppFontSizes.kS5,
            ),
          ],
        ),
      ),
    );
  }
}
