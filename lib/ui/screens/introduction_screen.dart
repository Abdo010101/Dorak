import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: ButtonBuilder(
          margin: EdgeInsets.symmetric(vertical: 2.5.h, horizontal: 5.w),
          width: 90.w,
          height: 7.h,
          buttonColor: AppColors.blue,
          title: AppStrings.kNext.tr(),
          suffixIcon: Icon(
            Icons.arrow_forward_sharp,
            size: 15.sp,
          ),
          // onPressed: () =>
          //     context.read<IntroController>().changeIndex(context)
        ),
        body: SizedBox(
          height: 85.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    // onTap: () => controller.skipIndex(),
                    child: TextBuilder(
                      horizontalPadding: 5.w,
                      verticalPadding: 2.5.h,
                      text: AppStrings.kSkip.tr(),
                      underline: true,
                      color: AppColors.blue,
                      bold: false,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 60.h,
                child: PageView.builder(
                  allowImplicitScrolling: true,
                  // controller: controller.pageController,
                  // itemCount: controller.items.length,
                  scrollDirection: Axis.horizontal,
                  pageSnapping: true,
                  // onPageChanged: controller.changePageIndex,
                  itemBuilder: (_, index) {
                    return const SizedBox();
                    // IntroItem(
                    //   item: controller.items[index],
                    // );
                  },
                ),
              ),
              // DotesIntro(
              //   itemIndex: controller.reviewsIndex,
              //   count: controller.items.length,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
