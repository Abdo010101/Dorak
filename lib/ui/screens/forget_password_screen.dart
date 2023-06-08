import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    VerifyController controller =
        Provider.of<VerifyController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
          elevation: 0.0,
          title: Text(
            AppStrings.kForgetPassword.tr(),
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
            key: controller.formPhoneKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 2.0.h,
                ),
                TextFormFieldBuilder(
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  hint: AppStrings.kPhone.tr(),
                  validator: Validators.compose(
                    [
                      Validators.required('required'.tr()),
                    ],
                  ),
                ),
                SizedBox(
                  height: 2.0.h,
                ),
                Text("sent_text_message".tr()),
                SizedBox(
                  height: 2.0.h,
                ),
                ButtonBuilder(
                  title: 'send'.tr(),
                  onPressed: () async {
                    controller.type = SendOtpType.changPassword;
                    Navigator.pushNamed(context, NameRoutes.kOTPScreen);
                    await controller.sendOtp(
                        context: context,
                        phone: controller.phoneController.text);
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
