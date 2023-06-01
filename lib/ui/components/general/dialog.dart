import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';

import '../../../constants/constants.dart';

class Dialogue {
  static showDeleteDialog(BuildContext context) {
    Dialogs.materialDialog(
        msg: AppStrings.kSureDeletion,
        title: "Delete",
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {},
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {},
            text: 'Delete',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  static showNotificationDialog({
    required BuildContext context,
    String? mainTitle,
    String? confirmTitle,
    String? cancelTitle,
    required VoidCallback confirmTab,
    required VoidCallback cancelTab,
  }) {
    Dialogs.materialDialog(
        msg: AppStrings.kAllowNotificationsManually.tr(),
        title: mainTitle ?? AppStrings.kNoNotification.tr(),
        color: Colors.white,
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: cancelTab,
            text: cancelTitle ?? AppStrings.kCancel.tr(),
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: confirmTab,
            text: confirmTitle ?? AppStrings.kSubmit.tr(),
            iconData: null,
            color: AppColors.blue,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }
}
