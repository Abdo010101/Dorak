import 'package:dorakpattient/ui/screens/screens.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      extendBody: true,
      backgroundColor: AppColors.liteWight,
      bottomNavigationBar: BottomNavigator(),
      body: HomeScreen(),
    );
  }
}
