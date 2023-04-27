import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class RowMenuCard extends StatelessWidget {
  const RowMenuCard(
      {Key? key, required this.title, required this.onTap, required this.icon})
      : super(key: key);
  final String title;
  final String icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6.h,
      child: ListTile(
        onTap: onTap,
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: Image.asset(icon, width: 5.0.w),
        minLeadingWidth: 2,
        dense: true,
        contentPadding: EdgeInsets.zero,
        title: Text(
          title,
          style: TextStyle(fontSize: 10.sp),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 12.sp,
        ),
        subtitle: SizedBox(
          height: 0.5.h,
          child: Divider(
            color: Colors.black.withOpacity(0.15),
            thickness: 0.1.h,
          ),
        ),
      ),
    );
  }
}
