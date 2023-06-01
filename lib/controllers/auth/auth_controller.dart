import 'package:dio/dio.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/networks/dio_errors.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:flutter/material.dart';

import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';
import '../../data/repository/repository.dart';
import '../controllers.dart';

class AuthController extends DisposableProvider {
  final _sharedPref = locator<SharedPref>();

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
        await _sharedPref.storeLoginInfo(result.data!);
        isLoggedIn = _sharedPref.isUserLoggedIn();
        currentUser = result.data;
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

  Future<Result<UserResponse?>> register({
    required var registerRequest,
  }) async {
    try {
      //Loading().loading(context);

      final result = await _authenticationRepository.register(registerRequest);
      if (result.data != null) {
        InjectionClass.dio.options.headers.addAll({
          NetworkConstant.kAuthorizationHeader:
              '${NetworkConstant.tokenBuilder(result.data!.token!)} '
        });
        await _sharedPref.storeLoginInfo(result.data!);
        isLoggedIn = _sharedPref.isUserLoggedIn();
        currentUser = result.data;
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

  Future<Result<UserResponse?>> loginWithSocial(
      {required LoginWithSocialRequest loginRequest}) async {
    try {
      final result =
          await _authenticationRepository.loginWithSocial(loginRequest);
      if (result.data != null) {
        ///TODO enhance here .
        InjectionClass.dio.options.headers.addAll({
          NetworkConstant.kAuthorizationHeader:
              '${NetworkConstant.tokenBuilder(result.data!.token!)} '
        });
        await _sharedPref.storeLoginInfo(result.data!);
        isLoggedIn = _sharedPref.isUserLoggedIn();
        currentUser = result.data;
        notifyListeners();
        return Success(result.data!);
      } else {
        return Error(errorMessage: result.error?.message);
      }
    } on DioError catch (e) {
      return Error(errorMessage: DioExceptions.fromDioError(e).message);
    } finally {}
  }

  Future<dynamic> logout(BuildContext context) async {
    try {
      final result = await _authenticationRepository.logout();
      if (result.data != null) {
        notifyListeners();
        return true;
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

  Future<void> checkUserLoggedIn() async {
    isLoggedIn = _sharedPref.isUserLoggedIn();
    if (isLoggedIn) {
      currentUser = await _sharedPref.retrieveUserInfo();
      InjectionClass.dio.options.headers.addAll({
        NetworkConstant.kAuthorizationHeader: 'Bearer ${currentUser!.token}'
      });
    }
    @override
    void disposeValues() {
      isLoggedIn = false;
      currentUser = UserResponse();
      _sharedPref.deleteLoginInfo();
    }
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}
