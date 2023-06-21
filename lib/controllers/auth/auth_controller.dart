import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/networks/dio_errors.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/data/networks/network_constant.dart';
import 'package:dorakpattient/data/shared/shared_pref.dart';
import 'package:flutter/material.dart';

import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';
import '../../data/repository/repository.dart';
import '../../routes/dorak_routes.dart';
import '../controllers.dart';

class AuthController extends DisposableProvider {
  final _sharedPref = locator<SharedPref>();
  // final GlobalKey<FormState> formChangePasswordKey = GlobalKey<FormState>();

  final _authenticationRepository = locator<AuthenticationRepository>();
  UserResponse? currentUser = UserResponse();
  bool isLoggedIn = false;
  bool isLoading = false;

  Future<bool> onWillPop(BuildContext context) async {
    Navigator.pushNamedAndRemoveUntil(
        context, NameRoutes.kWelcomeScreen, (_) => false);
    return false;
  }

  Future<Result<Patient?>> completeData({required String gender}) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'gender': gender,
      });
      final result = await _authenticationRepository.completeData(
        body: data,
      );
      if (result.data != null) {
        currentUser?.patient?.gender = gender;
        return Success(result.data!);
      } else {
        return Error(errorMessage: result.error?.message);
      }
    } on DioError catch (e) {
      return Error(errorMessage: DioExceptions.fromDioError(e).message);
    } finally {
      isLoading = false;
      notifyListeners();
      //Dismiss Dialog .
      // Get.back();
    }
  }

  Future<Result<UserResponse?>> login(
      {required String email,
      required String password,
      required String? token,
      required bool rememberMe}) async {
    try {
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
  }

  Future<dynamic> sendOtp(
      {required BuildContext context, required String? phone}) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'phone': phone,
      });
      final result = await _authenticationRepository.sendOtp(
        body: data,
      );
      isLoading = false;
      notifyListeners();
      if (result.data != null) {
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  Future<Result<dynamic>> checkOtp(
      {required BuildContext context,
      required String otp,
      required String? phone}) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'otp': otp,
      });
      final result = await _authenticationRepository.checkOtp(
        phone: phone ?? '',
        body: data,
      );
      isLoading = false;
      notifyListeners();
      if (result.data != null) {
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

  Future<Result<dynamic>> verifyOtp(
      {required BuildContext context, required String otp}) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'otp': otp,
      });
      final result = await _authenticationRepository.verifyOtp(
        body: data,
      );
      isLoading = false;
      notifyListeners();
      if (result.data != null) {
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

  Future<bool> changePhone(
      {required BuildContext context, required String phone}) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'phone': phone,
      });
      final result = await _authenticationRepository.changePhone(
        body: data,
      );
      if (result.data != null) {
        await _sharedPref.storeLoginInfo(
          UserResponse(
              token: currentUser?.token, patient: currentUser?.patient),
        );
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> changePassword(
      BuildContext context, String password, String phone) async {
    try {
      isLoading = true;
      notifyListeners();
      var data = dio.FormData.fromMap({
        'password': password,
        'password_confirmation': password,
      });

      final result = await _authenticationRepository.changePassword(
        phone: phone,
        body: data,
      );
      if (result.data != null) {
        isLoading = false;
        notifyListeners();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, NameRoutes.kWelcomeScreen, (_) => false);
        }
        return true;
      } else {
        isLoading = true;
        notifyListeners();
        return false;
      }
    } on DioError catch (e) {
      isLoading = true;
      notifyListeners();
      return false;
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  @override
  void disposeValues() {
    isLoggedIn = false;
    currentUser = UserResponse();
    _sharedPref.deleteLoginInfo();
    // TODO: implement disposeValues
  }
}
