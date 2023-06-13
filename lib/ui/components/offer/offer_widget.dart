import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../../../utis/util.dart';
import '../components.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({
    Key? key,
    required this.offerTittle,
    required this.offerSubTittle,
    required this.offerPic,
    this.doctorName,
    this.onPressed,
    this.rate,
    this.priceBefore,
    this.docPic,
    this.priceAfter,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final String? offerTittle;
  final String? priceBefore;
  final String? priceAfter;
  final String? offerSubTittle;
  final String? offerPic;
  final String? docPic;
  final String? doctorName;
  final dynamic rate;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EmptyCard(
          verticalMargin: 1.h,
          verticalPadding: 1.5.h,
          horizontalMargin: 0,
          height: 30.h,
          width: 90.w,
          child: Column(
            children: [
              EmptyCard(
                width: 82.w,
                height: 17.5.h,
                verticalMargin: 0,
                verticalPadding: 0,
                horizontalMargin: 0,
                horizontalPadding: 0,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                        imageUrl: offerPic!, fit: BoxFit.cover)),
              ),
              Row(
                children: [
                  GeometricalAvatar(
                    margin: EdgeInsets.only(top: 2.5.h),
                    radius: 35.sp,
                    url: docPic,
                    child: const SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2.5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text: '$doctorName',
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
                              child: Util.isNumeric('$rate')
                                  ? RatingBarWidget(
                                      initialRating: double.parse(rate),
                                      itemSize: 10.sp,
                                    )
                                  : const SizedBox(),
                            ),
                            Text('$rate'),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
        Container(
          width: 82.w,
          height: 17.5.h,
          margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.5.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: AppColors.darkBlue.withOpacity(0.25),
          ),
        ),
        PositionedDirectional(
          bottom: 8.h,
          start: 55.w,
          width: 31.w,
          child: Row(
            children: [
              SizedBox(
                width: 15.w,
                child: Text(
                  '${priceBefore ?? '0'}LE',
                  maxLines: 1,
                  style: AppStyles.kButtonTextStyle.copyWith(
                    decoration: TextDecoration.lineThrough,
                    color: AppColors.gray,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 15.w,
                child: Text(
                  '${priceAfter ?? '0'}LE',
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
        ),
        PositionedDirectional(
          bottom: 2.5.h,
          start: 56.w,
          child: ButtonBuilder(
            onPressed: onPressed,
            height: 4.h,
            width: 30.w,
            buttonColor: AppColors.blue,
            title: AppStrings.kOfferDetails.tr(),
            titleStyle: const TextStyle(color: AppColors.white),
          ),
        ),
        PositionedDirectional(
          bottom: 17.5.h,
          start: 8.w,
          child: TextBuilder(
            text: offerTittle,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        PositionedDirectional(
          width: 75.w,
          bottom: 12.5.h,
          start: 8.w,
          child: TextBuilder(
            text: offerSubTittle,
            color: Colors.white,
            maxLin: 2,
            size: 12.sp,
          ),
        ),
      ],
    );
  }
}
