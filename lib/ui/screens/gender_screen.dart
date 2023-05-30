import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../constants/constants.dart';

class GenderScreen extends StatelessWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 40.w,
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: AppColors.transparent,
        flexibleSpace: Image.asset(
          AppAssets.kMask,
          fit: BoxFit.cover,
        ),
        leading: Container(
          height: 6.h,
          padding:
              EdgeInsetsDirectional.symmetric(vertical: 1.1.h, horizontal: 5.w),
          child: Image.asset(
            AppAssets.kDorakIcon,
            fit: BoxFit.fill,
          ),
        ),
      ),
      backgroundColor: AppColors.blue,
      body: EmptyCard(
        child: Column(),
        color: AppColors.transparent,
      ),
    );
  }
}
