import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class ConfirmDeletion extends StatelessWidget {
  const ConfirmDeletion({
    Key? key,
    required this.confirmTab,
    required this.cancelTab,
  }) : super(key: key);
  final VoidCallback confirmTab;
  final VoidCallback cancelTab;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: EmptyCard(
        verticalPadding: 0,
        verticalMargin: 0,
        horizontalPadding: 0,
        horizontalMargin: 0,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextBuilder(text: "${AppStrings.kConfirmDeletion.tr()} "),
            Row(
              children: [
                ButtonBuilder(
                  width: 30.w,
                  title: AppStrings.kConfirm.tr(),
                  margin: EdgeInsets.symmetric(vertical: 1.h),
                  onPressed: confirmTab,
                ),
                const Spacer(),
                ButtonBuilder(
                  width: 30.w,
                  title: AppStrings.kCancel.tr(),
                  margin: EdgeInsets.symmetric(
                    vertical: 1.h,
                  ),
                  onPressed: cancelTab,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
