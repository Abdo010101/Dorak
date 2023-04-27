import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.liteWight,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            AppStrings.kNotifications.tr(),
            style: const TextStyle(color: AppColors.navyBlue),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body:
            // Consumer<NotificationController>(
            //   builder: (context, controller, child) {
            //     return controller.isLoading
            true
                ? const LoadingWidget(
                    backgroundColor: AppColors.transparent,
                  )
                : true
                    ? NoDataWidget(
                        text: AppStrings.kNoNotification.tr(),
                        backgroundColor: AppColors.transparent,
                      )
                    : SizedBox()
        // ListView.builder(
        //                   shrinkWrap: true,
        //                   primary: false,
        //                   physics: const NeverScrollableScrollPhysics(),
        //                   itemCount: controller.notificationsList.length,
        //                   itemBuilder: (context, index) {
        //                     return NotificationCard(
        //                       notification: controller.notificationsList[index],
        //                     );
        //                   },
        //                 );

        );
  }
}
