import 'package:dio/dio.dart';
import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:easy_localization/easy_localization.dart';
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
  Patient? profile;

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
    if (nameController.text == profile?.name &&
        phoneController.text == profile?.phone &&
        emailController.text == profile?.email &&
        profile?.gender == gender) return false;
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
      if (result.data != null && context.mounted) {
        AuthController auth =
            Provider.of<AuthController>(context, listen: false);
        profile = result.data;
        auth.currentUser?.patient = result.data;
        await _sharedPref.storeLoginInfo(
          UserResponse(token: auth.currentUser?.token, patient: result.data),
        );
        notifyListeners();
        if (context.mounted) {
          Navigator.pushNamedAndRemoveUntil(
              context, NameRoutes.kHomeScreen, (_) => false);
        }
        return true;
      } else {
        if (result.error?.statusCode == 401) {
          if (context.mounted) {
            Navigator.of(context).pushNamedAndRemoveUntil(
                NameRoutes.kLoginScreen, (route) => false);
            Util.showSnackBar(context, message: result.error?.message);
          }
        }

        if (result.error != null) {
          if (context.mounted && result.error!.statusCode! >= 500) {
            Util.showSnackBar(context, message: AppStrings.kUnknownError.tr(),
                onTap: () async {
              await updateProfile(context);
            });
          }
        }
        return false;
      }
    } on DioError catch (_) {
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
      if (result.data != null && context.mounted) {
        profile = result.data!;
        context.read<AuthController>().currentUser?.patient = profile;
      } else {
        if (result.error?.statusCode == 401) {
          // if (context.mounted) {
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       NameRoutes.kLoginScreen, (route) => false);
          //   Util.showSnackBar(context, message: result.error?.message);
          // }
        }
        if (result.error != null) {
          if (context.mounted && result.error!.statusCode! >= 500) {
            Util.showSnackBar(context, message: AppStrings.kUnknownError.tr(),
                onTap: () async {
              await getProfileData(context);
            });
          }
        }
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
    profile = null;
    // TODO: implement disposeValues
  }
}
