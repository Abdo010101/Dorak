import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class DateTimeBuilder extends StatelessWidget {
  const DateTimeBuilder(
      {Key? key,
      this.timeController,
      this.dateController,
      this.isEditable = true,
      this.hintText})
      : super(key: key);
  final TextEditingController? timeController;
  final TextEditingController? dateController;
  final String? hintText;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    var timeShowController = TextEditingController();
    timeShowController = timeController ?? TextEditingController();
    /* String? format = formatTimePickerJm(timeShowController.text);
    timeController?.text = format!;*/
    return EmptyCard(
      color: AppColors.lightGrey,
      horizontalPadding: 1.w,
      radius: 25,
      // height: 6.h,
      width: 35.w,
      horizontalMargin: 0,
      // horizontalPadding: dateController != null ? 2.5.w : 6.5.w,
      verticalPadding: 0,
      verticalMargin: 0,
      child: dateController == null
          ? TextFormFieldBuilder(
              isEnabled: false,
              hint: hintText,
              controller: timeShowController,
              onTap: isEditable
                  ? () async {
                      TimeOfDay? timeOfDay = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (timeOfDay != null) {
                        var timeNow = DateTime.now();
                        DateTime dateTime = DateTime(
                            timeNow.year,
                            timeNow.month,
                            timeNow.day,
                            timeOfDay.hour,
                            timeOfDay.minute);
                        var dateFormat = DateFormat.Hm('en').format(dateTime);
                        timeShowController.text = dateFormat.toString();
                        timeController!.text = dateFormat.toString();
                      }
                      /*    DatePicker.showTime12hPicker(context,
                          locale: context.locale.languageCode == 'ar'
                              ? LocaleType.ar
                              : LocaleType.en,
                          showTitleActions: true, onConfirm: (DateTime date) {
                        var dateFormat = DateFormat.Hm('en').format(date);
                        timeShowController.text = dateFormat.toString();
                        timeController!.text = dateFormat.toString();
                        print(timeController!.text);
                      }, currentTime: DateTime.now());*/
                    }
                  : null,
            )
          : TextFormFieldBuilder(
              isEnabled: false,
              hint: hintText,
              controller: dateController,
              onTap: isEditable
                  ? () async {
                      DateTime? dateTime = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 1,
                            DateTime.now().month, DateTime.now().day),
                      );
                      if (dateTime != null) {
                        dateController?.text =
                            '${dateTime.year}/${dateTime.month}/${dateTime.day}';
                      }
                    }
                  : null,
            ),
    );
  }

  String? formatTimePickerJm(String? time) {
    if (time != null) {
      var spiltTimeList = time.split(':');

      int hour = int.parse(spiltTimeList[0]);
      int minute = int.parse(spiltTimeList[1]);
      DateTime now = DateTime.now().copyWith(hour: hour, minute: minute);
      return DateFormat.jm().format(now);
    }
    return null;
  }
}
