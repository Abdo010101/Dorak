import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../../data/models/response/response.dart';
import '../../components/components.dart';

class SearchForCityScreen extends StatelessWidget {
  const SearchForCityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    GeneralController generalController =
        Provider.of<GeneralController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: CustomAppBar(title: AppStrings.kChooseCity.tr()),
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
              hint: AppStrings.kSearchForCity.tr(),
              hintSize: 10.sp,
              verticalMargin: 0,
              horizontalMargin: 0,
              textInputAction: TextInputAction.done,
              onChange: (text) {
                generalController.citySearch(text);
              },
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
              text: AppStrings.kChooseCity.tr(),
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
            ),
            CityWidget(
              cityName: AppStrings.kAll.tr(),
              specialOnTap: () async {
                Provider.of<SearchResultController>(context, listen: false)
                    .prams = {};
                Provider.of<SearchResultController>(context, listen: false)
                    .getDoctors(context,
                        areaId: generalController.areaId,
                        specializationId: generalController.specializationId);

                Navigator.of(context).pushNamed(NameRoutes.kResultOfSearch);
              },
              color: AppColors.blue,
              bold: true,
            ),
            Consumer<GeneralController>(builder: (cont, controller, child) {
              List<Titles> cityList = controller.citiesList;
              return controller.isLoading
                  ? const LoadingWidget(
                      backgroundColor: AppColors.transparent,
                    )
                  : cityList.isEmpty
                      ? NoDataWidget(
                          backgroundColor: Colors.transparent,
                          text: AppStrings.kNoDataFound.tr(),
                        )
                      : Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: cityList.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              Titles cityModel = cityList[index];
                              return CityWidget(
                                cityName: '${cityModel.name}',
                                specialOnTap: () {
                                  controller.onSelectedCity(cityModel.id!);
                                  Provider.of<SearchResultController>(context,
                                          listen: false)
                                      .prams = {};
                                  Provider.of<SearchResultController>(context,
                                          listen: false)
                                      .getDoctors(context,
                                          cityId: controller.cityId,
                                          specializationId:
                                              controller.specializationId);

                                  Navigator.of(context)
                                      .pushNamed(NameRoutes.kResultOfSearch);
                                },
                              );
                            },
                          ),
                        );
            })
          ],
        ),
      ),
    );
  }
}
