import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

import '../../../constants/constants.dart';
import '../components.dart';

class DateTimeBuilder extends StatelessWidget {
  const DateTimeBuilder(
      {Key? key,
      this.timeController,
      this.onTimeChanged,
      this.dateController,
      this.isEditable = true,
      this.hintText})
      : super(key: key);
  final TextEditingController? timeController;
  final TextEditingController? dateController;
  final Function(DateTime)? onTimeChanged;
  final String? hintText;
  final bool isEditable;

  @override
  Widget build(BuildContext context) {
    var timeShowController = TextEditingController();
    timeShowController = timeController!;
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
                  ? () {
                      DatePicker.showTime12hPicker(context,
                          locale: context.locale.languageCode == 'ar'
                              ? LocaleType.ar
                              : LocaleType.en,
                          showTitleActions: true, onConfirm: (DateTime date) {
                        var dateFormat = DateFormat.Hm('en').format(date);
                        timeShowController.text = dateFormat.toString();
                        timeController!.text = dateFormat.toString();
                        print(timeController!.text);
                      }, currentTime: DateTime.now());
                    }
                  : null,
            )
          : DateTimePicker(
              locale: const Locale('en'),
              decoration:
                  AppStyles.kDateTimeDecoration.copyWith(hintText: hintText),
              type: DateTimePickerType.date,
              firstDate: DateTime(2010),
              validator: Validators.required('required'.tr()),
              lastDate: DateTime(2050),
              controller: dateController,
              use24HourFormat: false,
              onChanged: (value) {},
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
