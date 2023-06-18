import 'package:dorakpattient/data/models/response/response.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../../routes/dorak_routes.dart';
import '../components/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) {
      Provider.of<HomeController>(context, listen: false).getHomeData(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MainScreenController mainController =
        Provider.of<MainScreenController>(context, listen: false);
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
                  context.read<NotificationController>().getNotifications();
                  Navigator.of(context)
                      .pushNamed(NameRoutes.kNotificationScreen);
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
            padding: EdgeInsetsDirectional.symmetric(
                vertical: 1.1.h, horizontal: 5.w),
            child: Image.asset(
              AppAssets.kDorakIcon,
              fit: BoxFit.fill,
            ),
          ),
        ),
        backgroundColor: AppColors.blue,
        body: Consumer<HomeController>(
          builder: (context, controller, child) {
            return RefreshIndicator(
              onRefresh: () async {
                Provider.of<HomeController>(context, listen: false)
                    .getHomeData(context);
              },
              child: EmptyCard(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25)),
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
                        text: AppStrings.kBookAppointment.tr(),
                        color: AppColors.navyBlue,
                        size: AppFontSizes.kS5,
                        verticalPadding: 1.h,
                        bold: true,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(
                              context, NameRoutes.kSearchForSpecialtiesScreen);
                        },
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
                                text: AppStrings.kFindDoctor.tr(),
                                verticalPadding: 0,
                                horizontalPadding: 3.w,
                                size: AppFontSizes.kS3,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SectionLabel(
                        title: AppStrings.kBestDoctors.tr(),
                        seeAllPressed: () {
                          Provider.of<HomeController>(context, listen: false)
                              .getBestDoctors(
                            context,
                          );
                          Navigator.pushNamed(
                              context, NameRoutes.kBestDoctorsScreen);
                        },
                      ),
                      controller.isLoading
                          ? const LoadingWidget(
                              backgroundColor: AppColors.transparent,
                            )
                          : controller.bestDoctorsList.isEmpty
                              ? Center(
                                  child:
                                      Text(AppStrings.kNoAvailableDoctors.tr()),
                                )
                              : Container(
                                  margin:
                                      EdgeInsets.symmetric(vertical: 0.75.h),
                                  height: 24.h,
                                  child: ListView.separated(
                                    itemCount: controller
                                        .homeData!.bestDoctors!.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (cont, index) {
                                      Doctor? doctorModel = controller
                                          .homeData?.bestDoctors?[index];
                                      return DoctorWidget(
                                        home: true,
                                        model: doctorModel,
                                        cardOnTab: () {
                                          Provider.of<DoctorProfileController>(
                                                  context,
                                                  listen: false)
                                              .getDoctorProfile(context,
                                                  doctorId: doctorModel!.id!);
                                          Provider.of<DoctorProfileController>(
                                                  context,
                                                  listen: false)
                                              .getDoctorOffers(context,
                                                  doctorId: doctorModel.id!);
                                          Navigator.of(context).pushNamed(
                                              NameRoutes.kDoctorScreen);
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
                                      return SizedBox(
                                        width: 3.w,
                                      );
                                    },
                                  ),
                                ),
                      SectionLabel(
                        title: AppStrings.kOffers.tr(),
                        seeAllPressed: () {
                          mainController.onBottomSheetChanged(2, context);
                        },
                      ),
                      controller.isLoading
                          ? const LoadingWidget(
                              backgroundColor: AppColors.transparent,
                            )
                          : controller.latestOfferList.isEmpty
                              ? Center(
                                  child:
                                      Text(AppStrings.kNoAvailableOffers.tr()),
                                )
                              : Container(
                                  margin: EdgeInsets.symmetric(vertical: 1.h),
                                  height: 32.h,
                                  child: ListView.separated(
                                    itemCount:
                                        controller.latestOfferList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var offerModel =
                                          controller.latestOfferList[index];
                                      return OfferWidget(
                                        offerTittle: offerModel.title,
                                        offerSubTittle:
                                            '${offerModel.description}',
                                        offerPic: offerModel.mainPic,
                                        priceBefore: offerModel.priceBefore,
                                        priceAfter: offerModel.priceAfter,
                                        doctorName: offerModel.doctor!.name,
                                        docPic: offerModel.doctor!.image,
                                        rate: offerModel.doctor!.rate,
                                        onPressed: () {
                                          showBottomSheet(
                                              context: context,
                                              backgroundColor:
                                                  Colors.transparent,
                                              builder: (context) {
                                                return OfferDetailsBottomSheet(
                                                  offer: offerModel,
                                                );
                                              });
                                        },
                                      );
                                    },
                                    separatorBuilder:
                                        (BuildContext context, int index) {
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
                        title: AppStrings.kMyAppointment.tr(),
                        seeAllPressed: () {
                          mainController.onBottomSheetChanged(1, context);
                        },
                      ),
                      controller.isLoading
                          ? const LoadingWidget(
                              backgroundColor: AppColors.transparent,
                            )
                          : controller.appointmentList.isEmpty
                              ? Center(
                                  child: Text(
                                      AppStrings.kNoAvailableAppointment.tr()),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: controller.appointmentList.length,
                                  itemBuilder: (context, index) {
                                    return AppointmentWidget(
                                      appointment:
                                          controller.appointmentList[index],
                                      declineAppointment: () =>
                                          controller.declineAppointment(index),
                                    );
                                  },
                                ),
                      SizedBox(
                        height: 1.h,
                      ),
                      /*     SectionLabel(
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
                      ),*/
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }
}
