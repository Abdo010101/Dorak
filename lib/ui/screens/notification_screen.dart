import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../data/models/response/response.dart';
import '../components/components.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    NotificationController controller =
        Provider.of<NotificationController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(
        title: AppStrings.kNotifications.tr(),
      ),
      body: PagedListView<int, NotificationModel>(
        padding: EdgeInsets.zero,
        pagingController: controller.pagingController!,
        builderDelegate: PagedChildBuilderDelegate<NotificationModel>(
          noItemsFoundIndicatorBuilder: (BuildContext context) {
            return NoDataWidget(
              text: AppStrings.kNoNotification.tr(),
              backgroundColor: Colors.transparent,
            );
          },
          firstPageProgressIndicatorBuilder: (BuildContext context) {
            return const LoadingWidget(
              backgroundColor: AppColors.transparent,
            );
          },
          itemBuilder: (context, item, index) {
            return NotificationCard(
              notification: item,
            );
          },
        ),
      ),
    );
  }
}
