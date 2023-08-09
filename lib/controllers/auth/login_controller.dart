import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/di/locator.dart';
import 'package:dorakpattient/data/networks/model_response.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../constants/constants.dart';
import '../../data/models/request/request.dart';
import '../../data/models/response/response.dart';
import '../../data/shared/shared_pref.dart';
import '../../routes/dorak_routes.dart';

class LoginController extends AuthController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController changePassController = TextEditingController();
  TextEditingController confirmChangePassController = TextEditingController();
  final GlobalKey<FormState> formLoginKey = GlobalKey<FormState>();

  bool rememberMe = true;
  bool showPass = true;
  final _sharedPref = locator<SharedPref>();

  void changeShowPass() {
    showPass = !showPass;
    notifyListeners();
  }

  onChangedRememberMe(bool? value) {
    rememberMe = value!;
    notifyListeners();
  }

  Future<bool> signIn(BuildContext context) async {
    if (formLoginKey.currentState?.validate() != true) return false;
    FocusScope.of(context).unfocus();
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    isLoading = true;
    notifyListeners();
    formLoginKey.currentState?.save();
    final result = await login(
        email: emailController.text,
        password: passwordController.text,
        rememberMe: rememberMe,
        token: firebaseToken);
    isLoading = false;
    notifyListeners();
    if (result is Success<UserResponse?> && context.mounted) {
      context.read<AuthController>().currentUser = result.data;
      if (result.data?.patient?.verifiedAt == null) {
        Navigator.pushReplacementNamed(context, NameRoutes.kOTPScreen);
      } else {
        Navigator.pushNamedAndRemoveUntil(
            context, NameRoutes.kHomeScreen, (_) => false);
      }
      return true;
    } else {
      Util.showSnackBar(context,
          message: (result as Error<UserResponse?>).errorMessage!);
      return false;
    }
  }

  Future<bool> signInWithSocial(
      BuildContext context, LoginSocialType type) async {
    isLoading = true;
    notifyListeners();
    _sharedPref.setLoginType(type);
    LoginWithSocialRequest userData = type == LoginSocialType.facebook
        ? await loginInWithFacebook()
        : type == LoginSocialType.apple
            ? await loginInWithApple()
            : await loginWithGoogleAccount();
    if (userData.socialId != null && context.mounted) {
      final result = await Provider.of<AuthController>(context, listen: false)
          .loginWithSocial(loginRequest: userData);
      isLoading = false;
      notifyListeners();
      if (result is Success<UserResponse?>) {
        if (context.mounted) {
          context.read<AuthController>().currentUser = result.data;
        }
        return true;
      } else {
        if (context.mounted) {
          Util.showSnackBar(context,
              message: (result as Error<UserResponse?>).errorMessage);
        }
        isLoading = false;
        notifyListeners();
        return false;
      }
    }
    isLoading = false;
    notifyListeners();
    return false;
  }

  Map<String, dynamic>? _userData;

  Future<LoginWithSocialRequest> loginInWithFacebook() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    final accessToken = await FacebookAuth.instance.accessToken;
    if (accessToken != null) {
      final userData = await FacebookAuth.instance.getUserData();
      _userData = userData;
      return LoginWithSocialRequest(
        email: _userData?['email'],
        name: _userData?['name'],
        socialId: _userData?['id'],
        firebaseToken: firebaseToken,
      );
    } else {
      String? firebaseToken = await FirebaseMessaging.instance.getToken();
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        _userData = userData;
        return LoginWithSocialRequest(
          email: _userData?['email'],
          name: _userData?['name'],
          socialId: _userData?['id'],
          firebaseToken: firebaseToken,
        );
      } else {
        return LoginWithSocialRequest();
      }
    }
  }

  Future<LoginWithSocialRequest> loginInWithApple() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    if (credential.userIdentifier != null) {
      return LoginWithSocialRequest(
        email: credential.email,
        name: credential.givenName,
        socialId: credential.userIdentifier,
        firebaseToken: firebaseToken,
      );
    } else {
      return LoginWithSocialRequest();
    }
  }

  logOutWithFacebook() async {
    await FacebookAuth.instance.logOut();
    _userData = null;
  }

  static final googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );
  dynamic user;

  Future<LoginWithSocialRequest> loginWithGoogleAccount() async {
    String? firebaseToken = await FirebaseMessaging.instance.getToken();
    user = await googleSignIn.signIn();
    if (user != null) {
      return LoginWithSocialRequest(
        email: user.email,
        name: user.displayName,
        socialId: user.id,
        firebaseToken: firebaseToken,
      );
    } else {
      isLoading = false;
      notifyListeners();
      return LoginWithSocialRequest();
    }
  }

  void logoutFromGoogleAccount() async {
    user = await googleSignIn.disconnect();
  }

  void resetController() {
    emailController.clear();
    passwordController.clear();
    phoneController.clear();
    changePassController.clear();
    confirmChangePassController.clear();
    rememberMe = true;
    showPass = true;
  }

  @override
  void disposeValues() {
    resetController();
    // TODO: implement disposeValues
  }
}
