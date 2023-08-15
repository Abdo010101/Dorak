import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/controllers.dart';

class AppProviders {
  static List<DisposableProvider> getDisposableProviders(BuildContext context) {
    return [
      Provider.of<AuthController>(context, listen: false),
      Provider.of<PatientProfileController>(context, listen: false),
      Provider.of<DoctorProfileController>(context, listen: false),
      Provider.of<FilterController>(context, listen: false),
      Provider.of<OffersController>(context, listen: false),
    ];
  }

  static void disposeAllDisposableProviders(BuildContext context) {
    getDisposableProviders(context).forEach((disposableProvider) {
      disposableProvider.disposeValues();
    });
  }
}
