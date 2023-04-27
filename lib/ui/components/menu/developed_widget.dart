import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class DevelopedWidget extends StatelessWidget {
  const DevelopedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //     Util.openLink("https://webstdy.com/ar");
      },
      child: Center(
        child: Column(
          children: [
            Text(
              AppStrings.kDevelopedBy,
              style: TextStyle(fontSize: 8.sp, color: AppColors.lightGrey2),
            ),
            Text(
              " W e b s t d y ",
              style: TextStyle(color: AppColors.cyan, fontSize: 10.sp),
            ),
            SizedBox(
              width: 25.0.w,
              child: const Divider(
                color: AppColors.blue,
                thickness: 5.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}
