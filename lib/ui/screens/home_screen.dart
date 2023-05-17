import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../routes/dorak_routes.dart';
import '../components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.transparent,
        actions: [
          Padding(
            padding: EdgeInsetsDirectional.only(end: 4.0.w),
            child: IconButton(
              onPressed: () {
                // context.read<NotificationController>().getNotifications();
                Navigator.of(context).pushNamed(NameRoutes.kNotificationScreen);
              },
              icon: Image.asset(
                AppAssets.kNotificationIcon,
                width: 6.0.w,
              ),
            ),
          )
        ],
        flexibleSpace: Image.asset(
          AppAssets.kMask,
          fit: BoxFit.cover,
        ),
        leading: Container(
          height: 6.h,
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 1.1.h, horizontal: 5.w),
          child: Image.asset(
            AppAssets.kDorakIcon,
            fit: BoxFit.fill,
          ),
        ),
      ),
      backgroundColor: AppColors.blue,
      body: EmptyCard(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(25), topLeft: Radius.circular(25)),
        color: AppColors.liteWight,
        verticalMargin: 0,
        verticalPadding: 0,
        horizontalMargin: 0,
        horizontalPadding: 5.w,
        radius: 25,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.5.h,
              ),
              TextBuilder(
                text: 'Book Clinic Appointment',
                color: AppColors.navyBlue,
                size: AppFontSizes.kS5,
                verticalPadding: 1.h,
                bold: true,
              ),
              InkWell(
                onTap: () => Navigator.pushNamed(
                    context, NameRoutes.kSearchForSpecialtiesScreen),
                child: EmptyCard(
                  verticalPadding: 0.25.h,
                  verticalMargin: 1.h,
                  horizontalMargin: 0,
                  width: 100.w,
                  height: 6.5.h,
                  color: AppColors.white,
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search,
                        color: AppColors.gray,
                      ),
                      TextBuilder(
                        text: 'Find a doctor or speciality',
                        verticalPadding: 0,
                        horizontalPadding: 3.w,
                        size: AppFontSizes.kS3,
                      ),
                    ],
                  ),
                ),
              ),
              SectionLabel(
                title: 'Best Doctors',
                seeAllPressed: () {},
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 0.75.h),
                height: 28.h,
                child: ListView.separated(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const DoctorWidget(
                      home: true,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 3.w,
                    );
                  },
                ),
              ),
              SectionLabel(
                title: 'Nearest Medical Center ',
                seeAllPressed: () {},
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 1.h),
                height: 20.h,
                child: ListView.separated(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return const MedicalCenterWidget(
                      home: true,
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      width: 3.w,
                    );
                  },
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              SectionLabel(
                title: 'My Appointment',
                seeAllPressed: () {},
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return const AppointmentWidget();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
