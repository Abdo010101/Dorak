import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../ui/screens/screens.dart';
import 'controllers.dart';

class MainScreenController extends ChangeNotifier {
  int currentIndex = 0;

  void onBottomSheetChanged(int index, BuildContext context) {
    if (context.mounted) {
      if (index == 1) {
        context.read<AppointmentsController>().startPagingControllerListener();
      } else if (index == 2) {
        context.read<FilterController>().resetData();
        context
            .read<OffersController>()
            .startPagingControllerListener(home: true);
      } else if (index == 3) {
        context.read<PatientProfileController>().getProfileData(context);
      }
    }
    currentIndex = index;
    notifyListeners();
  }

  Future<bool> onWillPop(BuildContext context) async {
    if (currentIndex == 0) {
      return true;
    } else {
      currentIndex = 0;
      notifyListeners();
      return false;
    }
  }

  List<Widget> homeScreensList = [
    const HomeScreen(),
    const AppointmentsScreen(),
    const OffersScreen(),
    const ProfileScreen(),
  ];
}
