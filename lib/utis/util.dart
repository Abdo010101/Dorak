import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

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

  static void confirmDeletionDialog(
    BuildContext context, {
    required VoidCallback confirmTab,
    required VoidCallback cancelTab,
  }) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm deletion'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              cancelTab();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              confirmTab();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  static void unLoginedBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Please sign in to continue'),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
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
    SharePlus.instance.share(ShareParams(text: '$link'));
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
