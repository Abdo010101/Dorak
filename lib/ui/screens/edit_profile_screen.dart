import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer<PatientProfileController>(
        builder: (BuildContext context, controller, Widget? child) {
      return Scaffold(
        appBar: const CustomAppBar(
          title: 'Edit my profile',
        ),
        bottomNavigationBar: ButtonBuilder(
          title: AppStrings.kSaveChanges.tr(),
          onPressed: () {},
          borderColor: AppColors.blue,
          buttonColor: AppColors.blue,
          margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
        ),
        backgroundColor: AppColors.liteWight,
        body: Column(
          children: [
            EmptyCard(
              verticalMargin: 1.h,
              verticalPadding: 2.h,
              color: AppColors.white,
              child: Column(
                children: [
                  TextFormFieldBuilder(
                    controller: controller.nameController,
                  ),
                  TextFormFieldBuilder(
                    controller: controller.phoneController,
                  ),
                  TextFormFieldBuilder(
                    controller: controller.emailController,
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
          ],
        ),
      );
    });
  }
}
