import 'package:dorakpattient/controllers/auth/login_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../routes/dorak_routes.dart';
import '../components/components.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller =
        Provider.of<LoginController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            AppStrings.kSignIn.tr(),
            style: TextStyle(color: AppColors.black, fontSize: 13.sp),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            color: AppColors.black,
          ),
          backgroundColor: AppColors.white),
      body: Selector<LoginController, bool>(
        selector: (_, provider) => provider.isLoading,
        builder: (context, isLoading, child) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 4.h,
                  ),
                  Stack(
                    children: [
                      Form(
                        key: controller.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      AppStrings.kWelcomeBack.tr(),
                                      style: TextStyle(
                                          fontSize: AppFontSizes.kS5,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.blue),
                                    ),
                                    SizedBox(
                                      height: 0.5.h,
                                    ),
                                    Text(
                                      AppStrings.kSignInToContinue.tr(),
                                      style: TextStyle(
                                        fontSize: AppFontSizes.kS4,
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 5.h,
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 1.5.w,
                                  ),
                                  color: AppColors.transparent,
                                  child: Image.asset(
                                    AppAssets.kWelcomeLogo2,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                            EmptyCard(
                              horizontalMargin: 0,
                              verticalPadding: 1.h,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 3.0.h,
                                  ),
                                  TextFormFieldBuilder(
                                    controller:
                                        controller.emailTextEditingController,
                                    textInputAction: TextInputAction.next,
                                    validator: Validators.compose(
                                      [
                                        Validators.required('required'.tr()),
                                      ],
                                    ),
                                    hint: 'johndoe@mail.com',
                                    prefixIcon: const Icon(Icons.email,
                                        color: AppColors.blue),
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  TextFormFieldBuilder(
                                    controller: controller
                                        .passwordTextEditingController,
                                    obscureText: true,
                                    textInputAction: TextInputAction.done,
                                    validator: Validators.compose([
                                      Validators.required('required'.tr()),
                                      Validators.minLength(6,
                                          'Password Must be a More than 5 Characters')
                                    ]),
                                    hint: '',
                                    prefixIcon: const Icon(
                                      Icons.lock_open_sharp,
                                      color: AppColors.blue,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          CheckBoxBuilder(
                                              onChanged: controller
                                                  .onChangedRememberMe,
                                              value: controller.rememberMe),
                                          Text(
                                            AppStrings.kRememberMe.tr(),
                                            style: TextStyle(fontSize: 11.sp),
                                          )
                                        ],
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context,
                                              NameRoutes.kForgetPasswordScreen);
                                        },
                                        child: Text(
                                            AppStrings.kForgetPassword.tr(),
                                            style: TextStyle(
                                              color: AppColors.blue,
                                              fontSize: 11.sp,
                                            )),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 2.0.h,
                                  ),
                                  ButtonBuilder(
                                      title: AppStrings.kSignIn.tr(),
                                      onPressed: () async {
                                        final isSuccess =
                                            await controller.signIn(context);
                                      }),
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 1.h),
                              padding: EdgeInsets.symmetric(vertical: 1.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const DividerLogin(
                                    dividerColor: AppColors.darkGray,
                                  ),
                                  Text(
                                    AppStrings.kOrLoginScreen.tr(),
                                  ),
                                  const DividerLogin(
                                    dividerColor: AppColors.darkGray,
                                  ),
                                ],
                              ),
                            ),
                            ButtonBuilder(
                              title: AppStrings.kLoginFacebook.tr(),
                              titleColor: AppColors.navyBlue,
                              elevation: 2,
                              suffixIcon: Padding(
                                padding: EdgeInsetsDirectional.only(
                                    end: 3.w, start: 1.w),
                                child: Image.asset(
                                  AppAssets.kFacebook,
                                  color: AppColors.blue,
                                  height: 2.5.h,
                                ),
                              ),
                              height: 7.h,
                              buttonColor: AppColors.white,
                              borderColor: AppColors.transparent,
                              onPressed: () async {},
                              margin: EdgeInsets.symmetric(
                                  vertical: 1.h, horizontal: 2.5.w),
                            ),
                            ButtonBuilder(
                                title: AppStrings.kLoginGoogle.tr(),
                                titleColor: AppColors.navyBlue,
                                elevation: 2,
                                suffixIcon: Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      end: 3.w, start: 1.w),
                                  child: Image.asset(
                                    AppAssets.kGoogle,
                                    height: 2.5.h,
                                  ),
                                ),
                                height: 7.h,
                                buttonColor: AppColors.white,
                                borderColor: AppColors.transparent,
                                onPressed: () async {},
                                margin: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 2.5.w)),
                          ],
                        ),
                      ),
                      controller.isLoading
                          ? const LoadingWidget(
                              backgroundColor: AppColors.transparent,
                            )
                          : const SizedBox(),
                    ],
                  ),
                  const AlreadyHaveAccountWidget()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
