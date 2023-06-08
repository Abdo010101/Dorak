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
        Places? place = doctorController.selectedPlace;
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
                Visibility(
                  visible: place != null && place.reservationStatus!,
                  child: Row(
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
                ),
                ButtonBuilder(
                  title: AppStrings.kBookAppointment.tr(),
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
                                  bool isSelected =
                                      doctorController.currentPlaceSelected ==
                                          index;
                                  Places placeModel = doctorController
                                      .doctorProfileResponse!.places![index];
                                  return ButtonBuilder(
                                    title: '${placeModel.name} ',
                                    //  width: 25.w,
                                    height: 4.h,
                                    buttonColor: isSelected
                                        ? AppColors.blue
                                        : AppColors.transparent,
                                    titleStyle:
                                        AppStyles.kButtonTextStyle.copyWith(
                                      fontSize: AppFontSizes.kS3,
                                      color: isSelected
                                          ? AppColors.white
                                          : AppColors.blue,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        vertical: 1.h, horizontal: 1.w),
                                    onPressed: () {
                                      doctorController
                                          .onChangedSelectPlace(index);
                                    },
                                  );
                                }),
                          ),
                          doctorController.currentPlaceSelected == 0
                              ? ClinicWidget(place: place)
                              : MedicalCenterWidget(placeModel: place),
                          AddressWidget(
                              address: place?.shortAddress,
                              fullAddress: place?.longAddress),
                          PatientsReviews(
                              rateList: doctorController
                                  .doctorProfileResponse?.ratings),
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
  const AddressWidget(
      {Key? key, this.address, this.fullAddress, this.lat, this.lng})
      : super(key: key);
  final String? address;
  final String? fullAddress;
  final String? lat;
  final String? lng;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
        verticalPadding: 1.5.h,
        verticalMargin: 1.h,
        height: 20.h,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
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
                            text: AppStrings.kAddress.tr(),
                            color: AppColors.navyBlue,
                            size: 10.sp,
                            bold: true,
                            verticalPadding: 0,
                            horizontalPadding: 2.w,
                          ),
                          const GeneralLine(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 1.0.h,
                  ),
                  TextBuilder(
                    text: '$fullAddress',
                    verticalPadding: 1.h,
                    horizontalPadding: 0,
                    size: 10.sp,
                    maxLin: 6,
                    width: 47.w,
                    color: AppColors.darkGray,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: GeometricalAvatar(
                backgroundColor: AppColors.transparent,
                path: AppAssets.kMap,
                radius: 10.sp,
                width: 35.w,
                height: 22.5.h,
              ),
            )
          ],
        ));
  }
}

class PatientsReviews extends StatelessWidget {
  const PatientsReviews({Key? key, this.rateList}) : super(key: key);
  final List<Ratings>? rateList;
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
              itemCount: rateList?.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                Ratings rateModel = rateList![index];
                return Review(
                  review: ReviewResponse(
                      name: '${rateModel.name}',
                      comment: '${rateModel.comment}',
                      rating: rateModel.rating,
                      time: '${rateModel.time}'),
                );
              }),
        ],
      ),
    );
  }
}
