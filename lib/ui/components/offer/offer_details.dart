import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../controllers/controllers.dart';
import '../../../data/models/response/response.dart';
import '../../../routes/dorak_routes.dart';
import '../../../utis/util.dart';
import '../components.dart';

class OfferDetailsBottomSheet extends StatelessWidget {
  const OfferDetailsBottomSheet({Key? key, this.offer}) : super(key: key);
  final OfferResponse? offer;
  @override
  Widget build(BuildContext context) {
    return BottomSheetBuilder(
      height: 112.5.h,
      children: [
        GeometricalAvatar(
          height: 20.h,
          width: 100.w,
          radius: 15,
          url: offer?.mainPic,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GeometricalAvatar(
              margin: EdgeInsets.only(top: 2.5.h),
              radius: 35.sp,
              url: offer?.doctor?.image,
              child: const SizedBox(),
            ),
            Container(
              margin: EdgeInsets.only(top: 2.5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextBuilder(
                    text: offer?.doctor?.name,
                    horizontalPadding: 2.5.w,
                    verticalPadding: 0,
                    color: AppColors.black,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsetsDirectional.only(
                            start: 2.5.w, top: 1.h, end: 1.w),
                        height: 2.5.h,
                        child: Util.isNumeric(offer?.doctor?.rate)
                            ? RatingBarWidget(
                                initialRating:
                                    double.parse(offer!.doctor!.rate!),
                                itemSize: 10.sp,
                              )
                            : const SizedBox(),
                      ),
                      Text(offer!.doctor!.rate!),
                    ],
                  )
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: 15.w,
              child: Text(
                '${offer?.priceBefore}${AppStrings.kCurrency.tr()}',
                maxLines: 1,
                style: AppStyles.kButtonTextStyle.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: AppColors.gray,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            SizedBox(
              width: 0.5.w,
            ),
            SizedBox(
              width: 15.w,
              child: Text(
                '${offer?.priceAfter}${AppStrings.kCurrency.tr()}',
                maxLines: 1,
                style: AppStyles.kButtonTextStyle.copyWith(
                  color: AppColors.blue,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        ),
        EmptyCard(
          horizontalMargin: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextBuilder(
                text: offer?.title,
                color: AppColors.black,
                verticalPadding: 0,
                horizontalPadding: 0,
              ),
              TextBuilder(
                text: offer?.description,
                width: 100.w,
                maxLin: 6,
                horizontalPadding: 0,
                align: TextAlign.start,
              ),
            ],
          ),
        ),
        ButtonBuilder(
          radius: 25,
          buttonColor: AppColors.blue,
          title: AppStrings.kBookNow.tr(),
          width: 100.w,
          height: 6.5.h,
          onPressed: () async {
            Provider.of<DoctorProfileController>(context, listen: false)
                .getDoctorProfile(context, doctorId: offer!.doctor!.id!);
            Provider.of<DoctorProfileController>(context, listen: false)
                .getDoctorOffers(context, doctorId: offer!.doctor!.id!);

            Navigator.of(context).pushNamed(NameRoutes.kDoctorScreen);
          },
        )
      ],
    );
  }
}
