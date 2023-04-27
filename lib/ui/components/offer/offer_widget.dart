import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget({
    Key? key,
    required this.offerTittle,
    required this.offerSubTittle,
    required this.isActive,
    required this.offerPic,
    this.onPressed,
    this.changeStatus,
  }) : super(key: key);
  final VoidCallback? onPressed;
  final Function(bool)? changeStatus;

  final String? offerTittle;
  final String? offerSubTittle;
  final bool isActive;
  final String? offerPic;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        EmptyCard(
          verticalMargin: 1.h,
          verticalPadding: 1.5.h,
          height: 30.h,
          child: Column(
            children: [
              EmptyCard(
                width: 100.w,
                height: 17.5.h,
                verticalMargin: 0,
                verticalPadding: 0,
                horizontalMargin: 0,
                horizontalPadding: 0,
                url: offerPic,
                child: const SizedBox(),
              ),
              Row(
                children: [
                  GeometricalAvatar(
                    margin: EdgeInsets.only(top: 2.5.h),
                    radius: 35.sp,
                    // url: context
                    //     .read<AuthController>()
                    //     .currentUser
                    //     ?.doctor
                    //     ?.image,
                    child: const SizedBox(),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 2.5.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextBuilder(
                          text:
                              // context
                              //         .read<AuthController>()
                              //         .currentUser
                              //         ?.doctor
                              //         ?.name ??
                              'DocNam',
                          horizontalPadding: 2.5.w,
                          verticalPadding: 0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsetsDirectional.only(
                                  start: 2.5.w, top: 1.h, end: 1.w),
                              height: 2.5.h,
                              // child: Util.isNumeric(context
                              //         .read<AuthController>()
                              //         .currentUser
                              //         ?.doctor
                              //         ?.rate)
                              //     ? RatingBarWidget(
                              //         initialRating: double.parse(context
                              //                 .read<AuthController>()
                              //                 .currentUser
                              //                 ?.doctor
                              //                 ?.rate ??
                              //             '4.5'),
                              //         itemSize: 10.sp,
                              //       )
                              //     : const SizedBox(),
                            ),
                            Text(
                                // context
                                //     .read<AuthController>()
                                //     .currentUser
                                //     ?.doctor
                                //     ?.rate ??
                                '4.5'),
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
          width: 100.w,
          height: 17.5.h,
          margin: EdgeInsets.symmetric(horizontal: 9.w, vertical: 2.5.h),
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.5),
            color: AppColors.darkBlue.withOpacity(0.25),
          ),
        ),
        PositionedDirectional(
          bottom: 3.5.h,
          end: 7.5.w,
          child: ButtonBuilder(
            onPressed: onPressed,
            height: 5.h,
            width: 40.w,
            buttonColor: AppColors.liteWight,
            title: AppStrings.kEditOffer.tr(),
            titleStyle: const TextStyle(color: AppColors.blue),
            prefixIcon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: SvgPicture.asset(AppAssets.kPen),
            ),
          ),
        ),
        PositionedDirectional(
          bottom: 17.5.h,
          start: 15.w,
          child: TextBuilder(
            text: offerTittle,
            color: Colors.white,
            size: 20.sp,
          ),
        ),
        PositionedDirectional(
          width: 75.w,
          bottom: 12.5.h,
          start: 15.w,
          child: TextBuilder(
            text: offerSubTittle,
            color: Colors.white,
            maxLin: 2,
            size: 12.sp,
          ),
        ),
        PositionedDirectional(
          end: 0,
          top: -1.5.h,
          child: EmptyCard(
            horizontalPadding: 0,
            verticalPadding: 0,
            height: 6.5.h,
            width: 25.w,
            child: Switch(
              activeColor: Colors.white,
              activeTrackColor: AppColors.green,
              inactiveTrackColor: AppColors.error,
              value: isActive,
              onChanged: changeStatus,
            ),
          ),
        ),
        // PositionedDirectional(
        //   start: 0,
        //   top: -1.5.h,
        //   child: EmptyCard(
        //     horizontalPadding: 2.5.w,
        //     verticalPadding: 1.25.h,
        //     height: 6.5.h,
        //     width: 12.w,
        //     child: GestureDetector(
        //       onTap: removeFunction,
        //       child: SvgPicture.asset(
        //         AppAssets.kTrash,
        //         color: AppColors.bRed,
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
