import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class CityWidget extends StatelessWidget {
  const CityWidget(
      {Key? key,
      required this.cityName,
      this.color,
      this.specialOnTap,
      this.bold})
      : super(key: key);
  final String cityName;
  final Color? color;
  final bool? bold;
  final VoidCallback? specialOnTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: specialOnTap,
      child: EmptyCard(
        width: 100.w,
        radius: 5,
        verticalMargin: 0.75.h,
        verticalPadding: 1.5.h,
        horizontalMargin: 0,
        child: TextBuilder(
          text: cityName,
          bold: bold ?? false,
          verticalPadding: 0,
          horizontalPadding: 0,
          size: AppFontSizes.kS3,
          color: color ?? AppColors.navyBlue,
        ),
      ),
    );
  }
}
