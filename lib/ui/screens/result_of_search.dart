import 'package:dorakpattient/data/models/response/offer_response.dart';
import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../../controllers/controllers.dart';
import '../components/components.dart';

class ResultOfSearchScreen extends StatelessWidget {
  const ResultOfSearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? titleName = Provider.of<GeneralController>(context, listen: false)
        .specializationName;
    FilterController filterController =
        Provider.of<FilterController>(context, listen: false);
    SearchResultController searchResultController =
        Provider.of<SearchResultController>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leading: TextBuilder(
          text: titleName ?? AppStrings.kResult.tr(),
          color: AppColors.navyBlue,
          verticalPadding: 2.25.h,
          align: TextAlign.center,
          horizontalPadding: 5.w,
          size: 12.5.sp,
          bold: true,
        ),
        leadingWidth: 35.w,
        actions: [
          GeometricalAvatar(
            backgroundColor: AppColors.transparent,
            radius: 10.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
            child: SvgPicture.asset(
              AppAssets.kFilterIcon,
              fit: BoxFit.scaleDown,
            ),
            onTap: () {
              filterController.mainSpecialtyList =
                  context.read<GeneralController>().specializationList;
              filterController.titlesList =
                  context.read<GeneralController>().tittleList;
              filterController.maxPrice = searchResultController.maxPrice;
              filterController.minPrice = searchResultController.minPrice;
              filterController.currentRangeValues ??=
                  searchResultController.currentRangeValues;
              // filterController.resetData();
              showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                        padding: EdgeInsets.only(top: 20.h),
                        child: const FilterBottomSheet(
                          filterType: 'Doctor',
                        ));
                  });
            },
          ),
        ],
      ),
      body: EmptyCard(
        color: AppColors.transparent,
        horizontalPadding: 0,
        verticalPadding: 0,
        verticalMargin: 0,
        child: Consumer<SearchResultController>(
          builder: (context, controller, child) {
            return /*controller.isLoading
                ? const LoadingWidget(
                    backgroundColor: AppColors.transparent,
                  )
                : doctorsList.isEmpty
                    ? NoDataWidget(
                        backgroundColor: Colors.transparent,
                        text: AppStrings.kNoDataFound.tr(),
                      )
                    :*/
                PagedListView.separated(
              builderDelegate: PagedChildBuilderDelegate<Doctor>(
                noItemsFoundIndicatorBuilder: (BuildContext con) {
                  return NoDataWidget(
                    text: AppStrings.kNoAppointments.tr(),
                    backgroundColor: Colors.transparent,
                  );
                },
                itemBuilder: (context, item, index) {
                  return DoctorWidget(
                    home: true,
                    cardOnTab: () {
                      Provider.of<DoctorProfileController>(context,
                              listen: false)
                          .getDoctorProfile(context, doctorId: item.id!);
                      Provider.of<DoctorProfileController>(context,
                              listen: false)
                          .getDoctorOffers(context, doctorId: item.id!);
                      Navigator.of(context).pushNamed(NameRoutes.kDoctorScreen);
                    },
                    model: item,
                  );
                },
              ),
              separatorBuilder: (context, i) => SizedBox(
                height: 1.0.h,
              ),
              pagingController: searchResultController.pagingController!,
            );
          },
        ),
      ),
    );
  }
}
