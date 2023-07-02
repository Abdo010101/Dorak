import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class OfferFilterBottomSheet extends StatelessWidget {
  const OfferFilterBottomSheet({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BottomSheetBuilder(
      backgroundColor: AppColors.white,
      bottomWidget: ButtonBuilder(
        radius: 25,
        buttonColor: AppColors.blue,
        title: AppStrings.kApplyFilter.tr(),
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
        width: 100.w,
        height: 6.5.h,
        onPressed: () async {},
      ),
      crossAlignment: CrossAxisAlignment.start,
      height: 112.5.h,
      children: [
        const Row(
          children: [
            TextBuilder(
              text: 'Filter by',
              color: AppColors.darkBlue,
            ),
            Spacer(),
            TextBuilder(
              text: 'Reset',
              color: AppColors.blue,
              underline: true,
            ),
          ],
        ),
        const OfferDropDown(tittle: 'Specialty'),
        const OfferDropDown(tittle: 'Sub specialty'),
        SizedBox(height: 1.h),
        const OfferItemSelection(
          tittle: 'Availability',
          items: [
            'Any day',
            'Today',
            'Tomorrow',
          ],
          itemChosen: 'Any day',
        ),
        SizedBox(height: 1.h),
        const OfferItemSelection(
          tittle: 'Gender',
          items: [
            'Male',
            'Female',
          ],
          itemChosen: 'Male',
        ),
        const OfferItemSelection(
          tittle: 'Title',
          items: [
            'Professor',
            'Professor',
            'Consultant',
            'Specialist',
          ],
          itemChosen: 'Professor',
        ),
      ],
    );
  }
}
