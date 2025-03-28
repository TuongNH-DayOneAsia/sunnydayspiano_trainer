

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildSectionTitle extends StatelessWidget {
  final String? text;
  final Widget? showMoreWidget;

  const BuildSectionTitle({super.key, this.text, this.showMoreWidget});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text ?? '',
            style: TextStyle(
              fontSize: 17.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (showMoreWidget != null) showMoreWidget!,
        ],
      ),
    );
  }
}
