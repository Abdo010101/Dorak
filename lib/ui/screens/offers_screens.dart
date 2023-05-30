import 'package:dorakpattient/constants/constants.dart';
import 'package:dorakpattient/ui/components/components.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      appBar: AppBar(
        backgroundColor: AppColors.liteWight,
        elevation: 0,
        leading: TextBuilder(
          text: AppStrings.kOffers.tr(),
          color: AppColors.navyBlue,
          verticalPadding: 1.h,
          height: 2,
          horizontalPadding: 7.5.w,
          size: 12.5.sp,
          bold: true,
        ),
        leadingWidth: 35.w,
      ),
      body: EmptyCard(
        horizontalMargin: 0,
        verticalMargin: 0,
        verticalPadding: 0,
        horizontalPadding: 4.w,
        color: AppColors.transparent,
        child: Column(
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
              height: 1.5.h,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return OfferWidget(
                    offerTittle: 'offerTittle',
                    offerSubTittle: 'offerSubTittle',
                    offerPic: AppAssets.kOfferPic,
                    onPressed: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
