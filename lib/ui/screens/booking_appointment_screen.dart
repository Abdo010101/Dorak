import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../data/models/response/response.dart';
import '../components/components.dart';

class ReservationScreen extends StatelessWidget {
  ReservationScreen({Key? key}) : super(key: key);

  final List<Widget> daysOfWeekList = [];

  @override
  Widget build(BuildContext context) {
    var appointmentController =
        Provider.of<ReservationAppointmentController>(context, listen: false);
    DoctorProfileController doctorProfileController =
        Provider.of<DoctorProfileController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          AppStrings.kBookAppointment.tr(),
          style: const TextStyle(color: AppColors.navyBlue),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            appointmentController.resetController();
            Navigator.pop(context);
          },
          color: AppColors.black,
        ),
      ),
      body: Consumer<ReservationAppointmentController>(
        builder: (context, controller, child) {
          return WillPopScope(
            onWillPop: () {
              controller.resetController();
              Navigator.pop(context);
              return Future.value(false);
            },
            child: Form(
              key: controller.formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1.0.h,
                    ),
                    EmptyCard(
                      radius: 15.0,
                      verticalMargin: 0.5.h,
                      horizontalMargin: 5.w,
                      verticalPadding: 1.h,
                      width: 90.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextBuilder(
                            text:
                                '${doctorProfileController.selectedPlace?.name}',
                            size: AppFontSizes.kS4,
                            color: AppColors.navyBlue,
                            horizontalPadding: 0.5.w,
                            bold: true,
                            verticalPadding: 0,
                          ),
                          const GeneralLine(),
                          EmptyCard(
                            horizontalMargin: 0,
                            verticalMargin: 1.h,
                            verticalPadding: 0,
                            horizontalPadding: 1.5.w,
                            radius: 50,
                            width: 100.w,
                            height: 4.h,
                            color: AppColors.liteBlue2,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(AppAssets.kLocationIcon),
                                TextBuilder(
                                  width: 30.w,
                                  text: doctorProfileController
                                          .selectedPlace?.shortAddress ??
                                      '',
                                  size: AppFontSizes.kS2,
                                  color: AppColors.navyBlue,
                                  verticalPadding: 0,
                                  horizontalPadding: 2.w,
                                ),
                                VerticalDividerBuilder(
                                  dividerColor: AppColors.white,
                                  width: 0.25.w,
                                  height: 3.h,
                                  horizontalMargin: 2.5.w,
                                ),
                                SvgPicture.asset(AppAssets.kMoneyIcon),
                                TextBuilder(
                                  width: 30.w,
                                  text:
                                      "${double.parse(doctorProfileController.selectedPlace?.examinationPrice ?? '0').toStringAsFixed(1)} ${AppStrings.kCurrency.tr()}",
                                  size: AppFontSizes.kS2,
                                  color: AppColors.navyBlue,
                                  verticalPadding: 0,
                                  horizontalPadding: 2.w,
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 9.sp,
                                    color: AppColors.lightGrey2,
                                  ),
                                  TextBuilder(
                                      text:
                                          '${AppStrings.kWaitingTime.tr()} ${doctorProfileController.selectedPlace?.examinationDuration} ${AppStrings.kMin.tr()}',
                                      size: AppFontSizes.kS2,
                                      verticalPadding: 0,
                                      horizontalPadding: 1.w,
                                      color: AppColors.lightGrey2),
                                ],
                              ),
                              /*      const Spacer(),
                              EmptyCard(
                                verticalPadding: 0,
                                verticalMargin: 0.4.h,
                                horizontalPadding: 0,
                                horizontalMargin: 0,
                                height: 27.5.sp,
                                width: 27.5.sp,
                                radius: 50,
                                color: AppColors.lightPurple,
                                child: Image.asset(AppAssets.kCallIcon),
                              ),*/
                            ],
                          ),
                        ],
                      ),
                    ),
                    const PickUpTimeBuilder(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: EmptyCard(
        color: AppColors.transparent,
        child: ButtonBuilder(
          margin: EdgeInsets.symmetric(vertical: 1.5.h, horizontal: 8.0.w),
          title: AppStrings.kSubmit.tr(),
          onPressed: () => appointmentController.makeReservations(context,
              doctorId:
                  doctorProfileController.doctorProfileResponse?.doctor?.id),
        ),
      ),
    );
  }
}

