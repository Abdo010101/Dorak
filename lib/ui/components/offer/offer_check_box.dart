import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class OfferCheckBox extends StatelessWidget {
  const OfferCheckBox(
      {Key? key,
      required this.onChanged,
      required this.value,
      required this.tittle,
      this.size,
      this.activeColor,
      this.checkColor})
      : super(key: key);

  final Color? activeColor;
  final Color? checkColor;
  final Function(bool?) onChanged;
  final bool value;
  final double? size;
  final String tittle;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 3.w,
        ),
        VerticalDividerBuilder(
          dividerColor: AppColors.blue,
          width: 0.35.w,
          height: 5.75.h,
        ),
        Transform.scale(
          scale: size ?? 0.5.sp,
          child: Checkbox(
            value: value,
            checkColor: Colors.white,
            activeColor: AppColors.blue,
            onChanged: onChanged,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5),
              ),
            ),
          ),
        ),
        TextBuilder(
          text: tittle.tr(),
          verticalPadding: 0,
          color: value ? AppColors.blue : AppColors.darkGray,
        ),
      ],
    );
  }
}
