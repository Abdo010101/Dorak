import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class ZoneCard extends StatelessWidget {
  const ZoneCard(
      {Key? key,
      required this.tittle,
      this.zoneStart,
      this.zoneEnd,
      this.contentsColor,
      this.zoneStartController,
      this.zoneEndController,
      this.timeStartController,
      this.timeEndController,
      this.dateStartController,
      this.dateEndController,
      this.isEditable = true,
      this.onSaved,
      this.keyboardType})
      : super(key: key);
  final String tittle;
  final String? zoneStart;
  final String? zoneEnd;
  final Color? contentsColor;
  final Function(DateTime?)? onSaved;
  final TextInputType? keyboardType;
  final TextEditingController? timeStartController;
  final TextEditingController? timeEndController;
  final TextEditingController? dateStartController;
  final TextEditingController? dateEndController;
  final TextEditingController? zoneStartController;
  final TextEditingController? zoneEndController;
  final bool isEditable;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.5.h),
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 1.5.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: AppColors.darkGray.withOpacity(0.75),
            width: 1.25.sp,
          )),
      child: Column(
        children: [
          TextBuilder(
            verticalPadding: 0.75.h,
            text: tittle,
          ),
          timeStartController != null || dateStartController != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DateTimeBuilder(
                        isEditable: isEditable,
                        timeController: timeStartController,
                        onTimeChanged: onSaved,
                        dateController: dateStartController,
                        hintText: zoneStart,
                      ),
                    ),
                    SizedBox(
                      width: 5.0.w,
                    ),
                    Expanded(
                      child: DateTimeBuilder(
                        isEditable: isEditable,
                        onTimeChanged: (value) {},
                        timeController: timeEndController,
                        dateController: dateEndController,
                        hintText: zoneEnd,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextFormFieldBuilder(
                      hint: zoneStart,
                      width: 35.w,
                      color: contentsColor,
                      controller: zoneStartController,
                      keyboardType: keyboardType,
                    ),
                    TextFormFieldBuilder(
                      hint: zoneEnd,
                      width: 35.w,
                      color: contentsColor,
                      controller: zoneEndController,
                      keyboardType: keyboardType,
                    )
                  ],
                )
        ],
      ),
    );
  }
}
