import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class SpecialtiesWidget extends StatelessWidget {
  const SpecialtiesWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () =>
          Navigator.pushNamed(context, NameRoutes.kSearchForCityScreen),
      child: EmptyCard(
        verticalMargin: 0.75.h,
        verticalPadding: 1.h,
        horizontalMargin: 0,
        child: Row(
          children: [
            GeometricalAvatar(
              height: 30.sp,
              width: 30.sp,
              path: AppAssets.kDoctorImage,
            ),
            SizedBox(width: 3.w),
            const TextBuilder(
              text: 'Psychiatry',
              verticalPadding: 0,
              horizontalPadding: 0,
              color: AppColors.navyBlue,
            ),
          ],
        ),
      ),
    );
  }
}
