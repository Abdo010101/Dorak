import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';
import '../ui/components/components.dart';

class Util {
  static showSnackBar(BuildContext context,
      {required String? message, void Function()? onTap}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message ?? ""),
        action: onTap != null
            ? SnackBarAction(label: 'reload', onPressed: onTap)
            : null,
      ),
    );
  }

  static void confirmDeletionDialog(BuildContext context,
      {required VoidCallback confirmTab, required VoidCallback cancelTab}) {
    showDialog(
      context: context,
      builder: (context) {
        return ConfirmDeletion(
          confirmTab: confirmTab,
          cancelTab: cancelTab,
        );
      },
    );
  }

  static void unLoginedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const UnauthenticatedDialog();
      },
    );
  }

  static void unLoginedBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: AppColors.transparent,
      context: context,
      builder: (context) {
        return const LoginBottomSheet();
      },
    );
  }

  static void openCall(phone) async {
    Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'could not lunch $url';
    }
  }

  static void openWhatsapp({required String phoneNumber}) async {
    Uri url = Uri.parse("https://wa.me/$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'whatsapp no installed';
    }
  }

  static void openMap(
      {required String? latitude, required String? longitude}) async {
    Uri url = Uri.parse(
        "https:/www.google.com/maps/search/?api=1&query=$latitude,$longitude");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'google Map no installed';
    }
  }

  static bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  static Future<bool?> kToastWithMessage(var message) {
    return Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.grey,
        textColor: AppColors.white,
        fontSize: AppFontSizes.kS5);
  }

  static void shareLink(String? link) {
    Share.share('$link');
  }

  static Future<bool?> kToastUpdatedResult(UpdatedResult result) {
    return Fluttertoast.showToast(
        msg: result == UpdatedResult.success
            ? AppStrings.kDataUpdatedSuccess.tr()
            : AppStrings.kDataUpdatedFail.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.grey,
        textColor: AppColors.white,
        fontSize: AppFontSizes.kS5);
  }

  static Future<bool?> kToastAddAppointment(UpdatedResult result) {
    return Fluttertoast.showToast(
        msg: result == UpdatedResult.success
            ? AppStrings.kAddAppointmentSuccess.tr()
            : AppStrings.kAddAppointmentFail.tr(),
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.grey,
        textColor: AppColors.white,
        fontSize: AppFontSizes.kS5);
  }
}
