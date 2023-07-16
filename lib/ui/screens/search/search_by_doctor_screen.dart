import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../components/components.dart';

class SearchByDoctorScreen extends StatelessWidget {
  const SearchByDoctorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.liteWight,
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(title: AppStrings.kSearch.tr()),
      body: EmptyCard(
        color: AppColors.transparent,
        verticalPadding: 0,
        verticalMargin: 1.h,
        horizontalPadding: 0,
        horizontalMargin: 4.w,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormFieldBuilder(
              hint: AppStrings.kSearchSpeciality.tr(),
              verticalMargin: 0,
              textInputAction: TextInputAction.done,
              onChange: (text) {
                generalController.searchByName(text);
              } /*  onTap: () {}*/,
              isEnabled: true,
              horizontalMargin: 0,
              maxLines: 1,
              width: 100.w,
              height: 7.5.h,
              padding: EdgeInsets.only(right: 2.5.w, left: 2.5.w, top: 5.h),
              borderRadius: 15,
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.gray,
              ),
              color: AppColors.white,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            TextBuilder(
              text: AppStrings.kResult.tr(),
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            Consumer<GeneralController>(
              builder: (cont, controller, child) {
                List<Doctor> doctorList =
                    controller.searchResultResponse?.doctors ?? [];
                List<Titles>? specializationList =
                    controller.searchResultResponse?.specialization ?? [];
                List<MedicalsCenter>? medicalCenterList =
                    controller.searchResultResponse?.medicalsCenters ?? [];

                return controller.isLoading
                    ? const LoadingWidget(
                        backgroundColor: AppColors.transparent,
                      )
                    : doctorList.isEmpty &&
                            specializationList.isEmpty &&
                            medicalCenterList.isEmpty
                        ? Center(child: Text(AppStrings.kNoDataFound.tr()))
                        : Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: specializationList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      Titles model = specializationList[index];
                                      return SearchCardWidget(
                                        name: model.name,
                                        icon: model.icon,
                                        trailingText: AppStrings.kSpeciality,
                                        specialOnTap: () {
                                          Provider.of<SearchResultController>(
                                                  context,
                                                  listen: false)
                                              .getDoctors(
                                            context,
                                            lat: controller.lat,
                                            lng: controller.lng,
                                          );

                                          Navigator.of(context).pushNamed(
                                              NameRoutes.kResultOfSearch);
                                        },
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: doctorList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      Doctor model = doctorList[index];
                                      return SearchCardWidget(
                                        specialOnTap: () {
                                          Provider.of<DoctorProfileController>(
                                                  context,
                                                  listen: false)
                                              .getDoctorProfile(context,
                                                  doctorId: model.id!);
                                          Provider.of<DoctorProfileController>(
                                                  context,
                                                  listen: false)
                                              .getDoctorOffers(context,
                                                  doctorId: model.id!);
                                          Navigator.of(context).pushNamed(
                                              NameRoutes.kDoctorScreen);
                                        },
                                        name: model.name,
                                        icon: model.image,
                                        trailingText: AppStrings.kDoctor,
                                      );
                                    },
                                  ),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: medicalCenterList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      MedicalsCenter model =
                                          medicalCenterList[index];
                                      return SearchCardWidget(
                                        specialOnTap: () {
                                          Provider.of<SearchResultController>(
                                                  context,
                                                  listen: false)
                                              .getDoctors(context,
                                                  lat: controller.lat,
                                                  lng: controller.lng,
                                                  medicalCenterId: model.id);

                                          Navigator.of(context).pushNamed(
                                              NameRoutes.kResultOfSearch);
                                        },
                                        name: model.name,
                                        icon: model.logo,
                                        trailingText: AppStrings.kMedicalCenter,
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
              },
            ),
          ],
        ),
      ),
    );
  }
}
