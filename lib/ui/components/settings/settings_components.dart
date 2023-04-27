import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class SettingsComponents extends StatelessWidget {
  const SettingsComponents({
    Key? key,
    required this.tittle,
    this.divider,
    required this.type,
    this.changeSwitchingStatus,
    this.switchingStatus,
    this.onPressedArrow,
    this.checkStatus,
    this.onPressedCheck,
  }) : super(key: key);
  final String tittle;
  final bool? divider;
  final bool? switchingStatus;
  final Function(bool)? changeSwitchingStatus;
  final VoidCallback? onPressedArrow;
  final String? checkStatus;
  final Function(String)? onPressedCheck;
  final SettingsComponentsType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: type == SettingsComponentsType.check
              ? () => onPressedCheck!(tittle)
              : type == SettingsComponentsType.arrow
                  ? onPressedArrow
                  : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextBuilder(
                width: 50.w,
                text: tittle,
                color: AppColors.navyBlue,
                size: AppFontSizes.kS5,
                bold: false,
                verticalPadding: 1.h,
              ),
              type == SettingsComponentsType.arrow
                  ? Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.darkGray.withOpacity(0.5),
                    )
                  : type == SettingsComponentsType.switching
                      ? Row(
                          children: [
                            TextBuilder(
                              text: AppStrings.kEnabled.tr(),
                              size: AppFontSizes.kS3,
                              color: AppColors.darkGray.withOpacity(0.5),
                              bold: false,
                              horizontalPadding: 0,
                              verticalPadding: 0,
                            ),
                            Switch(
                              activeColor: Colors.white,
                              activeTrackColor: AppColors.green,
                              value: switchingStatus!,
                              onChanged: changeSwitchingStatus,
                            ),
                          ],
                        )
                      : type == SettingsComponentsType.check
                          ? Icon(
                              tittle == checkStatus
                                  ? Icons.check_rounded
                                  : null,
                              size: 17.5.sp,
                              color: AppColors.green,
                            )
                          : const SizedBox(),
            ],
          ),
        ),
        divider == null
            ? DividerBuilder(
                dividerColor: AppColors.darkGray.withOpacity(0.25),
                thickness: 0.2.h,
                width: 65.w,
              )
            : const SizedBox(),
      ],
    );
  }
}
