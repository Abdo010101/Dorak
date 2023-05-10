import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/response/response.dart';
import '../../data/repository/repository.dart';

class LoginController extends AuthController {
  TextEditingController emailTextEditingController = TextEditingController();

  TextEditingController passwordTextEditingController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool rememberMe = true;
  final _authenticationRepository = locator<AuthenticationRepository>();
  bool showPass = true;

  onChangedRememberMe(bool? value) {
    rememberMe = value!;
    notifyListeners();
  }

  Future<bool> signIn(BuildContext context) async {
    if (formKey.currentState?.validate() != true) return false;
    FocusScope.of(context).unfocus();
    //String? firebaseToken = await FirebaseMessaging.instance.getToken();

    isLoading = true;
    notifyListeners();
    formKey.currentState?.save();
    final result = await login(
        email: emailController.text,
        password: passwordController.text,
        rememberMe: rememberMe,
        token: '');
    isLoading = false;

    notifyListeners();

    if (result is Success<UserResponse?>) {
      return true;
    } else {
      Util.showSnackBar(context,
          message: (result as Error<UserResponse?>).errorMessage!);

      return false;
    }
  }
}
