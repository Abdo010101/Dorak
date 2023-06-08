import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    RegisterController controller =
        Provider.of<RegisterController>(context, listen: false);
    VerifyController verifyController =
        Provider.of<VerifyController>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            AppStrings.kChangePassword.tr(),
            style: TextStyle(color: AppColors.black, fontSize: 13.sp),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () => Navigator.pop(context),
            color: AppColors.black,
          ),
          backgroundColor: AppColors.white),
      body: Container(
        padding: EdgeInsets.all(5.0.w),
        child: EmptyCard(
          child: Form(
            key: controller.changePasswordKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 2.0.h,
                ),
                TextFormFieldBuilder(
                  hint: AppStrings.kPassword.tr(),
                  controller: controller.passwordController,
                  validator: Validators.compose([
                    Validators.required('required'),
                  ]),
                ),
                TextFormFieldBuilder(
                  hint: AppStrings.kConfirmPassword.tr(),
                  controller: controller.confirmPasswordController,
                  validator: Validators.compose([
                    Validators.required('required'.tr()),
                    controller.checkPasswordsMatches(
                      'Not Match '.tr(),
                    )
                  ]),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                ButtonBuilder(
                  title: 'send'.tr(),
                  onPressed: () {
                    controller.changePassword(
                      context,
                      controller.passwordController.text,
                      verifyController.phoneController.text,
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
