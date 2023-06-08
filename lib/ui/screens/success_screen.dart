import 'package:dorakpattient/routes/dorak_routes.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';
import '../components/components.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.liteWight,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.kDone,
            height: 22.5.h,
          ),
          EmptyCard(
            verticalMargin: 10.h,
            child: Column(
              children: [
                TextBuilder(
                  text: AppStrings.kAccCreated[0].tr(),
                  size: AppFontSizes.kS6,
                  color: Colors.black,
                  verticalPadding: 1.h,
                ),
                TextBuilder(
                  text: AppStrings.kAccCreated[1].tr(),
                  verticalPadding: 1.h,
                  align: TextAlign.center,
                  maxLin: 2,
                ),
                ButtonBuilder(
                  buttonColor: AppColors.blue,
                  onPressed: () {
                    Navigator.pushNamed(context, NameRoutes.kHomeScreen);
                  },
                  title: AppStrings.kAccCreated[2].tr(),
                  height: 6.h,
                  margin: EdgeInsets.symmetric(vertical: 2.h),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
