import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/networks/dio_errors.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';
import '../../data/repository/repository.dart';

class AuthController extends ChangeNotifier {
  TextEditingController emailController = TextEditingController();
  final _sharedPref = locator<SharedPref>();

  TextEditingController passwordController = TextEditingController();

  final _authenticationRepository = locator<AuthenticationRepository>();
  UserResponse? currentUser = UserResponse();
  bool isLoggedIn = false;

  Future<Result<UserResponse?>> login(
      {required String email,
      required String password,
      required String? token,
      required bool rememberMe}) async {
    try {
      //Loading().loading(context);
      LoginRequest loginRequest =
          LoginRequest(emailOrPhone: email, password: password, token: token);

      final result = await _authenticationRepository
          .loginWithEmailAndPassword(loginRequest);
      if (result.data != null) {
        InjectionClass.dio.options.headers.addAll({
          NetworkConstant.kAuthorizationHeader:
              '${NetworkConstant.tokenBuilder(result.data!.token!)} '
        });

        currentUser = result.data;
        notifyListeners();
        return Success(result.data!);
      } else {
        return Error(errorMessage: result.error?.message);
      }
    } on DioError catch (e) {
      return Error(errorMessage: DioExceptions.fromDioError(e).message);
    } finally {
      //Dismiss Dialog .
      // Get.back();
    }
  }
}
