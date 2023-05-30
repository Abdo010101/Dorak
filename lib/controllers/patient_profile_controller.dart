import 'package:dorakpattient/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';

class PatientProfileController extends DisposableProvider {
  bool isLoading = false;

  bool edit = false;
  changeToEdit() {
    edit = !edit;
    notifyListeners();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}
