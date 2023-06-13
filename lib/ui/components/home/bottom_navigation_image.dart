import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class BottomNavigationImage extends StatelessWidget {
  const BottomNavigationImage({
    Key? key,
    required this.isCurrentIndex,
    required this.image,
  }) : super(key: key);
  final bool isCurrentIndex;
  final String image;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      image,
      color: isCurrentIndex ? AppColors.blue : AppColors.grey.withOpacity(0.5),
      width: 17.5.sp,
      height: 17.5.sp,
      fit: BoxFit.fill,
    );
  }
}
