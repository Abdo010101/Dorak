import 'package:dorakpattient/ui/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../routes/dorak_routes.dart';
import '../components/components.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue,
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.transparent,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 4.0.w),
            child: IconButton(
              onPressed: () {
                // context.read<NotificationController>().getNotifications();
                Navigator.of(context).pushNamed(NameRoutes.kNotificationScreen);
              },
              icon: Image.asset(
                AppAssets.kNotificationIcon,
                width: 6.0.w,
              ),
            ),
          )
        ],
        flexibleSpace: Image.asset(
          AppAssets.kMask,
          fit: BoxFit.cover,
        ),
        leading: Container(
          height: 6.h,
          padding: EdgeInsetsDirectional.only(start: 3.0.w),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(NameRoutes.kMenuDrawerScreen);
            },
            icon: Image.asset(
              AppAssets.kDorakIcon,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
      bottomNavigationBar: const BottomNavigator(),
      body: const HomeScreen(),
    );
  }
}
