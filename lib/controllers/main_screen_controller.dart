import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../constants/constants.dart';
import '../ui/screens/screens.dart';
import 'controllers.dart';

class MainScreenController extends ChangeNotifier {
  int currentIndex = 0;

  void onBottomSheetChanged(int index, BuildContext context) {
    if (context.mounted) {
      if (index == 1) {
        context
            .read<AppointmentsController>()
            .changeAppointmentDate(AppStrings.kUpcoming);
      } else if (index == 2) {
        context.read<OffersController>().getAllOffers(home: true);
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
