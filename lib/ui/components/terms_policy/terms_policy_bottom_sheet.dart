import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../components.dart';

class TermsAndPolicyBottomSheet extends StatelessWidget {
  const TermsAndPolicyBottomSheet({Key? key, required this.terms})
      : super(key: key);
  final bool terms;

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return BottomSheetBuilder(
      children: [
        generalController.isLoading
            ? const LoadingWidget(
                backgroundColor: AppColors.liteWight,
              )
            : Container(
                decoration: const BoxDecoration(
                    color: AppColors.liteWight,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25.0),
                        topLeft: Radius.circular(25.0))),
                padding: EdgeInsets.symmetric(vertical: 5.0.w),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextBuilder(
                        text: terms
                            ? AppStrings.kTermsService.tr()
                            : AppStrings.kPrivacyPolicy.tr(),
                        verticalPadding: 0,
                        color: AppColors.navyBlue,
                        size: AppFontSizes.kS4,
                      ),
                      EmptyCard(
                        width: 100.w,
                        horizontalMargin: 1.w,
                        child: TextBuilder(
                          align: TextAlign.center,
                          text:
                              "${terms ? generalController.terms?.terms : generalController.policy?.privacy}",
                          verticalPadding: 0.h,
                          size: AppFontSizes.kS3,
                          color: AppColors.lightGrey3,
                          bold: false,
                          maxLin: 25,
                        ),
                      ),
                      SizedBox(
                        height: 2.0.h,
                      ),
                      ButtonBuilder(
                        title: AppStrings.kBack.tr(),
                        borderColor: Colors.transparent,
                        buttonColor: AppColors.blue,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        width: 75.w,
                      )
                    ],
                  ),
                ),
              ),
      ],
    );
  }
}
