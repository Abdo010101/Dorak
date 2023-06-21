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
      appBar: const CustomAppBar(title: 'Cities'),
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
              hint: 'Search for a city',
              verticalMargin: 0,
              horizontalMargin: 0,
              textInputAction: TextInputAction.done,
              onChange: (text) {
                generalController.areaSearch(text);
              },
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
              text: 'Choose the city',
              color: AppColors.navyBlue,
              bold: true,
              verticalPadding: 1.5.h,
              horizontalPadding: 0,
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
                                      .getDoctors(
                                          cityId: controller.cityId,
                                          lat: controller.lat,
                                          lng: controller.lng,
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
