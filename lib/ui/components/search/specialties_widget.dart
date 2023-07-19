import 'package:dorakpattient/data/models/response/general_response.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../../../constants/constants.dart';

class SpecialtiesWidget extends StatelessWidget {
  final Titles specialModel;
  final VoidCallback specialOnTap;
  const SpecialtiesWidget({
    required this.specialModel,
    required this.specialOnTap,
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
              height: 28.sp,
              width: 28.sp,
              url: specialModel.icon,
              radius: 0.0,
              fit: BoxFit.scaleDown,
              backgroundColor: AppColors.transparent,
            ),
            SizedBox(width: 3.w),
            TextBuilder(
              text: '${specialModel.name}',
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
