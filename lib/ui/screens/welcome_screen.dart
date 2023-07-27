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
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: AppColors.primary,
          padding: EdgeInsets.only(left: 3.0.w, right: 3.0.w, top: 10.0.h),
          margin: EdgeInsets.symmetric(horizontal: 2.0.w),
          child: Column(
            children: [
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
                      /*   TextBuilder(
                        align: TextAlign.center,
                        text: AppStrings.kWelcomeTitle.tr(),
                        maxLin: 2,
                        color: AppColors.navyBlue,
                        bold: true,
                      ),*/
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
                        // titleStyle: const TextStyle(
                        //     color: AppColors.blue, fontWeight: FontWeight.bold),
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
      ),
    );
  }
}
