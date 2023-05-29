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
      body: EmptyCard(
        horizontalMargin: 0,
        horizontalPadding: 4.w,
        color: AppColors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextBuilder(
              text: AppStrings.kOffers.tr(),
              color: AppColors.navyBlue,
              verticalPadding: 0.5.h,
              horizontalPadding: 2.5.w,
              bold: true,
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
