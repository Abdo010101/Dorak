import 'package:dorakpattient/controllers/home_controller.dart';
import 'package:dorakpattient/data/models/response/offer_response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class BestDoctorsScreen extends StatelessWidget {
  const BestDoctorsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(title: AppStrings.kBestDoctors.tr()),
      body: EmptyCard(
        color: AppColors.transparent,
        horizontalPadding: 0,
        verticalPadding: 0,
        verticalMargin: 0,
        child: Consumer<HomeController>(
          builder: (context, controller, child) {
              return PagedListView<int, Doctor>(
              padding: EdgeInsets.zero,
              pagingController: controller.pagingController!,
              builderDelegate:
              PagedChildBuilderDelegate<Doctor>(
                itemBuilder: (context, item, index) {
                  return    DoctorWidget(
                    home: true,
                    cardOnTab: () {
                      Provider.of<DoctorProfileController>(context,
                          listen: false)
                          .getDoctorProfile(context, doctorId: item.id!);
                      Provider.of<DoctorProfileController>(context,
                          listen: false)
                          .getDoctorOffers(context, doctorId: item.id!);

                      Navigator.of(context)
                          .pushNamed(NameRoutes.kDoctorScreen);
                    },
                    model: item,
                  );
                },
              ));}
            ),/*ListView.separated(
                    itemCount: doctorsList.length,
                    itemBuilder: (context, index) {
                      Doctor model = doctorsList[index];
                      return DoctorWidget(
                        home: true,
                        cardOnTab: () {
                          Provider.of<DoctorProfileController>(context,
                                  listen: false)
                              .getDoctorProfile(context, doctorId: model.id!);
                          Provider.of<DoctorProfileController>(context,
                                  listen: false)
                              .getDoctorOffers(context, doctorId: model.id!);

                          Navigator.of(context)
                              .pushNamed(NameRoutes.kDoctorScreen);
                        },
                        model: model,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 1.h,
                      );
                    },
                  );*/

      ),
    );
  }
}
