import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/response/response.dart';

class AppointmentsScreen extends StatelessWidget {
  const AppointmentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () async {
          Provider.of<AppointmentsController>(context, listen: false)
              .changeAppointmentDate(AppStrings.kUpcoming);
        },
        child: EmptyCard(
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
                    choose: controller.appointmentDate,
                    fTitle: AppStrings.kUpcoming,
                    sTitle: AppStrings.kPast,
                    fBOnPressed: () =>
                        controller.changeAppointmentDate(AppStrings.kUpcoming),
                    sBOnPressed: () =>
                        controller.changeAppointmentDate(AppStrings.kPast),
                  ),
                  Expanded(
                    child: /* controller.isLoading
                        ? const LoadingWidget(
                            backgroundColor: AppColors.transparent,
                          )
                        : controller.appointmentsList.isEmpty
                            ? NoDataWidget(
                                backgroundColor: Colors.transparent,
                                text: AppStrings.kNoAppointments.tr(),
                              )
                            :*/
                        PagedListView<int, AppointmentResponse>(
                      padding: EdgeInsets.zero,
                      pagingController: controller.pagingController!,
                      builderDelegate:
                          PagedChildBuilderDelegate<AppointmentResponse>(
                        itemBuilder: (context, item, index) {
                          return AppointmentWidget(
                            appointment: item,
                            declineAppointment: () =>
                                controller.declineAppointment(index),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
