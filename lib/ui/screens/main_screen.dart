import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../routes/dorak_routes.dart';

class MainScreen extends StatelessWidget {
  MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: AppColors.white,
          actions: [
            Padding(
              padding: EdgeInsetsDirectional.only(end: 4.0.w),
              child: IconButton(
                onPressed: () {
                  // context.read<NotificationController>().getNotifications();
                  Navigator.of(context)
                      .pushNamed(NameRoutes.kNotificationScreen);
                },
                icon: SvgPicture.asset(
                  AppAssets.kNotificationIcon,
                  width: 6.0.w,
                ),
              ),
            )
          ],
          leading: Padding(
            padding: EdgeInsetsDirectional.only(start: 3.0.w),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(NameRoutes.kMenuDrawerScreen);
              },
              icon: SvgPicture.asset(
                AppAssets.kMenuIcon,
                width: 6.0.w,
              ),
            ),
          ),
          title: Text(
            '',
            // controller.homeAppBarTitles[controller.currentIndex].tr(),
            style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.black,
                fontWeight: FontWeight.bold),
          )),
      // body: controller.homeScreensList[controller.currentIndex],
      // bottomNavigationBar: BottomNavigator(),
    );
  }
}
