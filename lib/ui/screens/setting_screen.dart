import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);
  bool languageStatus = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: languageStatus
            ? AppStrings.kLanguage.tr()
            : AppStrings.kSettings.tr(),
      ),
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        horizontalMargin: 0,
        horizontalPadding: 0,
        verticalMargin: 0,
        verticalPadding: 0,
        color: AppColors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EmptyCard(
              height: 18.h,
              horizontalPadding: 6.w,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: languageStatus == true
                      ? [
                          SettingsComponents(
                            tittle: 'English',
                            type: SettingsComponentsType.check,
                            checkStatus: 'English',
                            onPressedCheck: (value) {},
                          ),
                          SettingsComponents(
                            tittle: 'عربى',
                            type: SettingsComponentsType.check,
                            checkStatus: 'عربى',
                            onPressedCheck: (value) {},
                            divider: false,
                          ),
                        ]
                      : [
                          SettingsComponents(
                            tittle: AppStrings.kLanguage.tr(),
                            type: SettingsComponentsType.arrow,
                            onPressedArrow: () {},
                          ),
                          SettingsComponents(
                            tittle: AppStrings.kNotifications.tr(),
                            type: SettingsComponentsType.switching,
                            switchingStatus: true,
                            divider: false,
                            changeSwitchingStatus: (value) => {},
                          ),
                        ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
