import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class DotesIntro extends StatelessWidget {
  const DotesIntro({Key? key, required this.itemIndex, this.count = 3})
      : super(key: key);
  final int itemIndex;
  final int? count;
  @override
  Widget build(BuildContext context) {
    return EmptyCard(
        color: Colors.transparent,
        width: 100.w,
        height: 3.h,
        verticalPadding: 1.h,
        horizontalPadding: 0,
        verticalMargin: 0.5.h,
        horizontalMargin: 0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: count,
                shrinkWrap: true,
                itemBuilder: (_, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 1.w),
                    height: 1.h,
                    width: itemIndex == index ? 2.5.h : 1.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: itemIndex == index
                          ? AppColors.blue
                          : AppColors.lightGrey2.withOpacity(0.5),
                    ),
                  );
                }),
          ],
        ));
  }
}
