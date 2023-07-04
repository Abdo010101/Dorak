import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/controllers/controllers.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    OffersController offerController =
        Provider.of<OffersController>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leading: TextBuilder(
          text: AppStrings.kOffers.tr(),
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
              offerController.mainSpecialtyList =
                  context.read<GeneralController>().specializationList;
              offerController.titlesList =
                  context.read<GeneralController>().tittleList;
              showBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) {
                    return Padding(
                        padding: EdgeInsets.only(top: 10.h),
                        child: const OfferFilterBottomSheet());
                  });
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          offerController.getAllOffers(home: true);
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
                    height: 7.5.h,
                    borderRadius: 15,
                    prefixIcon: IconButton(
                      onPressed: () => controller.getAllOffers(),
                      icon: Icon(
                        Icons.search,
                        size: AppFontSizes.kS6,
                        color: AppColors.gray,
                      ),
                    ),
                    onSubmit: (value) => controller.getAllOffers(),
                    color: AppColors.white,
                  ),
                  SizedBox(
                    height: 1.5.h,
                  ),
                  Expanded(
                    child: controller.isLoading
                        ? const LoadingWidget(
                            backgroundColor: AppColors.transparent,
                          )
                        : controller.offers.isEmpty
                            ? NoDataWidget(
                                text: AppStrings.kNoOffers.tr(),
                                backgroundColor: Colors.transparent,
                              )
                            : ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: controller.offers.length,
                                itemBuilder: (context, index) {
                                  return OfferWidget(
                                    offerTittle: controller.offers[index].title,
                                    offerSubTittle:
                                        controller.offers[index].description,
                                    offerPic: controller.offers[index].mainPic,
                                    priceBefore:
                                        controller.offers[index].priceBefore,
                                    priceAfter:
                                        controller.offers[index].priceAfter,
                                    doctorName:
                                        controller.offers[index].doctor?.name,
                                    docPic:
                                        controller.offers[index].doctor!.image,
                                    rate: controller.offers[index].doctor!.rate,
                                    onPressed: () {
                                      showBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) {
                                            return OfferDetailsBottomSheet(
                                              offer: controller.offers[index],
                                            );
                                          });
                                    },
                                  );
                                },
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
