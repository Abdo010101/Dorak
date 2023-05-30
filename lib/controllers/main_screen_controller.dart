import 'package:dorakpattient/controllers/offers_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../ui/screens/screens.dart';

class MainScreenController extends ChangeNotifier {
  int currentIndex = 0;

  void onBottomSheetChanged(int index, BuildContext context) {
    if (context.mounted) {
      if (index == 3) {
      } else if (index == 2) {
        context.read<OffersController>().getAllOffers();
      }
    }
    currentIndex = index;
    notifyListeners();
  }

  List<Widget> homeScreensList = [
    const HomeScreen(),
    const AppointmentsScreen(),
    const OffersScreen(),
    const ProfileScreen(),
  ];
}
