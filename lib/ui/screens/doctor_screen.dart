import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constants.dart';
import '../../data/models/response/response.dart';

class DoctorScreen extends StatelessWidget {
  const DoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DoctorProfileController>(
      builder: (BuildContext context, doctorController, Widget? child) {
        return Scaffold(
          appBar: const CustomAppBar(title: 'Specialties Name'),
          backgroundColor: AppColors.liteWight,
          bottomNavigationBar: EmptyCard(
            horizontalMargin: 0,
            verticalMargin: 0,
            verticalPadding: 1.h,
            height: 12.h,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25.0),
              topLeft: Radius.circular(25.0),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.green,
                      size: 12.5.sp,
                    ),
                    TextBuilder(
                      text: 'Available',
                      color: AppColors.blue,
                      size: AppFontSizes.kS2,
                      verticalPadding: 0.75.h,
                    ),
                    SizedBox(
                      width: 1.w,
                    ),
                    TextBuilder(
                      text: 'today',
                      color: AppColors.blue,
                      size: AppFontSizes.kS2,
                      verticalPadding: 0.75.h,
                      bold: true,
                    ),
                  ],
                ),
                ButtonBuilder(
                  title: 'Book appointment',
                  onPressed: () {},
                  width: 77.5.w,
                  height: 6.h,
                ),
              ],
            ),
          ),
          body: doctorController.isLoading
              ? const LoadingWidget(
                  backgroundColor: AppColors.transparent,
                )
              : Column(
                  children: [
                    SwitchButton(
                        choose: AppStrings.kClinic.tr(),
                        fTitle: AppStrings.kClinic.tr(),
                        sTitle: AppStrings.kOffers.tr(),
                        fBOnPressed: () {},
                        sBOnPressed: () {}),
                    Expanded(
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          DoctorWidget(
                              model: doctorController
                                  .doctorProfileResponse?.doctor),
                          EmptyCard(
                            color: Colors.transparent,
                            verticalPadding: 0,
                            horizontalPadding: 0,
                            verticalMargin: 0,
                            height: 6.25.h,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: doctorController
                                    .doctorProfileResponse?.places!.length,
                                itemBuilder: (context, index) {
                                  Places? placeModel = doctorController
                                      .doctorProfileResponse?.places![index];
                                  return ButtonBuilder(
                                    title: '${placeModel?.name} ',
                                    //  width: 25.w,
                                    height: 4.h,
                                    buttonColor: index == 0
                                        ? AppColors.blue
                                        : AppColors.transparent,
                                    titleStyle:
                                        AppStyles.kButtonTextStyle.copyWith(
                                      fontSize: AppFontSizes.kS3,
                                      color: index == 0
                                          ? AppColors.white
                                          : AppColors.blue,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 1.w),
                                    onPressed: () {},
                                  );
                                }),
                          ),
                          const MedicalCenterWidget(),
                          const ClinicWidget(),
                          const AddressWidget(),
                          const PatientsReviews(),
                        ],
                      )),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class AddressWidget extends StatelessWidget {
  const AddressWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
        verticalPadding: 1.5.h,
        verticalMargin: 1.h,
        height: 20.h,
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      AppAssets.kLocationIcon,
                      width: 4.w,
                      height: 4.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: 'Address',
                          color: AppColors.navyBlue,
                          bold: true,
                          verticalPadding: 0,
                          horizontalPadding: 2.w,
                        ),
                        const GeneralLine(),
                      ],
                    ),
                  ],
                ),
                TextBuilder(
                  text:
                      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrystandard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.',
                  verticalPadding: 1.h,
                  horizontalPadding: 0,
                  size: AppFontSizes.kS3,
                  maxLin: 6,
                  width: 47.w,
                  color: AppColors.darkGray,
                ),
              ],
            ),
            GeometricalAvatar(
              backgroundColor: AppColors.transparent,
              path: AppAssets.kMap,
              radius: 10.sp,
              width: 35.w,
              height: 22.5.h,
            )
          ],
        ));
  }
}

class PatientsReviews extends StatelessWidget {
  const PatientsReviews({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      verticalPadding: 1.5.h,
      verticalMargin: 1.5.h,
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: AppStrings.kPatReviews.tr(),
                    color: AppColors.navyBlue,
                    bold: true,
                    verticalPadding: 0,
                    horizontalPadding: 2.w,
                  ),
                  const GeneralLine(),
                ],
              ),
              const Spacer(),
              ButtonBuilder(
                title: 'Add review',
                titleStyle: AppStyles.kButtonTextStyle.copyWith(
                    fontSize: AppFontSizes.kS3, color: AppColors.white),
                prefixIcon: Icon(
                  Icons.add,
                  size: AppFontSizes.kS4,
                ),
                height: 4.5.h,
                width: 35.w,
                onPressed: () {},
              ),
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          ListView.builder(
              itemCount: 5,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return Review(
                  review: ReviewResponse(
                      name: 'Patient Name',
                      comment:
                          'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrystandard dummy text ev',
                      rating: 4,
                      time: '2 Hours ago'),
                );
              }),
        ],
      ),
    );
  }
}
