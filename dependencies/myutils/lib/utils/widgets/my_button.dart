library gtd_button;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

import '../dimens.dart';

// MyButton Widget
class MyButton<T> extends StatelessWidget {
  final ValueChanged<bool?>? onPressed;
  final String text;
  final double? height;
  final double? width;
  final Color? colorText;
  final double? fontSize;
  final Widget? icon;
  final Widget? leadingIcon;
  final double? borderRadius;
  final FontWeight? fontWeight;
  final Gradient? gradient;
  final BoxBorder? border;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final bool isEnable;
  final bool isLoading;

  const MyButton({
    super.key,
    this.onPressed,
    required this.text,
    this.height,
    this.width,
    this.colorText,
    this.icon,
    this.leadingIcon,
    this.borderRadius,
    this.fontWeight,
    this.gradient,
    this.color,
    this.border,
    this.padding,
    this.fontSize,
    this.isEnable = true,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final hasBorder = border != null;
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        child: Container(
          width: width,
          padding: padding,
          height: height ?? 35.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 50)),
            gradient: gradient,
            border: border,
            color: isEnable ? color : (color ?? Colors.blue),
            boxShadow: !hasBorder
                ? const [
                    BoxShadow(
                      color: Color(0x19000000),
                      blurRadius: 3,
                      offset: Offset(0, 3),
                      spreadRadius: 0,
                    ),
                  ]
                : null,
          ),
          child: TextButton(
              onPressed: (!isEnable || isLoading)
                  ? null
                  : () {
                      if (onPressed != null) {
                        onPressed!(true);
                      }
                    },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
                padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                shape: borderRadius != null
                    ? MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular((borderRadius! - 10)),
                          side: const BorderSide(color: Colors.transparent),
                        ),
                      )
                    : null,
              ),
              child: Wrap(
                direction: Axis.horizontal,
                crossAxisAlignment: WrapCrossAlignment.center,
                runSpacing: icon != null ? 10 : 0,
                children: [
                  leadingIcon ?? const SizedBox(),
                  SizedBox(
                    width: leadingIcon != null ? 5 : 0,
                  ),
                  Text(
                    text,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: colorText ?? Colors.white,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? 14.sp,
                    ),
                  ),
                  icon ?? const SizedBox()
                ],
              )
              // isLoading
              //     ? SizedBox(
              //   width: 20,
              //   height: 20,
              //   child: CircularProgressIndicator(
              //     strokeWidth: 2,
              //     valueColor: AlwaysStoppedAnimation<Color>(colorText ?? Colors.white),
              //   ),
              // )
              //     : Wrap(
              //   direction: Axis.horizontal,
              //   crossAxisAlignment: WrapCrossAlignment.center,
              //   runSpacing: icon != null ? 10 : 0,
              //   children: [
              //     leadingIcon ?? const SizedBox(),
              //     Text(
              //       text,
              //       textAlign: TextAlign.center,
              //       textDirection: TextDirection.ltr,
              //       style: TextStyle(
              //         color: colorText ?? Colors.white,
              //         fontWeight: fontWeight ?? FontWeight.w600,
              //         fontSize: fontSize ?? 14,
              //       ),
              //     ),
              //     icon ?? const SizedBox()
              //   ],
              // ),
              ),
        ),
      ),
    );
  }
}

class RippleTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final Widget? iconLeft;
  final TextDecoration? textDecoration;

  const RippleTextButton({
    super.key,
    required this.text,
    this.iconLeft,
    required this.onPressed,
    required this.color,
    this.textDecoration,
    this.fontWeight,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        splashColor: color.withOpacity(0.3),
        highlightColor: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: padding ?? EdgeInsets.symmetric(horizontal: 10.0.w, vertical: 8.0.w),
          child: iconLeft != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    iconLeft!,
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      text,
                      style: TextStyle(
                        fontWeight: fontWeight ?? FontWeight.w400,
                        decoration: textDecoration ?? TextDecoration.none,
                        color: color,
                        fontSize: fontSize ?? 14.sp,
                      ),
                    ),
                  ],
                )
              : Text(
                  text,
                  style: TextStyle(
                    fontWeight: fontWeight ?? FontWeight.w400,
                    decoration: textDecoration ?? TextDecoration.none,
                    color: color,
                    decorationColor: color,
                    fontSize: fontSize ?? 14.sp,
                  ),
                ),
        ),
      ),
    );
  }
}
