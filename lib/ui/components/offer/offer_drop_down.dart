import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class OfferDropDown extends StatelessWidget {
  const OfferDropDown({
    Key? key,
    required this.tittle,
    this.onPressed,
  }) : super(key: key);
  final String tittle;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed,
          child: Row(
            children: [
              SizedBox(
                width: 2.5.w,
              ),
              TextBuilder(
                width: 50.w,
                text: tittle,
                color: AppColors.navyBlue,
                size: AppFontSizes.kS5,
                bold: false,
                verticalPadding: 1.h,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.darkGray.withOpacity(0.75),
              ),
              SizedBox(
                width: 2.5.w,
              ),
            ],
          ),
        ),
        DividerBuilder(
          dividerColor: AppColors.darkGray.withOpacity(0.45),
          thickness: 0.15.h,
          width: 85.w,
        ),
      ],
    );
  }
}
