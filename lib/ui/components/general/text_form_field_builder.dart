import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../constants/constants.dart';

class TextFormFieldBuilder extends StatelessWidget {
  final String? hint;
  final String? initValue;
  final double? hintSize;
  final TextEditingController? controller;
  final Widget? suffixIcon;
  final Color borderColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final double? verticalMargin;
  final double? horizontalMargin;
  final bool haveBorder;
  final String? Function(String?)? validator;
  final Function(String)? onSubmit;
  final Function(String)? onChange;
  final VoidCallback? onTap;
  final bool? isEnabled;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final int? maxLines;
  final Color? color;
  final bool obscureText;
  final bool haveLabel;
  final TextAlign? textAlign;
  final Widget? prefixIcon;
  final int? lengthTextInput;
  final bool defaultBorder;
  final bool autoFocus;
  final TextInputAction? textInputAction;

  const TextFormFieldBuilder(
      {Key? key,
      this.hint,
      this.initValue,
      this.controller,
      this.prefixIcon,
      this.suffixIcon,
      this.lengthTextInput,
      this.autoFocus = false,
      this.hintSize = 12.5,
      this.haveBorder = true,
      this.borderRadius = 50.0,
      this.obscureText = false,
      this.textInputAction,
      this.onTap,
      this.padding,
      this.textAlign,
      this.borderColor = AppColors.primary,
      this.onSubmit,
      this.onChange,
      this.focusNode,
      this.validator,
      this.defaultBorder = false,
      this.haveLabel = true,
      this.maxLines,
      this.keyboardType,
      this.isEnabled = true,
      this.color,
      this.width,
      this.height,
      this.horizontalMargin,
      this.verticalMargin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: verticalMargin ?? 1.h, horizontal: horizontalMargin ?? 0),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          color: color,
        ),
        child: Center(
          child: TextFormField(
            controller: controller,
            validator: validator,
            textAlign: textAlign ?? TextAlign.start,
            keyboardType: keyboardType,
            onChanged: onChange,
            obscureText: obscureText,
            textInputAction: textInputAction,
            onFieldSubmitted: onSubmit,
            autofocus: autoFocus,
            enabled: isEnabled,
            focusNode: focusNode,
            inputFormatters: [
              LengthLimitingTextInputFormatter(lengthTextInput)
            ],
            maxLines: maxLines ?? 1,
            decoration: InputDecoration(
              border: haveBorder
                  ? defaultBorder
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                              color: AppColors.green, width: 2))
                      : OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            width: 2.sp,
                            color: borderColor,
                          ),
                        )
                  : null,
              contentPadding: haveBorder
                  ? padding ??
                      EdgeInsets.symmetric(
                        horizontal: 5.w,
                      )
                  : EdgeInsets.zero,
              suffixIcon: suffixIcon,
              suffixIconConstraints:
                  const BoxConstraints(minHeight: 10, minWidth: 10),
              filled: haveBorder,
              disabledBorder: OutlineInputBorder(
                gapPadding: 0.0,
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  width: 2.sp,
                  color: borderColor,
                ),
              ),
              errorBorder: haveBorder
                  ? defaultBorder
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                              color: AppColors.green, width: 2))
                      : OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            width: 2.sp,
                            color: borderColor,
                          ),
                        )
                  : null,
              focusedBorder: haveBorder
                  ? defaultBorder
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                              color: AppColors.green, width: 2),
                        )
                      : OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            width: 2.sp,
                            color: borderColor,
                          ),
                        )
                  : null,
              focusedErrorBorder: OutlineInputBorder(
                gapPadding: 0.0,
                borderRadius: BorderRadius.circular(borderRadius),
                borderSide: BorderSide(
                  width: 2.sp,
                  color: borderColor,
                ),
              ),
              enabledBorder: haveBorder
                  ? defaultBorder
                      ? UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: const BorderSide(
                              color: AppColors.transparent, width: 2))
                      : OutlineInputBorder(
                          gapPadding: 0.0,
                          borderRadius: BorderRadius.circular(borderRadius),
                          borderSide: BorderSide(
                            width: 2.sp,
                            color: borderColor,
                          ),
                        )
                  : null,

              prefixIcon: prefixIcon,
              //suffix: suffixIcon,
              hintText: haveLabel ? '' : "$hint ",
              hintStyle: TextStyle(
                  fontSize: hintSize ?? 13.5.sp, color: AppColors.darkGray),
              label: haveLabel
                  ? Padding(
                      padding: EdgeInsetsDirectional.only(start: 2.5.w),
                      child: Text(
                        hint ?? '',
                        style: TextStyle(
                            fontSize: hintSize ?? 13.5.sp,
                            color: AppColors.darkGray),
                      ),
                    )
                  : null,
              labelStyle: TextStyle(fontSize: AppFontSizes.kS4),
              fillColor: color ?? AppColors.lightGrey,
            ),
          ),
        ),
      ),
    );
  }
}
