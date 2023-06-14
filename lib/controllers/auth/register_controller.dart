import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../constants/enums.dart';
import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';

class RegisterController extends AuthController {
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formRegisterKey = GlobalKey<FormState>();
  bool agreeTermsCondition = false;
  bool showConfPass = true;
  bool showPass = true;
  String? gender;

  void choseGender(String value) {
    gender = value;
    notifyListeners();
  }

  void onChangeTermsCondition(bool? value) {
    agreeTermsCondition = value!;
    notifyListeners();
  }

  void changeShowConfPass() {
    showConfPass = !showConfPass;
    notifyListeners();
  }

  void changeShowPass() {
    showPass = !showPass;
    notifyListeners();
  }

  Future<bool> signUp(BuildContext context) async {
    if (formRegisterKey.currentState?.validate() != true) return false;
    isLoading = true;
    notifyListeners();
    FocusScope.of(context).unfocus();
    String? firebaseToken = await FirebaseMessaging.instance.getToken();

    RegisterRequest request = RegisterRequest(
        name: userNameController.text,
        email: emailController.text,
        phone: phoneController.text,
        password: passwordController.text,
        passwordConfirmation: confirmPasswordController.text,
        token: firebaseToken,
        accepted: 1);
    formRegisterKey.currentState?.save();
    final result = await register(registerRequest: request.toJson());
    if (result is Success<UserResponse?>) {
      context.read<AuthController>().currentUser = result.data;
      context.read<VerifyController>().type = SendOtpType.non;
      await sendOtp(phone: phoneController.text, context: context);
      isLoading = false;
      notifyListeners();
      return true;
    } else {
      isLoading = false;
      notifyListeners();
      Util.showSnackBar(context,
          message: (result as Error<UserResponse?>).errorMessage!);
      return false;
    }
  }

  FormFieldValidator<String> checkPasswordsMatches(String errorMessage) {
    return (value) {
      //   print("valueee= $value // Password= ${passwordController.text}  ");
      if (value != passwordController.text) {
        return errorMessage;
      }
      return null;
    };
  }

  void resetController() {
    userNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    agreeTermsCondition = false;
    showConfPass = true;
    showPass = true;
  }

  @override
  void disposeValues() {
    resetController();
    // TODO: implement disposeValues
  }
}
