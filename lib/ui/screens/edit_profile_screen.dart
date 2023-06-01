import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    PatientProfileController controller =
        Provider.of<PatientProfileController>(context, listen: false);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Edit my profile',
      ),
      bottomNavigationBar: ButtonBuilder(
        title: AppStrings.kSaveChanges.tr(),
        onPressed: () => controller.updateProfile(context),
        borderColor: AppColors.blue,
        buttonColor: AppColors.blue,
        margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
      ),
      backgroundColor: AppColors.liteWight,
      body: Column(
        children: [
          Stack(
            children: [
              EmptyCard(
                verticalMargin: 1.h,
                verticalPadding: 2.h,
                color: AppColors.white,
                child: Form(
                  key: controller.profileFormKey,
                  child: Column(
                    children: [
                      TextFormFieldBuilder(
                        controller: controller.nameController,
                        validator: Validators.compose(
                          [
                            Validators.required('required'.tr()),
                          ],
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormFieldBuilder(
                        controller: controller.phoneController,
                        keyboardType: TextInputType.phone,
                        validator: Validators.compose(
                          [
                            Validators.required('required'.tr()),
                          ],
                        ),
                        textInputAction: TextInputAction.next,
                      ),
                      TextFormFieldBuilder(
                        controller: controller.emailController,
                        validator: Validators.compose(
                          [
                            Validators.required('required'.tr()),
                          ],
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      DropDownBuilder(
                        value: controller.gender,
                        items: AppStrings.kGenderList,
                        isReport: true,
                        onChanged: controller.changeGender,
                      )
                    ],
                  ),
                ),
              ),
              Selector<PatientProfileController, bool>(
                selector: (_, provider) => provider.isLoading,
                builder: (context, isLoading, child) {
                  return isLoading
                      ? const LoadingWidget(
                          backgroundColor: AppColors.transparent,
                        )
                      : const SizedBox();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
