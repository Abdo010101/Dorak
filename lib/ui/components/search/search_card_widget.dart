import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class SearchCardWidget extends StatelessWidget {
  final String? name;
  final String? icon;
  final String? trailingText;
  final VoidCallback specialOnTap;
  const SearchCardWidget({
    required this.specialOnTap,
    this.name,
    this.icon,
    this.trailingText,
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: specialOnTap,
      //Navigator.pushNamed(context, NameRoutes.kSearchForCityScreen);
      child: EmptyCard(
        verticalMargin: 0.75.h,
        verticalPadding: 1.h,
        horizontalMargin: 0,
        child: Row(
          children: [
            GeometricalAvatar(
              height: 30.sp,
              width: 30.sp,
              url: icon,
            ),
            SizedBox(width: 3.w),
            TextBuilder(
              text: '$name',
              verticalPadding: 0,
              horizontalPadding: 0,
              color: AppColors.navyBlue,
            ),
            const Spacer(),
            Text(
              '$trailingText',
              style: TextStyle(fontSize: 10.sp, color: AppColors.grey),
            )
          ],
        ),
      ),
    );
  }
}
