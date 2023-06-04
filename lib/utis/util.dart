import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/constants.dart';

class Util {
  static showSnackBar(BuildContext context, {required String? message}) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message ?? "")));
  }

  // static void pickImageBottomSheet(BuildContext context,
  //     {required VoidCallback pickCameraTab,
  //     required VoidCallback pickGalleryTab}) {
  //   showModalBottomSheet(
  //       context: context,
  //       backgroundColor: Colors.transparent,
  //       isScrollControlled: true,
  //       builder: (context) {
  //         return PickImageBSBuilder(
  //           pickCameraTab: pickCameraTab,
  //           pickGalleryTab: pickGalleryTab,
  //         );
  //       });
  // }

  // static void confirmDeletionDialog(BuildContext context,
  //     {required VoidCallback confirmTab, required VoidCallback cancelTab}) {
  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return ConfirmDeletion(
  //         confirmTab: confirmTab,
  //         cancelTab: cancelTab,
  //       );
  //     },
  //   );
  // }

  static void openCall(phone) async {
    Uri url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'could not lunch $url';
    }
  }

  static void openWhatsapp(
      {required BuildContext context, required String phoneNumber}) async {
    String whatsappURl = "https://wa.me/$phoneNumber";

    ///TODO edit deprected here ...
    if (await canLaunch(whatsappURl)) {
      await launch(whatsappURl);
    } else {
      throw 'whatsapp no installed';
    }
  }

  static bool isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  static Future<bool?> kToastLoginMessage(var message) {
    return Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.grey,
        textColor: AppColors.white,
        fontSize: AppFontSizes.kS5);
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
}
