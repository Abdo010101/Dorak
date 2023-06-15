import 'package:dorakpattient/controllers/controllers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<MainScreenController>(
        builder: (context, controller, child) {
      return WillPopScope(
        onWillPop: () async {
          print("Hello From Backkk");
          return await controller.onWillPop(context);
        },
        child: Scaffold(
          extendBody: true,
          backgroundColor: AppColors.liteWight,
          bottomNavigationBar: BottomNavigator(
            onChanged: (index) =>
                controller.onBottomSheetChanged(index, context),
            index: controller.currentIndex,
          ),
          body: controller.homeScreensList[controller.currentIndex],
        ),
      );
    });
  }
}
