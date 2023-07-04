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
    return SafeArea(
      child: EmptyCard(
        verticalPadding: 0,
        verticalMargin: 0,
        horizontalMargin: 0,
        horizontalPadding: 0.5,
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: onpOp ?? () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: AppColors.blue,
                  ),
                ),
                TextBuilder(
                  text: title ?? '',
                  color: AppColors.navyBlue,
                  verticalPadding: 2.5.h,
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
                      icon: Icon(
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
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(10.h);
}
