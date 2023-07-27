import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/data/models/response/response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../components/components.dart';

class SearchForSpecialtiesScreen extends StatelessWidget {
  const SearchForSpecialtiesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(title: AppStrings.kMainSpecialties.tr()),
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
              hintSize: 10.sp,
              verticalMargin: 0,
              textInputAction: TextInputAction.done,
              /*onChange: (text) {
                generalController.search(text);
              },*/
              onTap: () {
                Navigator.of(context).pushNamed(NameRoutes.kSearchDoctorScreen);
              },
              isEnabled: false,
              horizontalMargin: 0,
              maxLines: 1,
              width: 100.w,
              height: 7.5.h,
              padding: EdgeInsets.only(right: 2.5.w, left: 2.5.w, top: 5.h),
              borderRadius: 15,
              borderColor: AppColors.transparent,
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Icon(
                  Icons.search,
                  color: AppColors.gray,
                  size: 15.sp,
                ),
              ),
              color: AppColors.white,
            ),
            SizedBox(
              height: 0.5.h,
            ),
            TextBuilder(
              text: AppStrings.kPopularSpecialties.tr(),
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            Consumer<GeneralController>(
              builder: (cont, controller, child) {
                List<Titles> specialList = controller.specializationList;
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
                                    controller
                                        .getSubSpeciality(specialModel.id!);

                                    Navigator.pushNamed(
                                        context,
                                        NameRoutes
                                            .kSearchForSubSpecialtiesScreen);
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
