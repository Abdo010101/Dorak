import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/screens/screens.dart';
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
      return Scaffold(
        extendBody: true,
        backgroundColor: AppColors.liteWight,
        bottomNavigationBar: BottomNavigator(
          onChanged: (ind) {},
          index: controller.index,
        ),
        body: HomeScreen(),
      );
    });
  }
}
