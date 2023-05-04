import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class BottomNavigationImage extends StatelessWidget {
  const BottomNavigationImage({
    Key? key,
    required this.isCurrentIndex,
    required this.image,
    required this.imageType,
  }) : super(key: key);
  final bool isCurrentIndex;
  final ImageType imageType;
  final String image;

  @override
  Widget build(BuildContext context) {
    return imageType == ImageType.svg
        ? SvgPicture.asset(
            image,
            color: isCurrentIndex
                ? AppColors.blue
                : AppColors.grey.withOpacity(0.5),
            width: 25.sp,
            height: 25.sp,
            fit: BoxFit.fill,
          )
        : Image.asset(
            image,
            color: isCurrentIndex ? AppColors.blue : AppColors.grey,
            width: 22.sp,
            height: 22.sp,
            fit: BoxFit.fill,
          );
  }
}
