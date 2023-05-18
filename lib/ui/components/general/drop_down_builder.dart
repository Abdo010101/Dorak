import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class DropDownBuilder extends StatelessWidget {
  const DropDownBuilder({
    Key? key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.isReport = false,
    this.width,
    this.height,
    this.hint,
  }) : super(key: key);
  final dynamic value;
  final bool isReport;
  final List? items;
  final double? width;
  final Function(dynamic) onChanged;
  final double? height;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: items != null && items!.isNotEmpty,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h),
        width: width ?? 85.w,
        height: height ?? 6.h,
        padding: EdgeInsets.symmetric(
          horizontal: 2.w, /* vertical: 1.h*/
        ),
        decoration: AppStyles.kCardBoxDecoration.copyWith(boxShadow: []),
        child: Center(
            child: DropdownButtonFormField(
          value: value,
          elevation: 0,
          // isDense: true,
          validator: (value) {
            if (value == null) {
              return 'required'.tr();
            }
            return null;
          },
          decoration: InputDecoration.collapsed(
            hintText: '$hint',
          ),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          isExpanded: false,
          dropdownColor: AppColors.lightGrey,
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.blue,
          ),
          iconSize: 20.sp,
          hint: TextBuilder(
            width: 65.w,
            text: hint == null ? '' : hint!,
            verticalPadding: 0,
            horizontalPadding: 2.5.w,
            color: AppColors.darkGray,
            bold: false,
          ),
          onChanged: onChanged,
          items: items?.map((valueItem) {
            return DropdownMenuItem(
              alignment: AlignmentDirectional.center,
              value: isReport ? valueItem : valueItem.id,
              child: TextBuilder(
                width: 30.w,
                text:

                    ///ToDo
                    '',
                verticalPadding: 0,
                horizontalPadding: 2.5.w,
                color: AppColors.darkGray,
                bold: false,
              ),
            );
          }).toList(),
        )),
      ),
    );
  }
}
