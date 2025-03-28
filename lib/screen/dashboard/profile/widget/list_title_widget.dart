import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';

class ListTitleWidget extends StatelessWidget {
  final String title;
  final String icon;
  bool showArrow;
  bool underline;
  Function()? onTap;
  String? underlineText;

  ListTitleWidget({
    super.key,
    required this.title,
    required this.icon,
    this.showArrow = true,
    this.onTap,
    this.underline = false,
    this.underlineText,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: <Widget>[
            MyAppIcon.iconNamedCommon(iconName: icon, width: 16.w, height: 16.w),
            const SizedBox(width: 6),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 14.sp),
                children: [
                  TextSpan(text: title, style: GoogleFonts.beVietnamPro(fontWeight: FontWeight.w400, fontSize: 14.sp)),
                  if (underlineText != null)
                    TextSpan(
                      text: underlineText,
                      style: TextStyle(decoration: TextDecoration.underline, fontSize: 14.sp),
                    ),
                ],
              ),
            ),
            const Spacer(),
            if (showArrow)
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey,
                size: 14.sp,
              )
          ],
        ),
      ),
    );
  }
}