class DayWidget extends StatelessWidget {
  const DayWidget(
      {Key? key,
      required this.dayName,
      required this.dayNum,
      required this.isSelected,
      required this.isAvailable,
      required this.onTap})
      : super(key: key);
  final String dayName;
  final String dayNum;
  final bool isAvailable;
  final VoidCallback? onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: !isAvailable
                ? AppColors.lightGrey4
                : isSelected
                    ? AppColors.blue
                    : AppColors.transparent,
            borderRadius: BorderRadius.circular(15.sp)),
        padding: EdgeInsets.symmetric(
            vertical: !isAvailable
                ? 3.0.w
                : isSelected
                    ? 2.0.w
                    : 1.0.w,
            horizontal: !isAvailable
                ? 0.5.w
                : isSelected
                    ? 2.0.w
                    : 1.0.w),
        child: Column(children: [
          Text(
            dayName,
            style: TextStyle(
                fontSize: 10.sp,
                color: !isAvailable
                    ? AppColors.white.withOpacity(0.5)
                    : isSelected
                        ? AppColors.white
                        : AppColors.grey),
          ),
          Text(
            dayNum,
            style: TextStyle(
                height: 0.3.h,
                fontSize: 9.sp,
                color: !isAvailable
                    ? AppColors.white.withOpacity(0.5)
                    : isSelected
                        ? AppColors.white
                        : AppColors.grey),
          )
        ]),
      ),
    );
  }
}

class PickUpTimeBuilder extends StatelessWidget {
  const PickUpTimeBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservationAppointmentController>(
        builder: (context, controller, child) {
      return controller.isLoading
          ? const Center(
              child: LoadingWidget(backgroundColor: AppColors.transparent))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: TextBuilder(
                    text: AppStrings.kPickupDate.tr(),
                    bold: true,
                    color: AppColors.black,
                    size: 10.sp,
                  ),
                ),
                Container(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 5.0.w),
                  height: 16.h,
                  child: ListView.separated(
                    separatorBuilder: (_, context) => SizedBox(
                      width: 2.0.w,
                    ),
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (_, index) {
                      Schedules schedule =
                          controller.availableSchedulesList[index];
                      return EmptyCard(
                          horizontalMargin: 0.0,
                          verticalMargin: 0.0,
                          verticalPadding: 1.0.h,
                          height: 26.0.h,
                          width: 85.w,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    index == 0
                                        ? AppStrings.kThisWeek.tr()
                                        : index == 1
                                            ? AppStrings.kNextWeek.tr()
                                            : '${schedule.interval}',
                                    style: TextStyle(
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  index < 2
                                      ? Text(
                                          '${schedule.interval}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.grey,
                                              fontSize: AppFontSizes.kS1),
                                        )
                                      : const SizedBox()
                                ],
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: schedule.week!.map((e) {
                                  return DayWidget(
                                    dayName: '${e.shortName}',
                                    dayNum: '${e.number}',
                                    isAvailable: e.status == 1,
                                    onTap: () {
                                      if (e.status == 1) {
                                        controller.onDaySelectedChange(e);
                                      }
                                    },
                                    isSelected:
                                        controller.selectedDayId == e.date,
                                  );
                                }).toList(),
                              )
                            ],
                          ));
                    },
                    itemCount: controller.availableSchedulesList.length,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.0.w),
                  child: TextBuilder(
                    text: AppStrings.kPickupTime.tr(),
                    bold: true,
                    color: AppColors.black,
                    size: 10.sp,
                  ),
                ),
                controller.timeSlotsList.isEmpty
                    ? Center(
                        child: Text(
                          controller.selectedDayId == null
                              ? AppStrings.kSelectReservationDate.tr()
                              : AppStrings.kNotAvailableDay.tr(),
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsetsDirectional.only(start: 5.0.w),
                        child: Wrap(
                          children: controller.timeSlotsList.map((e) {
                            bool isSelected = controller.selectedTime == e.time;
                            return GestureDetector(
                              onTap: () {
                                if (e.available!) {
                                  controller.onTimeSelectedChange(e.time);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: !e.available!
                                      ? AppColors.lightGrey4
                                      : isSelected
                                          ? AppColors.blue
                                          : AppColors.white,
                                ),
                                width: 20.w,
                                margin: EdgeInsets.symmetric(
                                    vertical: 1.h, horizontal: 1.w),
                                padding: EdgeInsets.all(2.w),
                                child: Center(
                                  child: Text(
                                    "${e.time}",
                                    style: TextStyle(
                                        fontSize: 9.sp,
                                        color: !e.available!
                                            ? AppColors.white.withOpacity(0.5)
                                            : isSelected
                                                ? AppColors.white
                                                : AppColors.black),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ],
            );
    });
  }
}
