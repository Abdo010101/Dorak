import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../components/components.dart';

class SearchForSubSpecialtiesScreen extends StatelessWidget {
  const SearchForSubSpecialtiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(title: AppStrings.kSubSpecialties.tr()),
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
              hint: AppStrings.kSearchSubSpeciality.tr(),
              verticalMargin: 0,
              textInputAction: TextInputAction.done,
              onChange: (text) {
                generalController.searchSubSpecialization(text);
              },
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
              text: AppStrings.kSubSpecialties.tr(),
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            CityWidget(
              cityName: AppStrings.kAll.tr(),
              specialOnTap: () async {
                generalController.onSpecializationChange(
                  generalController.specializationId!,
                  AppStrings.kAllSubSpecializations.tr(),
                );
                Navigator.pushNamed(context, NameRoutes.kSearchForAreaScreen);
              },
              color: AppColors.blue,
              bold: true,
            ),
            Consumer<GeneralController>(
              builder: (cont, controller, child) {
                List<Titles> specialList = controller.subSpecializationList;
                return controller.isLoading
                    ? const LoadingWidget(
                        backgroundColor: AppColors.transparent,
                      )
                    : specialList.isEmpty
                        ? Center(child: Text(AppStrings.kNoDataFound.tr()))
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
                                    controller.onSpecializationChange(
                                        specialModel.id!, specialModel.name!);
                                    Navigator.pushNamed(context,
                                        NameRoutes.kSearchForAreaScreen);
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
