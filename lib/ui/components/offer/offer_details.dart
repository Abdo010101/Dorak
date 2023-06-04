import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class OfferDetailsBottomSheet extends StatelessWidget {
  const OfferDetailsBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var editProfileController =
    // Provider.of<EditClinicController>(context, listen: true);
    return BottomSheetBuilder(
      bottomWidget: ButtonBuilder(
        radius: 0,
        buttonColor: AppColors.blue,
        title: AppStrings.kBookAppointments.tr(),
        width: 100.w,
        height: 6.5.h,
        onPressed: () async {},
      ),
      children: [
        TextBuilder(
          text: AppStrings.kClinicEdit.tr(),
          color: Colors.black,
          size: 15.sp,
          verticalPadding: 1.h,
        ),
      ],
    );
  }
}
