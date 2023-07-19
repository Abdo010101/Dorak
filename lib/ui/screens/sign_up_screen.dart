import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController loginController = context.read<LoginController>();
    AuthController authProvider =
        Provider.of<AuthController>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return await authProvider.onWillPop(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: AppColors.liteWight,
        appBar: AppBar(
            elevation: 0.0,
            title: Text(
              AppStrings.kSignUp.tr(),
              style: TextStyle(color: AppColors.black, fontSize: 13.sp),
            ),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, NameRoutes.kWelcomeScreen, (_) => false),
              color: AppColors.black,
            ),
            backgroundColor: AppColors.white),
        body: Consumer<RegisterController>(
          builder: (_, controller, child) => EmptyCard(
            child: Stack(
              children: [
                Form(
                  key: controller.formRegisterKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.0.h,
                        ),
                        TextFormFieldBuilder(
                          textInputAction: TextInputAction.next,
                          hint: AppStrings.kName.tr(),
                          controller: controller.userNameController,
                          validator: Validators.required('required'.tr()),
                        ),
                        TextFormFieldBuilder(
                            textInputAction: TextInputAction.next,
                            hint: AppStrings.kPhone.tr(),
                            controller: controller.phoneController,
                            keyboardType: TextInputType.number,
                            validator: Validators.required('required'.tr())),
                        TextFormFieldBuilder(
                          textInputAction: TextInputAction.next,
                          hint: AppStrings.kEmail.tr(),
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.compose([
                            Validators.required('required'.tr()),
                            Validators.email('email Must be a Valid')
                          ]),
                        ),
                        TextFormFieldBuilder(
                          textInputAction: TextInputAction.next,
                          hint: AppStrings.kPassword.tr(),
                          controller: controller.passwordController,
                          obscureText: controller.showPass,
                          suffixIcon: IconButton(
                            icon: Icon(controller.showPass
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () => controller.changeShowPass(),
                          ),
                          validator: Validators.compose([
                            Validators.required('required'.tr()),
                          ]),
                        ),
                        TextFormFieldBuilder(
                          hint: AppStrings.kConfirmPassword.tr(),
                          controller: controller.confirmPasswordController,
                          obscureText: controller.showConfPass,
                          suffixIcon: IconButton(
                            icon: Icon(controller.showConfPass
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded),
                            onPressed: () => controller.changeShowConfPass(),
                          ),
                          validator: Validators.compose([
                            Validators.required('required'.tr()),
                            controller.checkPasswordsMatches(
                              'Not Match ',
                            )
                          ]),
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CheckBoxBuilder(
                                onChanged: controller.onChangeTermsCondition,
                                value: controller.agreeTermsCondition),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontFamily: 'Tajawal',
                                    fontSize: 12.sp,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.kPolicy.tr(),
                                      style: TextStyle(
                                        fontFamily: 'Tajawal',
                                        color:
                                            AppColors.darkBlue.withOpacity(0.6),
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return const TermsAndPolicyBottomSheet(
                                                  terms: true,
                                                );
                                              });
                                        },
                                        child: TextBuilder(
                                          verticalPadding: 0.5.h,
                                          horizontalPadding: 0.5.w,
                                          text: AppStrings.kTermsService.tr(),
                                          size: 11.sp,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: TextBuilder(
                                        verticalPadding: 0.5.h,
                                        horizontalPadding: 0.5.w,
                                        text: AppStrings.kAnd.tr(),
                                        size: 11.sp,
                                        color:
                                            AppColors.darkBlue.withOpacity(0.6),
                                      ),
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              isScrollControlled: true,
                                              builder: (context) {
                                                return const TermsAndPolicyBottomSheet(
                                                  terms: false,
                                                );
                                              });
                                        },
                                        child: TextBuilder(
                                          verticalPadding: 0.5.h,
                                          horizontalPadding: 0.5.w,
                                          text: AppStrings.kPrivacyPolicy.tr(),
                                          size: 11.sp,
                                          color: AppColors.blue,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        ButtonBuilder(
                            title: AppStrings.kSignUp.tr(),
                            buttonColor: controller.agreeTermsCondition
                                ? AppColors.blue
                                : AppColors.transparent,
                            borderColor: AppColors.transparent,
                            onPressed: !controller.agreeTermsCondition
                                ? null
                                : () async {
                                    final isSuccess =
                                        await controller.signUp(context);
                                    if (!isSuccess) {
                                    } else {
                                      if (context.mounted) {
                                        Navigator.of(context)
                                            .pushNamed(NameRoutes.kOTPScreen);
                                      }
                                    }
                                  }),

                        ///TODO Remove This Comment After Upload in AppStoreConnect //////

                        /*   Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          padding: EdgeInsets.symmetric(vertical: 1.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(
                                child: DividerLogin(
                                  dividerColor: AppColors.darkGray,
                                ),
                              ),
                              Text(
                                AppStrings.kOrLoginScreen.tr(),
                              ),
                              const Expanded(
                                child: DividerLogin(
                                  dividerColor: AppColors.darkGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ButtonBuilder(
                          title: AppStrings.kRegisterFacebook.tr(),
                          titleStyle: TextStyle(
                              fontSize: AppFontSizes.kS3,
                              color: AppColors.navyBlue,
                              fontWeight: FontWeight.w900),
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
                          height: 6.5.h,
                          buttonColor: AppColors.white,
                          borderColor: AppColors.transparent,
                          onPressed: () async {
                            final isSuccess =
                                await loginController.signInWithSocial(
                                    context, LoginSocialType.facebook);
                            if (!isSuccess) {
                            } else {
                              if (authProvider.currentUser?.patient?.phone !=
                                      null &&
                                  authProvider.currentUser?.patient?.phone !=
                                      '') {
                                if (context.mounted) {
                                  if (authProvider
                                          .currentUser?.patient?.verifiedAt ==
                                      null) {
                                    Navigator.of(context).pushReplacementNamed(
                                        NameRoutes.kOTPScreen);
                                  } else {
                                    Navigator.of(context).pushReplacementNamed(
                                        NameRoutes.kHomeScreen);
                                  }
                                }
                              } else {
                                if (context.mounted) {
                                  Util.kToastWithMessage(
                                      AppStrings.kCompleteInfo.tr());
                                  Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      NameRoutes.kChangePhoneScreen,
                                      (route) => false);
                                  context.read<VerifyController>().type =
                                      SendOtpType.login;
                                }
                              }
                            }
                          },
                          margin: EdgeInsets.symmetric(
                              vertical: 1.h, horizontal: 2.5.w),
                        ),
                        ButtonBuilder(
                            title: AppStrings.kRegisterGoogle.tr(),
                            titleStyle: TextStyle(
                                fontSize: AppFontSizes.kS3,
                                color: AppColors.navyBlue,
                                fontWeight: FontWeight.w900),
                            elevation: 2,
                            suffixIcon: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: 3.w, start: 1.w),
                              child: Image.asset(
                                AppAssets.kGoogle,
                                height: 2.5.h,
                              ),
                            ),
                            height: 6.5.h,
                            buttonColor: AppColors.white,
                            borderColor: AppColors.transparent,
                            onPressed: () async {
                              final isSuccess =
                                  await loginController.signInWithSocial(
                                      context, LoginSocialType.google);
                              if (!isSuccess) {
                              } else {
                                if (authProvider.currentUser?.patient?.phone !=
                                        null &&
                                    authProvider.currentUser?.patient?.phone !=
                                        '') {
                                  if (context.mounted) {
                                    if (authProvider
                                            .currentUser?.patient?.verifiedAt ==
                                        null) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              NameRoutes.kOTPScreen);
                                    } else {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              NameRoutes.kHomeScreen);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    Util.kToastWithMessage(
                                        AppStrings.kCompleteInfo.tr());
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        NameRoutes.kChangePhoneScreen,
                                        (route) => false);
                                    context.read<VerifyController>().type =
                                        SendOtpType.login;
                                  }
                                }
                              }
                            },
                            margin: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 2.5.w)),
                        ButtonBuilder(
                            title: AppStrings.kLoginApple.tr(),
                            titleColor: AppColors.black,
                            titleStyle: TextStyle(
                                fontSize: AppFontSizes.kS3,
                                color: AppColors.black,
                                fontWeight: FontWeight.w900),
                            elevation: 2,
                            suffixIcon: Padding(
                              padding: EdgeInsetsDirectional.only(
                                  end: 3.w, start: 1.w),
                              child: const Icon(
                                Icons.apple_rounded,
                                color: AppColors.black,
                              ),
                            ),
                            height: 6.5.h,
                            buttonColor: AppColors.white,
                            borderColor: AppColors.transparent,
                            onPressed: () async {
                              final isSuccess =
                                  await loginController.signInWithSocial(
                                      context, LoginSocialType.apple);
                              if (!isSuccess) {
                              } else {
                                if (authProvider.currentUser?.patient?.phone !=
                                        null &&
                                    authProvider.currentUser?.patient?.phone !=
                                        '') {
                                  if (context.mounted) {
                                    if (authProvider
                                            .currentUser?.patient?.verifiedAt ==
                                        null) {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              NameRoutes.kOTPScreen);
                                    } else {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              NameRoutes.kHomeScreen);
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    Util.kToastWithMessage(
                                        AppStrings.kCompleteInfo.tr());
                                    Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        NameRoutes.kChangePhoneScreen,
                                        (route) => false);
                                    context.read<VerifyController>().type =
                                        SendOtpType.login;
                                  }
                                }
                              }
                            },
                            margin: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 2.5.w)),
                        SizedBox(
                          height: 3.h,
                        ),*/
                        /// --------------------------------------------------------------

                        const AlreadyHaveAccountWidget(),
                      ],
                    ),
                  ),
                ),
                controller.isLoading
                    ? const LoadingWidget(
                        backgroundColor: AppColors.transparent,
                      )
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
