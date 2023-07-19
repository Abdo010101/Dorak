import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:dorakpattient/utis/util.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../data/models/response/response.dart';

class AppointmentWidget extends StatelessWidget {
  const AppointmentWidget({Key? key, this.appointment, this.declineAppointment})
      : super(key: key);
  final AppointmentResponse? appointment;
  final Function()? declineAppointment;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
      horizontalMargin: 0,
      verticalMargin: 1.h,
      verticalPadding: 1.5.h,
      color: AppColors.white,
      child: Column(
        children: [
          Stack(
            children: [
              EmptyCard(
                horizontalMargin: 0,
                verticalMargin: 0,
                verticalPadding: 0.5.h,
                horizontalPadding: 2.w,
                height: 9.h,
                color: AppColors.liteWight2,
                child: Row(
                  children: [
                    Container(
                      height: 40.sp,
                      width: 40.sp,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              appointment?.status == AppStatus.pending.name
                                  ? AppColors.orange.withOpacity(0.75)
                                  : appointment?.status ==
                                          AppStatus.confirmed.name
                                      ? AppColors.bGreen.withOpacity(0.75)
                                      : AppColors.lightRed.withOpacity(0.75),
                              appointment?.status == AppStatus.pending.name
                                  ? AppColors.orange
                                  : appointment?.status ==
                                          AppStatus.confirmed.name
                                      ? AppColors.bGreen
                                      : AppColors.lightRed,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          shape: BoxShape.circle),
                      padding: EdgeInsets.all(5.sp),
                      child: Center(
                        child: Text(
                          '${appointment?.day} \n ${appointment?.month}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: AppColors.white,
                              fontSize: AppFontSizes.kS3),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 2.0.h,
                        ),
                        TextBuilder(
                          text: appointment?.mainSpecialization,
                          verticalPadding: 0.0,
                          horizontalPadding: 2.w,
                          size: AppFontSizes.kS4,
                          color: AppColors.navyBlue,
                        ),
                        TextBuilder(
                          text: appointment?.date,
                          verticalPadding: 0.5.h,
                          horizontalPadding: 2.w,
                          size: AppFontSizes.kS3,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              PositionedDirectional(
                top: 0,
                end: 0,
                child: Container(
                  width: 25.w,
                  // height: 4.h,
                  padding:
                      EdgeInsets.symmetric(horizontal: 1.5.w, vertical: 0.4.h),
                  decoration: BoxDecoration(
                    color: appointment?.status == AppStatus.pending.name
                        ? AppColors.orange
                        : appointment?.status == AppStatus.confirmed.name
                            ? AppColors.bGreen
                            : AppColors.lightRed,
                    borderRadius: const BorderRadiusDirectional.only(
                        bottomStart: Radius.circular(15),
                        topEnd: Radius.circular(15)),
                  ),
                  child: Center(
                    child: Text(
                      appointment?.status == AppStatus.pending.name
                          ? AppStrings.kPending.tr()
                          : appointment?.status == AppStatus.confirmed.name
                              ? AppStrings.kConfirmed.tr()
                              : AppStrings.kCanceled.tr(),
                      style: const TextStyle(color: AppColors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 1.5.h,
          ),
          Row(
            children: [
              GeometricalAvatar(
                url: appointment?.image,
                radius: 40.sp,
                margin: EdgeInsetsDirectional.only(end: 2.w),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: appointment?.name,
                    size: AppFontSizes.kS4,
                    color: AppColors.navyBlue,
                    horizontalPadding: 0.5.w,
                    verticalPadding: 0,
                  ),
                  Row(
                    children: [
                      Util.isNumeric(appointment?.rate)
                          ? RatingBarWidget(
                              initialRating: double.parse(appointment!.rate!),
                              itemSize: 10.sp,
                            )
                          : const SizedBox(),
                      TextBuilder(
                        text: appointment?.rate,
                        verticalPadding: 0,
                        horizontalPadding: 0.5.w,
                        color: AppColors.navyBlue,
                        size: AppFontSizes.kS2,
                      )
                    ],
                  )
                ],
              ),
              const Spacer(),
              appointment?.status != AppStatus.pending.name
                  ? ButtonBuilder(
                      height: 3.25.h,
                      width: 25.w,
                      title: AppStrings.kCall.tr(),
                      titleStyle: TextStyle(fontSize: AppFontSizes.kS3),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.25.w),
                        child: Icon(
                          Icons.call,
                          size: AppFontSizes.kS4,
                        ),
                      ),
                      onPressed: () => Util.openCall(appointment?.phone),
                    )
                  : const SizedBox(),
            ],
          ),
          appointment?.status == AppStatus.pending.name
              ? DividerLogin(
                  height: 0.5.h,
                  thickness: 0.225.h,
                  dividerColor: AppColors.lightGrey2,
                )
              : const SizedBox(),
          appointment?.status == AppStatus.pending.name
              ? Row(
                  children: [
                    ButtonBuilder(
                      height: 5.h,
                      title: AppStrings.kDecline.tr(),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 1.w),
                        child: const Icon(
                          Icons.cancel_outlined,
                          color: AppColors.error,
                        ),
                      ),
                      titleStyle: TextStyle(
                          color: AppColors.error, fontSize: AppFontSizes.kS4),
                      buttonColor: AppColors.transparent,
                      borderColor: AppColors.transparent,
                      onPressed: () => Util.confirmDeletionDialog(context,
                          cancelTab: () => Navigator.pop(context),
                          confirmTab: () {
                            Navigator.pop(context);
                            declineAppointment!();
                          }),
                    ),
                    const Spacer(),
                    ButtonBuilder(
                      height: 3.25.h,
                      width: 25.w,
                      title: AppStrings.kCall.tr(),
                      titleStyle: TextStyle(fontSize: AppFontSizes.kS3),
                      prefixIcon: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.25.w),
                        child: Icon(
                          Icons.call,
                          size: AppFontSizes.kS4,
                        ),
                      ),
                      onPressed: () => Util.openCall(appointment?.phone),
                    ),
                  ],
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}
