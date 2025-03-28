import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';

class NotificationBell extends StatelessWidget {
  final int count;

  const NotificationBell({
    super.key,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        MyAppIcon.iconNamedCommon(
          iconName: 'dashboard/noti.svg',
        ),
        if (count > 0)
          Positioned(
            right: -8,
            top: -8,
            child: Container(
              constraints: BoxConstraints(
                minWidth: 16.w,
              ),
              height: 16.w,
              decoration: BoxDecoration(
                color: MyColors.mainColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
