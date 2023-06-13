import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:flutter/cupertino.dart';

import '../../constants/constants.dart';
import '../../data/models/response/response.dart';
import '../../data/networks/model_response.dart';
import '../../ui/screens/screens.dart';
import '../../utis/util.dart';
import '../controllers.dart';

class VerifyController extends AuthController {
  TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> formVerifyKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formPhoneKey = GlobalKey<FormState>();

  final List<Widget> textFormList = [];
  Timer? countdownTimer;
  Duration myDuration = const Duration(seconds: 59);
  SendOtpType type = SendOtpType.non;
  final List<TextEditingController> textEditingControllerList = [];

  void startTimer() {
    myDuration = const Duration(seconds: 59);
    countdownTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountDown());
  }

  void setCountDown() {
    final reduceSecondsBy = 1;
    final seconds = myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      countdownTimer!.cancel();
    } else {
      myDuration = Duration(seconds: seconds);
    }
    notifyListeners();
  }

  void initForms() {
    int i = 0;
    textFormList.clear();
    textEditingControllerList.clear();
    for (i; i < 4; i++) {
      TextEditingController controller = TextEditingController();
      FocusNode focusNode = FocusNode();
      textEditingControllerList.add(controller);
      textFormList.add(OTPVerificationTextFormField(
        textEditingController: controller,
        focusNode: focusNode,
      ));
    }
    notifyListeners();
  }

  Future<bool> verify(
    BuildContext context,
    String? phone,
  ) async {
    if (formVerifyKey.currentState?.validate() != true) return false;
    isLoading = true;
    notifyListeners();
    formVerifyKey.currentState?.save();
    StringBuffer otp = StringBuffer();
    textEditingControllerList.forEach((element) {
      otp.write(element.text);
    });
    try {
      final result = type == SendOtpType.changPassword
          ? await checkOtp(context: context, phone: phone, otp: otp.toString())
          : await verifyOtp(context: context, otp: otp.toString());
      if (result is Success<Patient> || result is Success<dynamic>) {
        isLoading = false;
        notifyListeners();
        if (type == SendOtpType.non)
          Navigator.pushNamed(context, NameRoutes.kSuccessScreen);
        else {
          Navigator.pushNamed(context, NameRoutes.kChangePasswordScreen);
        }
        notifyListeners();
        return true;
      } else {
        isLoading = false;
        notifyListeners();
        Util.showSnackBar(context,
            message: (result as Error<dynamic>).errorMessage!);
        return false;
      }
    } on DioError catch (e) {
      isLoading = false;
      notifyListeners();
      Util.showSnackBar(context, message: e.message);
      return false;
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  void resetController() {
    textFormList.clear();
    countdownTimer = null;
    myDuration = const Duration(seconds: 59);
    phoneController.clear();
    type = SendOtpType.changPassword;
    textEditingControllerList.clear();
  }

  @override
  void disposeValues() {}
}
