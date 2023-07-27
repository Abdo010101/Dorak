import 'package:dorakpattient/ui/components/components.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.hasShare,
      this.shareClick,
      this.onpOp})
      : super(key: key);
  final String? title;
  final VoidCallback? onpOp;
  final bool? hasShare;
  final VoidCallback? shareClick;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 7.5.h,
      leadingWidth: 90.w,
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.transparent,
      leading: Container(
        padding:
            EdgeInsetsDirectional.symmetric(vertical: 1.1.h, horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 7.5.w,
                  child: InkWell(
                    onTap: onpOp ?? () => Navigator.pop(context),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: AppColors.blue,
                      size: 15.sp,
                    ),
                  ),
                ),
                TextBuilder(
                  text: title ?? '',
                  color: AppColors.navyBlue,
                  verticalPadding: 0,
                  horizontalPadding: 0,
                  align: TextAlign.center,
                  bold: true,
                ),
              ],
            ),
            Visibility(
              visible: hasShare ?? false,
              child: Row(
                children: [
                  IconButton(
                      onPressed: shareClick,
                      icon: const Icon(
                        Icons.share,
                        color: AppColors.blue,
                      ))
                ],
              ),
            )
          ],
        ),
      ),
    );
    // child:
    // Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: [
    //     Row(
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: [
    //         SizedBox(
    //           width: 4.w,
    //         ),
    //         SizedBox(
    //           width: 7.5.w,
    //           child: InkWell(
    //             onTap: onpOp ?? () => Navigator.pop(context),
    //             child: Icon(
    //               Icons.arrow_back_ios,
    //               color: AppColors.blue,
    //               size: 15.sp,
    //             ),
    //           ),
    //         ),
    //         TextBuilder(
    //           text: title ?? '',
    //           color: AppColors.navyBlue,
    //           verticalPadding: 0,
    //           horizontalPadding: 0,
    //           align: TextAlign.center,
    //           bold: true,
    //         ),
    //       ],
    //     ),
    //     Visibility(
    //       visible: hasShare ?? false,
    //       child: Row(
    //         children: [
    //           IconButton(
    //               onPressed: shareClick,
    //               icon: const Icon(
    //                 Icons.share,
    //                 color: AppColors.blue,
    //               ))
    //         ],
    //       ),
    //     )
    //   ],
    // ),
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(7.5.h);
}
