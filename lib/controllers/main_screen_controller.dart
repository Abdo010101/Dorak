import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'controllers.dart';

/// Legacy bottom-nav state holder. `MainShellPage` owns its own tab index,
/// so this controller only side-effects data loads on tab change and will
/// be removed when its callers migrate to BLoC in Phase 5c-l.
class MainScreenController extends ChangeNotifier {
  int currentIndex = 0;

  void onBottomSheetChanged(int index, BuildContext context) {
    if (context.mounted) {
      if (index == 1) {
        context
            .read<AppointmentsController>()
            .startPagingControllerListener(context: context);
      } else if (index == 2) {
        context.read<FilterController>().resetData();
        context
            .read<OffersController>()
            .startPagingControllerListener(home: true, context: context);
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
}
