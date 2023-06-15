import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../../routes/dorak_routes.dart';
import '../components.dart';

class AlreadyHaveAccountWidget extends StatelessWidget {
  const AlreadyHaveAccountWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Center(
      child: Padding(
        padding: EdgeInsets.only(bottom: 10.h, top: 2.h),
        child: RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 11.sp,
            ),
            children: [
              // TextSpan(
              //   text: AppStrings.kNotHaveAccount.tr(),
              //   style: const TextStyle(
              //     color: AppColors.black,
              //   ),
              // ),
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: GestureDetector(
                  onTap: () {
                    if (generalController.policy?.privacy == null ||
                        generalController.terms?.terms == null) {
                      generalController.getTermsAndPolicy();
                    }
                    Navigator.of(context).pushNamed(NameRoutes.kRegisterScreen);
                  },
                  child: TextBuilder(
                    color: AppColors.blue,
                    text: AppStrings.kSignUp.tr(),
                    size: 11.sp,
                    verticalPadding: 1.h,
                    horizontalPadding: 1.w,
                    bold: false,
                  ),
                ),
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.top,
                child: TextBuilder(
                  verticalPadding: 1.h,
                  horizontalPadding: 1.w,
                  text: AppStrings.kNotHaveAccount.tr(),
                  size: 11.sp,
                  bold: true,
                  color: AppColors.darkBlue.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
