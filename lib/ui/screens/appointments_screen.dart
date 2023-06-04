import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppointmentsController controller =
        Provider.of<AppointmentsController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leading: TextBuilder(
          text: AppStrings.kAppointments.tr(),
          color: AppColors.navyBlue,
          verticalPadding: 1.h,
          height: 2,
          horizontalPadding: 7.5.w,
          size: 12.5.sp,
          bold: true,
        ),
        leadingWidth: 50.w,
      ),
      backgroundColor: AppColors.liteWight,
      body: EmptyCard(
        verticalPadding: 0,
        verticalMargin: 0,
        horizontalMargin: 0,
        horizontalPadding: 4.w,
        color: AppColors.transparent,
        child: Consumer<AppointmentsController>(
          builder: (context, controller, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SwitchButton(
                  choose: controller.appointmentDate.tr(),
                  fTitle: AppStrings.kUpcoming.tr(),
                  sTitle: AppStrings.kPast.tr(),
                  fBOnPressed: () =>
                      controller.changeAppointmentDate(AppStrings.kUpcoming),
                  sBOnPressed: () =>
                      controller.changeAppointmentDate(AppStrings.kPast),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: controller.appointmentsList.length,
                          itemBuilder: (context, index) {
                            return AppointmentWidget(
                              appointment: controller.appointmentsList[index],
                              declineAppointment: () =>
                                  controller.declineAppointment(index),
                            );
                          }),
                      controller.isLoading
                          ? const LoadingWidget(
                              backgroundColor: AppColors.transparent,
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
