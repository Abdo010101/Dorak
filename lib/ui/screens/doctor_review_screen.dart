import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_star_rating_null_safety/smooth_star_rating_null_safety.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class DoctorReview extends StatelessWidget {
  const DoctorReview({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    DoctorProfileController doctorProfileControllerController =
        context.read<DoctorProfileController>();
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(title: AppStrings.kDoctorReview.tr()),
      body: Consumer<AppReviewController>(
        builder: (context, controller, child) {
          return Stack(
            children: [
              EmptyCard(
                child: Form(
                  key: controller.formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextBuilder(
                          text: AppStrings.kRatQuality.tr(),
                          color: AppColors.navyBlue,
                          size: AppFontSizes.kS5,
                          align: TextAlign.center,
                          maxLin: 3,
                        ),
                        SmoothStarRating(
                            allowHalfRating: false,
                            onRatingChanged: controller.changeRatting,
                            starCount: 5,
                            rating: controller.ratting,
                            size: 40.0,
                            color: AppColors.bOrange,
                            borderColor: AppColors.bOrange,
                            spacing: 1.w),
                        Visibility(
                          visible: controller.ratting == 0 &&
                              controller.rateController.text != '',
                          child: TextBuilder(
                            text: 'required'.tr(),
                            color: AppColors.bRed,
                            bold: false,
                          ),
                        ),
                        TextBuilder(
                          text: AppStrings.kRateComment.tr(),
                          color: AppColors.lightGrey2,
                          size: AppFontSizes.kS4,
                          align: TextAlign.center,
                          maxLin: 3,
                          bold: false,
                        ),
                        TextFormFieldBuilder(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.5.h, horizontal: 2.5.w),
                          borderRadius: 10,
                          hint: AppStrings.kNoteHint.tr(),
                          maxLines: 6,
                          hintSize: 10.sp,
                          controller: controller.rateController,
                          validator: Validators.compose([
                            Validators.required('required'.tr()),
                          ]),
                          textInputAction: TextInputAction.done,
                        ),
                        ButtonBuilder(
                          margin: EdgeInsets.symmetric(vertical: 2.5.h),
                          title: AppStrings.kSubmit.tr(),
                          onPressed: () async {
                            bool result = await controller.doctorRate(
                                context,
                                doctorProfileControllerController
                                    .doctorProfileResponse?.doctor?.id);
                            if (result == true) {
                              await doctorProfileControllerController
                                  .getDoctorProfile(context,
                                      doctorId:
                                          doctorProfileControllerController
                                              .doctorProfileResponse!
                                              .doctor!
                                              .id!);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              controller.isLoading
                  ? const Positioned(
                      child:
                          LoadingWidget(backgroundColor: AppColors.transparent))
                  : const SizedBox(),
            ],
          );
        },
      ),
    );
  }
}
