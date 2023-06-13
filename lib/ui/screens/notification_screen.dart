import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(
        title: AppStrings.kNotifications.tr(),
      ),
      body: Consumer<NotificationController>(
        builder: (context, controller, child) {
          return controller.isLoading
              ? const LoadingWidget(
                  backgroundColor: AppColors.transparent,
                )
              : controller.notificationsList.isEmpty
                  ? NoDataWidget(
                      text: AppStrings.kNoNotification.tr(),
                      backgroundColor: AppColors.transparent,
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 1.5.h,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            primary: false,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.notificationsList.length,
                            itemBuilder: (context, index) {
                              return NotificationCard(
                                notification:
                                    controller.notificationsList[index],
                              );
                            },
                          ),
                        ],
                      ),
                    );
        },
      ),
    );
  }
}
