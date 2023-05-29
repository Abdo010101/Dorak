import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../components/components.dart';

class SearchForSpecialtiesScreen extends StatelessWidget {
  const SearchForSpecialtiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: const CustomAppBar(title: 'Specialties'),
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
              hint: 'Search for a speciality',
              verticalMargin: 0,
              horizontalMargin: 0,
              maxLines: 3,
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
              text: 'Most Popular Specialties',
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            Consumer<GeneralController>(
              builder: (cont, controller, child) {
                List<Titles> specialList =
                    controller.generalResponse?.mainSpecializations ?? [];
                return controller.isLoading
                    ? const LoadingWidget(
                        backgroundColor: AppColors.transparent,
                      )
                    : Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: specialList.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            Titles specialModel = specialList[index];
                            return SpecialtiesWidget(
                              specialModel: specialModel,
                              specialOnTap: () {
                                Navigator.pushNamed(
                                    context, NameRoutes.kSearchForCityScreen);
                              },
                            );
                          },
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
