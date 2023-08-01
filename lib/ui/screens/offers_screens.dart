import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../data/models/response/response.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FilterController filterController =
        Provider.of<FilterController>(context, listen: false);
    OffersController offersController =
        Provider.of<OffersController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
        toolbarHeight: 6.h,
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leading: TextBuilder(
          text: AppStrings.kOffers.tr(),
          color: AppColors.navyBlue,
          verticalPadding: 1.5.h,
          align: TextAlign.center,
          horizontalPadding: 5.w,
          size: 13.sp,
          bold: true,
        ),
        leadingWidth: 35.w,
        actions: [
          GeometricalAvatar(
            backgroundColor: AppColors.transparent,
            radius: 10.w,
            child: SvgPicture.asset(
              AppAssets.kSortByIcon,
              fit: BoxFit.scaleDown,
              width: 3.0.w,
              height: 3.0.w,
            ),
            onTap: () {
              showBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: const SortByBottomSheet(
                          filterType: 'Offer',
                        ));
                  });
            },
          ),
          GeometricalAvatar(
            backgroundColor: AppColors.transparent,
            radius: 10.w,
            margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 0.h),
            child: SvgPicture.asset(
              AppAssets.kFilterIcon,
              fit: BoxFit.scaleDown,
              width: 3.0.w,
              height: 3.0.w,
            ),
            onTap: () {
              filterController.mainSpecialtyList =
                  context.read<GeneralController>().specializationList;
              filterController.titlesList =
                  context.read<GeneralController>().tittleList;
              filterController.maxPrice = offersController.maxPrice;
              filterController.minPrice = offersController.minPrice;
              filterController.currentRangeValues == const RangeValues(0.0, 0.0)
                  ? filterController.currentRangeValues =
                      offersController.currentRangeValues
                  : null;
              showBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: const FilterBottomSheet(
                          filterType: 'Offer',
                        ));
                  });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          offersController.pagingController!.refresh();
        },
        child: EmptyCard(
          horizontalMargin: 0,
          verticalMargin: 0,
          verticalPadding: 0,
          horizontalPadding: 4.w,
          color: AppColors.transparent,
          child: Consumer<OffersController>(
            builder: (context, controller, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormFieldBuilder(
                    hint: AppStrings.kSearchForOffer.tr(),
                    controller: controller.offerSearchController,
                    verticalMargin: 0,
                    horizontalMargin: 0,
                    maxLines: 1,
                    width: 100.w,
                    height: 6.h,
                    hintSize: 7.5.sp,
                    borderRadius: 15,
                    prefixIcon: IconButton(
                      onPressed: () => {
                        controller.pagingController?.refresh(),
                      },
                      icon: Icon(
                        Icons.search,
                        size: 12.5.sp,
                        color: AppColors.gray,
                      ),
                    ),
                    onSubmit: (value) => {
                      controller.pagingController?.refresh(),
                    },
                    color: AppColors.white,
                    borderColor: AppColors.white,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Expanded(
                    child: PagedListView<int, OfferResponse>(
                      padding: EdgeInsets.zero,
                      pagingController: controller.pagingController!,
                      builderDelegate: PagedChildBuilderDelegate<OfferResponse>(
                        noItemsFoundIndicatorBuilder: (BuildContext context) {
                          return NoDataWidget(
                            text: AppStrings.kNoOffers.tr(),
                            backgroundColor: Colors.transparent,
                          );
                        },
                        firstPageProgressIndicatorBuilder:
                            (BuildContext context) {
                          return const LoadingWidget(
                            backgroundColor: AppColors.transparent,
                          );
                        },
                        itemBuilder: (context, item, index) {
                          return OfferWidget(
                            offerTittle: item.title,
                            offerSubTittle: item.description,
                            offerPic: item.mainPic,
                            priceBefore: item.priceBefore,
                            priceAfter: item.priceAfter,
                            doctorName: item.doctor?.name,
                            docPic: item.doctor!.image,
                            rate: item.doctor!.rate,
                            onPressed: () {
                              showBottomSheet(
                                  context: context,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) {
                                    return OfferDetailsBottomSheet(
                                      offer: item,
                                    );
                                  });
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
