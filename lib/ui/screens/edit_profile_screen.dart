import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class ProfileDetailsScreen extends StatelessWidget {
  const ProfileDetailsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final patient = Provider.of<LoginController>(context).currentUser?.patient;

    return Consumer<PatientProfileController>(
        builder: (BuildContext context, controller, Widget? child) {
      return Scaffold(
        appBar: CustomAppBar(
          title: 'My profile',
        ),
        bottomNavigationBar: controller.edit
            ? ButtonBuilder(
                title: AppStrings.kSaveChanges.tr(),
                onPressed: () {},
                borderColor: AppColors.blue,
                buttonColor: AppColors.blue,
                margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
              )
            : null,
        backgroundColor: AppColors.liteWight,
        body: Column(
          children: [
            EmptyCard(
              verticalMargin: 1.h,
              verticalPadding: 2.h,
              color: AppColors.white,
              child: Column(
                children: controller.edit
                    ? [
                        TextFormFieldBuilder(
                          controller: controller.nameController,
                          initValue: patient?.name,
                        ),
                        TextFormFieldBuilder(
                          controller: controller.phoneController,
                        ),
                        TextFormFieldBuilder(
                          controller: controller.emailController,
                        ),
                        DropDownBuilder(
                          hint: 'Gender',
                          value: 'meal',
                          items: const ['meal', 'female'],
                          isReport: true,
                          onChanged: (value) {},
                        )
                      ]
                    : [
                        Row(
                          children: [
                            const Spacer(),
                            MaterialButton(
                              minWidth: 5.w,
                              padding: EdgeInsets.zero,
                              onPressed: controller.changeToEdit,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 0.25.w),
                                    child: SvgPicture.asset(
                                      AppAssets.kPen,
                                      width: 4.w,
                                    ),
                                  ),
                                  Text(
                                    AppStrings.kEdit.tr(),
                                    style: TextStyle(
                                        color: AppColors.blue,
                                        fontSize: AppFontSizes.kS3),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        InformationText(
                          title: AppStrings.kName.tr(),
                          subTitle: patient?.name ?? '',
                        ),
                        InformationText(
                          title: AppStrings.kPhone.tr(),
                          subTitle: patient?.phone ?? '',
                        ),
                        InformationText(
                          title: AppStrings.kEmail.tr(),
                          subTitle: patient?.email ?? '',
                        ),
                        InformationText(
                          title: AppStrings.kGender.tr(),
                          subTitle: patient?.gender ?? '',
                          divider: false,
                        ),
                      ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
