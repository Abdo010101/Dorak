import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class PhoneVerificationScreen extends StatefulWidget {
  const PhoneVerificationScreen({Key? key}) : super(key: key);

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  VerifyController? verifyController;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      verifyController = Provider.of<VerifyController>(context, listen: false);
      verifyController?.initForms();
      verifyController?.startTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthController authController =
        Provider.of<AuthController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            AppStrings.kPhoneVerification.tr(),
            style: TextStyle(color: AppColors.black, fontSize: 13.sp),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            color: AppColors.black,
          ),
          backgroundColor: AppColors.white),
      body: Consumer<VerifyController>(
        builder: (context, controller, child) {
          final seconds = controller.myDuration.inSeconds;
          return Stack(
            children: [
              EmptyCard(
                child: Form(
                  key: verifyController?.formVerifyKey,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          height: 2.0.h,
                        ),
                        Text(
                          AppStrings.kOtpVerification.tr(),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        Text(
                          AppStrings.kAuthCodeSent.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: AppColors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 0.5.h,
                        ),
                        Text(
                          controller.type == SendOtpType.changPassword
                              ? controller.phoneController.text
                              : '${authController.currentUser?.patient?.phone}',
                          style:
                              TextStyle(fontSize: 10.sp, color: AppColors.grey),
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: verifyController?.textFormList ?? [],
                        ),
                        SizedBox(
                          height: 1.0.h,
                        ),
                        OtpVerificationRichText(
                          title: AppStrings.kDidReceiveCode.tr(),
                          textButtonTitle: (AppStrings.kResendCode.tr()),
                          isResendCode:
                              verifyController?.myDuration.inSeconds == 0,
                          onTab: () async {
                            print("xxxx= $seconds}");
                            if (seconds == 0) {
                              controller.type == SendOtpType.changPassword
                                  ? await authController.sendOtp(
                                      context: context,
                                      phone: controller.phoneController.text)
                                  : await authController.sendOtp(
                                      context: context,
                                      phone: authController
                                          .currentUser?.patient?.phone,
                                    );
                            }
                          },
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        Text(
                          '$seconds ${AppStrings.kSecLeft.tr()}',
                          style: TextStyle(
                              fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2.0.h,
                        ),
                        ButtonBuilder(
                          title: AppStrings.kVerifyNow.tr(),
                          onPressed: () async {
                            controller.type == SendOtpType.changPassword
                                ? await verifyController!.verify(
                                    context, controller.phoneController.text)
                                : await verifyController!.verify(context,
                                    authController.currentUser?.patient?.phone);
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
              controller.isLoading
                  ? Positioned(
                      right: 30.w,
                      child: const LoadingWidget(
                        backgroundColor: AppColors.transparent,
                      ),
                    )
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    verifyController?.countdownTimer?.cancel();
    super.dispose();
  }
}

class OTPVerificationTextFormField extends StatelessWidget {
  const OTPVerificationTextFormField(
      {Key? key, required this.textEditingController, required this.focusNode})
      : super(key: key);

  final TextEditingController textEditingController;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextFormFieldBuilder(
        lengthTextInput: 1,
        // dv: 2.0.w,
        controller: textEditingController,
        validator: Validators.required('required'.tr()),
        autoFocus: true,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onChange: (value) => value.isNotEmpty ? focusNode.nextFocus() : null,
        focusNode: focusNode,
        padding: EdgeInsets.symmetric(vertical: 3.0.h),
        textAlign: TextAlign.center,
        defaultBorder: true,
        hint: '',
        borderRadius: 15.0,
        width: 18.0.w);
  }
}

class OtpVerificationRichText extends StatelessWidget {
  const OtpVerificationRichText(
      {Key? key,
      required this.textButtonTitle,
      required this.title,
      this.isResendCode = false,
      required this.onTab})
      : super(key: key);

  final String textButtonTitle;
  final VoidCallback onTab;
  final String title;
  final bool isResendCode;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: title,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.grey,
            fontFamily: 'Tajawal',
          )),
      WidgetSpan(
          child: SizedBox(
        width: 2.0.w,
      )),
      TextSpan(
          recognizer: TapGestureRecognizer()..onTap = onTab,
          text: textButtonTitle,
          style: TextStyle(
              fontSize: 10.sp,
              fontFamily: 'Tajawal',
              decoration: TextDecoration.underline,
              color: isResendCode ? AppColors.blue : AppColors.grey)),
    ]));
  }
}
