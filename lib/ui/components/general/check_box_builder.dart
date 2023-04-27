import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class CheckBoxBuilder extends StatelessWidget {
  const CheckBoxBuilder(
      {Key? key,
      required this.onChanged,
      required this.value,
      this.size,
      this.activeColor,
      this.checkColor})
      : super(key: key);

  final Color? activeColor;
  final Color? checkColor;
  final Function(bool?) onChanged;
  final bool value;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: size ?? 0.8,
      child: Checkbox(
        value: value,
        checkColor: checkColor ?? Colors.white,
        activeColor: activeColor ?? AppColors.blue,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(5.0),
          ),
        ),
        onChanged: onChanged,
      ),
    );
  }
}
