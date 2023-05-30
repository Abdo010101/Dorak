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
    final controller = Provider.of<PatientProfileController>(context);

    return Scaffold(
      appBar: CustomAppBar(
        title: 'My profile',
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
                            padding: EdgeInsets.symmetric(horizontal: 0.25.w),
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
  }
}
