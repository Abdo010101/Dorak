import 'package:dio/dio.dart';
import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../data/di/locator.dart';
import '../data/models/response/response.dart';
import '../data/repository/repository.dart';
import '../data/shared/shared_pref.dart';
import '../routes/dorak_routes.dart';
import '../utis/util.dart';

class PatientProfileController extends DisposableProvider {
  bool isLoading = false;
  final _sharedPref = locator<SharedPref>();
  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final _profileRepository = locator<ProfileRepository>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String? gender;
  Patient profile = Patient();

  resetProfileData({Patient? patient}) {
    nameController.text = patient?.name ?? '';
    phoneController.text = patient?.phone ?? '';
    emailController.text = patient?.email ?? '';
    gender = patient?.gender ?? AppStrings.kGenderList[0];
    profile = patient!;
    notifyListeners();
  }

  changeGender(value) {
    gender = value;
    notifyListeners();
  }

  Future<bool> updateProfile(BuildContext context) async {
    if (profileFormKey.currentState?.validate() != true) return false;
    if (nameController.text == profile.name &&
        phoneController.text == profile.phone &&
        emailController.text == profile.email &&
        profile.gender == gender) return false;
    isLoading = true;
    notifyListeners();
    Patient patient = Patient(
      name: nameController.text,
      phone: phoneController.text,
      email: emailController.text,
      gender: gender,
    );
    profileFormKey.currentState?.save();
    try {
      final result = await _profileRepository.updateProfile(patient);
      isLoading = false;
      notifyListeners();
      if (result.data != null) {
        AuthController auth =
            Provider.of<AuthController>(context, listen: false);
        auth.currentUser?.patient = result.data;
        await _sharedPref.storeLoginInfo(
          UserResponse(token: auth.currentUser?.token, patient: result.data),
        );
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
            context, NameRoutes.kHomeScreen, (_) => false);
        return true;
      } else {
        Util.showSnackBar(context, message: result.error?.message);
        return false;
      }
    } on DioError catch (e) {
      print(e.toString());
      return false;
      // return Error(errorMessage: DioExceptions.fromDioError(e).message);
      //GetSnackBar(message: (DioExceptions.fromDioError(e).message));
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> getProfileData(BuildContext context) async {
    try {
      isLoading = true;
      notifyListeners();
      final result = await _profileRepository.getProfileData();
      if (result.data != null) {
        profile = result.data!;
        context.read<AuthController>().currentUser?.patient = profile;
      }
    } on DioError catch (e) {
      Util.showSnackBar(context, message: e.message);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void disposeValues() {
    // TODO: implement disposeValues
  }
}
