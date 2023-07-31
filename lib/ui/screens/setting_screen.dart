import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.kSettings.tr(),
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
              height: 22.h,
              horizontalPadding: 6.w,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SettingsComponents(
                    tittle: AppStrings.kLanguage.tr(),
                    type: SettingsComponentsType.arrow,
                    onPressedArrow: () => Navigator.pushNamed(
                        context, NameRoutes.kLanguageScreen),
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
          ],
        ),
      ),
    );
  }
}
