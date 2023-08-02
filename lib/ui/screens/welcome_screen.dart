import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../routes/dorak_routes.dart';
import '../components/components.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return SafeArea(
      child: Container(
        color: AppColors.primary,
        padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 2.5.h),
        margin: EdgeInsets.symmetric(horizontal: 2.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ButtonBuilder(
              title: AppStrings.kSkip.tr(),
              titleStyle: AppStyles.kButtonTextStyle
                  .copyWith(color: AppColors.blue, fontSize: AppFontSizes.kS4),
              buttonColor: AppColors.transparent,
              borderColor: AppColors.transparent,
              width: 25.w,
              suffixIcon: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.blue,
              ),
              onPressed: () {
                context.read<MainScreenController>().currentIndex = 0;
                Navigator.pushNamed(context, NameRoutes.kHomeScreen);
              },
            ),
            SizedBox(
              height: 7.5.h,
            ),
            Image.asset(
              AppAssets.kWelcomeLogo,
              fit: BoxFit.fill,
              height: 30.h,
            ),
            Expanded(
              child: EmptyCard(
                verticalPadding: 2.h,
                verticalMargin: 0,
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      height: 6.h,
                      margin: EdgeInsets.symmetric(
                        horizontal: 1.5.w,
                      ),
                      color: AppColors.transparent,
                      child: Image.asset(
                        AppAssets.kWelcomeLogo2,
                        fit: BoxFit.fill,
                      ),
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    ButtonBuilder(
                      buttonColor: AppColors.blue,
                      borderColor: Colors.transparent,
                      title: AppStrings.kLogin.tr(),
                      height: 6.0.h,
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(NameRoutes.kLoginScreen);
                      },
                    ),
                    SizedBox(
                      height: 3.0.h,
                    ),
                    ButtonBuilder(
                      buttonColor: AppColors.liteBlueWO.withOpacity(0.2),
                      borderColor: Colors.transparent,
                      title: AppStrings.kRegister.tr(),
                      height: 6.0.h,
                      titleColor: AppColors.blue,
                      onPressed: () {
                        if (generalController.policy?.privacy == null ||
                            generalController.terms?.terms == null) {
                          generalController.getTermsAndPolicy();
                        }
                        Navigator.of(context)
                            .pushNamed(NameRoutes.kRegisterScreen);
                      },
                    ),
                    SizedBox(
                      height: 2.0.h,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
