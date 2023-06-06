import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    LanguageController controller =
        Provider.of<LanguageController>(context, listen: false);
    return Scaffold(
      appBar: CustomAppBar(
        title: AppStrings.kLanguage.tr(),
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
                  children: [
                    SettingsComponents(
                      tittle: 'English',
                      type: SettingsComponentsType.check,
                      checkStatus: controller.checkStatus,
                      onPressedCheck: (value) =>
                          controller.changeCheckStatus(value, context),
                    ),
                    SettingsComponents(
                      tittle: 'عربى',
                      type: SettingsComponentsType.check,
                      checkStatus: controller.checkStatus,
                      onPressedCheck: (value) =>
                          controller.changeCheckStatus(value, context),
                      divider: false,
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
