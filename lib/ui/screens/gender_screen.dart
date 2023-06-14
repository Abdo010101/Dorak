import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.transparent,
        flexibleSpace: Image.asset(
          AppAssets.kMask,
          fit: BoxFit.cover,
        ),
        leading: const SizedBox(),
        actions: [
          const Spacer(),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              color: AppColors.white,
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.blue,
      body: EmptyCard(
        horizontalMargin: 0,
        verticalMargin: 0,
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25.0), topLeft: Radius.circular(25.0)),
        color: AppColors.liteWight,
        child:
            Consumer<RegisterController>(builder: (context, controller, child) {
          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: AppStrings.kWhichOne.tr(),
                    color: AppColors.navyBlue,
                    size: AppFontSizes.kS5,
                    verticalPadding: 1.h,
                  ),
                  TextBuilder(
                    text: AppStrings.kCustomizedExperience.tr(),
                    verticalPadding: 1.h,
                  ),
                  TextBuilder(
                    text: AppStrings.kKnowGender.tr(),
                    verticalPadding: 0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () =>
                            controller.choseGender(AppStrings.kGenderList[1]),
                        child: EmptyCard(
                          verticalPadding: 2.h,
                          horizontalMargin: 3.5.w,
                          horizontalPadding: 9.w,
                          color: controller.gender == AppStrings.kGenderList[1]
                              ? AppColors.navyBlue
                              : null,
                          child: Column(
                            children: [
                              SvgPicture.asset(AppAssets.kFemaleIcon),
                              TextBuilder(
                                text: AppStrings.kGenderList[1].tr(),
                                color: controller.gender ==
                                        AppStrings.kGenderList[1]
                                    ? AppColors.white
                                    : AppColors.navyBlue,
                                verticalPadding: 1.5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () =>
                            controller.choseGender(AppStrings.kGenderList[0]),
                        child: EmptyCard(
                          verticalPadding: 2.h,
                          horizontalMargin: 3.5.w,
                          horizontalPadding: 9.w,
                          color: controller.gender == AppStrings.kGenderList[0]
                              ? AppColors.navyBlue
                              : null,
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                AppAssets.kMaleIcon,
                              ),
                              TextBuilder(
                                text: AppStrings.kGenderList[0].tr(),
                                color: controller.gender ==
                                        AppStrings.kGenderList[0]
                                    ? AppColors.white
                                    : AppColors.navyBlue,
                                verticalPadding: 1.5.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  ButtonBuilder(
                    title: AppStrings.kContinue.tr(),
                    margin: EdgeInsets.symmetric(vertical: 2.5.h),
                    borderColor: AppColors.transparent,
                    onPressed: controller.gender == null
                        ? null
                        : () async {
                            await controller.completeData(
                                gender: controller.gender!);
                            Navigator.pushNamed(
                                context, NameRoutes.kSuccessScreen);
                          },
                  ),
                  // ButtonBuilder(
                  //   title: AppStrings.kSkip.tr(),
                  //   titleColor: AppColors.red,
                  //   buttonColor: AppColors.red.withOpacity(0.15),
                  //   borderColor: AppColors.transparent,
                  //   onPressed: () {
                  //     Navigator.pushNamed(context, NameRoutes.kRegisterScreen);
                  //   },
                  // ),
                ],
              ),
              controller.isLoading
                  ? const LoadingWidget(
                      backgroundColor: AppColors.transparent,
                    )
                  : const SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
