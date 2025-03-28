import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class BookingClassCard extends StatelessWidget {
  final DataClass data;
  final Function() onPressed;

  const BookingClassCard({
    super.key,
    required this.data,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.classLessonCode ?? '',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff6a6a6a),
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            const Divider(
              color: Color(0xFFF0F0F0),
              thickness: 1,
            ),
            SizedBox(height: 18.h),
            Text(
              '${data.classStartTime} - ${data.classEndTime}',
              style: GoogleFonts.unbounded(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: MyColors.mainColor,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 8.h),
            Text(
              data.branch?.name ?? '',
              style: TextStyle(
                color: const Color(0xFF3B3B3B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 4.h),
            if (data.classroom?.name?.isNotEmpty == true)
              Text(
                data.classroom?.name ?? '',
                style: TextStyle(
                  color: const Color(0xFF3B3B3B),
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            SizedBox(height: 4.h),
            Text(
              '${'bookingClass.coachInClass'.tr()}: ${data.nameCoach()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF3B3B3B),
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MyButton(
                  onPressed: (v) {
                    if (data.isBooking == true) {
                      onPressed.call();
                    } else {
                      MyPopupMessage.showPopUpWithIcon(
                        title: 'profile.notification'.tr(),
                        context: context,
                        barrierDismissible: false,
                        description: data.textIsBook ?? '',
                        colorIcon: MyColors.redColor,
                        iconAssetPath: 'booking/booking_not_data.svg',
                        confirmText: 'bookingClass.goBack'.tr(),
                      );
                    }
                  },
                  isEnable: (data.isFullSlot == false),
                  height: 35.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  text: 'bookingClass.book'.tr(),
                  colorText: Colors.white,
                  color: (data.isFullSlot == true)
                      ? MyColors.lightGrayColor.withOpacity(0.6)
                      : MyColors.mainColor,
                  border: Border.all(
                    width: 0.5,
                    color: (data.isFullSlot == true)
                        ? MyColors.lightGrayColor.withOpacity(0.6)
                        : MyColors.mainColor,
                  ),
                  // border: null,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${'bookingClass.booked'.tr()} ${data.instrumentsTotalBooked}/${data.instrumentsTotalActive} ${'bookingClass.slot'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6A6A6A),
                      ),
                    ),
                    Text(
                      data.isFullSlot == true
                          ? 'Hết chỗ'
                          : '${'bookingClass.remaining'.tr()} ${data.instrumentsTotalEmpty} ${'bookingClass.emptySlots'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300,
                        color: MyColors.redColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ClassCardV2 extends StatelessWidget {
  final DataClass data;
  final Function() onPressed;
  final Function() onRequest;

  const ClassCardV2({
    super.key,
    required this.data,
    required this.onPressed,
    required this.onRequest,
  });

  bool isEnable() {
    return data.status != 0 && data.isFullSlot == false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _statusWidget(data),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Mã buổi học: ${data.classLessonCode ?? ''}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2A2A2A),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(
            color: Color(0xFFF0F0F0),
            thickness: 1,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${data.classStartTime} - ${data.classEndTime}',
              style: GoogleFonts.unbounded(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: MyColors.mainColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              data.branch?.name ?? '',
              style: TextStyle(
                color: const Color(0xFF3B3B3B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          if (data.classroom?.name?.isNotEmpty == true)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  data.classroom?.name ?? '',
                  style: TextStyle(
                    color: const Color(0xFF3B3B3B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${'bookingClass.coachInClass'.tr()}: ${data.nameCoach()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF3B3B3B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'bookingClass.booked'.tr()} ${data.instrumentsTotalBooked}/${data.instrumentsTotalActive} ${'bookingClass.slot'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6A6A6A),
                      ),
                    ),
                    Text(
                      data.isFullSlot == true
                          ? 'Hết chỗ'
                          : '${'bookingClass.remaining'.tr()} ${data.instrumentsTotalEmpty} ${'bookingClass.emptySlots'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300,
                        color: MyColors.redColor,
                      ),
                    ),
                  ],
                ),
                _buildButton(
                  context: context,
                  data: data,
                  onPressed: onPressed,
                  onRequest: onRequest,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      required DataClass data,
      required Function() onRequest,
      required Function() onPressed}) {
    if (data.isFullSlot == true) {
      return MyButton(
        onPressed: (v) {
          onRequest.call();
        },
        isEnable: data.isRequestClassLesson == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: data.textRequestClassLesson ?? '',
        colorText: Colors.white,
        color: data.isRequestClassLesson == true
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color: data.isRequestClassLesson == true
              ? MyColors.lightGrayColor.withOpacity(0.6)
              : MyColors.mainColor,
        ),
        // border: null,
      );
    } else {
      return MyButton(
        onPressed: (v) {
          if (data.isBooking == true) {
            onPressed.call();
          } else {
            MyPopupMessage.showPopUpWithIcon(
              title: 'profile.notification'.tr(),
              context: context,
              barrierDismissible: false,
              description: data.textIsBook ?? '',
              colorIcon: MyColors.redColor,
              iconAssetPath: 'booking/booking_not_data.svg',
              confirmText: 'bookingClass.goBack'.tr(),
            );
          }
        },
        isEnable:
            data.status != 0 && data.status != 2 && data.isFullSlot == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: 'bookingClass.book'.tr(),
        colorText: Colors.white,
        color: (data.isFullSlot == true || data.status == 0 || data.status == 2)
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color:
              (data.isFullSlot == true || data.status == 0 || data.status == 2)
                  ? MyColors.lightGrayColor.withOpacity(0.6)
                  : MyColors.mainColor,
        ),
        // border: null,
      );
    }
  }

  _statusWidget(DataClass data) {
    Color? backgroundColor;
    Color? textColor;
    String text = '';
    if (data.status == 0) {
      backgroundColor = const Color(0xFFFFE0E0);
      textColor = const Color(0xFFFF0000);
      text = 'Đã kết thúc';
    } else if (data.status == 2) {
      backgroundColor = const Color(0xFFFFF1D5);
      textColor = const Color(0xFFF96800);
      text = 'Đang diễn ra';
    } else {
      backgroundColor = const Color(0xFFDFF470);
      textColor = const Color(0xFF24533C);
      text = 'Sắp diễn ra';
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: ShapeDecoration(
                  color: textColor,
                  shape: const OvalBorder(),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10.sp,
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ClassCardV3 extends StatelessWidget {
  final DataClass data;
  final Function() onPressed;
  final Function() onRequest;

  const ClassCardV3({
    super.key,
    required this.data,
    required this.onPressed,
    required this.onRequest,
  });

  bool isEnable() {
    return data.status != 0 && data.isFullSlot == false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _statusWidget(data),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Mã buổi học: ${data.classLessonCode ?? ''}',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF2A2A2A),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 16.h),
          const Divider(
            color: Color(0xFFF0F0F0),
            thickness: 1,
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${data.classStartTime} - ${data.classEndTime}',
              style: GoogleFonts.unbounded(
                fontSize: 20.sp,
                fontWeight: FontWeight.w400,
                color: MyColors.mainColor,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              data.branch?.name ?? '',
              style: TextStyle(
                color: const Color(0xFF3B3B3B),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          if (data.classroom?.name?.isNotEmpty == true)
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  data.classroom?.name ?? '',
                  style: TextStyle(
                    color: const Color(0xFF3B3B3B),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                  ),
                )),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              '${'bookingClass.coachInClass'.tr()}: ${data.nameCoach()}',
              style: TextStyle(
                fontSize: 12.sp,
                color: const Color(0xFF3B3B3B),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'bookingClass.booked'.tr()} ${data.instrumentsTotalBooked}/${data.instrumentsTotalActive} ${'bookingClass.slot'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF6A6A6A),
                      ),
                    ),
                    Text(
                      data.isFullSlot == true
                          ? 'Hết chỗ'
                          : '${'bookingClass.remaining'.tr()} ${data.instrumentsTotalEmpty} ${'bookingClass.emptySlots'.tr()}',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w300,
                        color: MyColors.redColor,
                      ),
                    ),
                  ],
                ),
                MyButton(
                  onPressed: (v) {
                    if (data.isBooking == true) {
                      onPressed.call();
                    } else {
                      MyPopupMessage.showPopUpWithIcon(
                        title: 'profile.notification'.tr(),
                        context: context,
                        barrierDismissible: false,
                        description: data.textIsBook ?? '',
                        colorIcon: MyColors.redColor,
                        iconAssetPath: 'booking/booking_not_data.svg',
                        confirmText: 'bookingClass.goBack'.tr(),
                      );
                    }
                  },
                  isEnable: (data.isFullSlot == false && data.status != 0),
                  height: 35.h,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                  ),
                  text: 'bookingClass.book'.tr(),
                  colorText: Colors.white,
                  color: (data.isFullSlot == true || data.status == 0)
                      ? MyColors.lightGrayColor.withOpacity(0.6)
                      : MyColors.mainColor,
                  border: Border.all(
                    width: 0.5,
                    color: (data.isFullSlot == true || data.status == 0)
                        ? MyColors.lightGrayColor.withOpacity(0.6)
                        : MyColors.mainColor,
                  ),
                  // border: null,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      required DataClass data,
      required Function() onRequest,
      required Function() onPressed}) {
    if (data.isFullSlot == true) {
      return MyButton(
        onPressed: (v) {
          onRequest.call();
        },
        isEnable: data.isRequestClassLesson == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: data.textRequestClassLesson ?? '',
        colorText: Colors.white,
        color: data.isRequestClassLesson == true
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color: data.isRequestClassLesson == true
              ? MyColors.lightGrayColor.withOpacity(0.6)
              : MyColors.mainColor,
        ),
        // border: null,
      );
    } else {
      return MyButton(
        onPressed: (v) {
          if (data.isBooking == true) {
            onPressed.call();
          } else {
            MyPopupMessage.showPopUpWithIcon(
              title: 'profile.notification'.tr(),
              context: context,
              barrierDismissible: false,
              description: data.textIsBook ?? '',
              colorIcon: MyColors.redColor,
              iconAssetPath: 'booking/booking_not_data.svg',
              confirmText: 'bookingClass.goBack'.tr(),
            );
          }
        },
        isEnable:
            data.status != 0 && data.status != 2 && data.isFullSlot == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: 'bookingClass.book'.tr(),
        colorText: Colors.white,
        color: (data.isFullSlot == true || data.status == 0 || data.status == 2)
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color:
              (data.isFullSlot == true || data.status == 0 || data.status == 2)
                  ? MyColors.lightGrayColor.withOpacity(0.6)
                  : MyColors.mainColor,
        ),
        // border: null,
      );
    }
  }

  _statusWidget(DataClass data) {
    Color? backgroundColor;
    Color? textColor;
    String text = '';
    if (data.status == 0) {
      backgroundColor = const Color(0xFFFFE0E0);
      textColor = const Color(0xFFFF0000);
      text = 'Đã kết thúc';
    } else if (data.status == 2) {
      backgroundColor = const Color(0xFFFFF1D5);
      textColor = const Color(0xFFF96800);
      text = 'Đang diễn ra';
    } else {
      backgroundColor = const Color(0xFFDFF470);
      textColor = const Color(0xFF24533C);
      text = 'Sắp diễn ra';
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: ShapeDecoration(
            color: backgroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 8.w,
                height: 8.w,
                decoration: ShapeDecoration(
                  color: textColor,
                  shape: const OvalBorder(),
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: textColor,
                  fontSize: 10.sp,
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ClassCardV4 extends StatelessWidget {
  final DataClass data;
  final Function() onPressed;
  final Function() onRequest;

  const ClassCardV4({
    super.key,
    required this.data,
    required this.onPressed,
    required this.onRequest,
  });

  bool isEnable() {
    return data.status != 0 && data.isFullSlot == false;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${data.classStartTime} - ${data.classEndTime}',
                  style: GoogleFonts.unbounded(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w400,
                    color: MyColors.mainColor,
                  ),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 16.h),
                Text(
                  'Tên phòng học',
                  style: TextStyle(
                    color: const Color(0xFF6A6A6A),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 2.h),
                if (data.classroom?.name?.isNotEmpty == true)
                  Text(
                    data.classroom?.name ?? '',
                    style: TextStyle(
                      color: const Color(0xFF2A2A2A),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                SizedBox(height: 8.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildContactInfo(data.listCoaches?.first.type ?? '', data.listCoaches?.first.name ?? ''),
                    SizedBox(width: 16.w),
                    _buildContactInfo(data.listCoaches?.last.type ?? '', data.listCoaches?.last.name ?? ''),
                  ],
                )
              ],
            ),
            // SizedBox(width: 10.w,),
            CustomPaint(
              size: Size(1, 110.h),
              painter: DashedLinePainter(),
            ),
            // SizedBox(width: 10.w,),


            Container(
              // color: Colors.red,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Trạng thái',
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: 10.sp,
                    ),
                  ),
                  _statusWidget(data),
                  SizedBox(height: 40.h),
                  MyButton(
                    onPressed: (v) {
                      if (data.isBooking == true) {
                        onPressed.call();
                      } else {
                        MyPopupMessage.showPopUpWithIcon(
                          title: 'profile.notification'.tr(),
                          context: context,
                          barrierDismissible: false,
                          description: data.textIsBook ?? '',
                          colorIcon: MyColors.redColor,
                          iconAssetPath: 'booking/booking_not_data.svg',
                          confirmText: 'bookingClass.goBack'.tr(),
                        );
                      }
                    },
                    isEnable: (data.isFullSlot == false && data.status != 0),
                    height: 39.h,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                    ),
                    text: 'bookingClass.book'.tr(),
                    colorText: Colors.white,
                    color: (data.isFullSlot == true || data.status == 0)
                        ? MyColors.lightGrayColor.withOpacity(0.6)
                        : MyColors.mainColor,
                    border: Border.all(
                      width: 0.5,
                      color: (data.isFullSlot == true || data.status == 0)
                          ? MyColors.lightGrayColor.withOpacity(0.6)
                          : MyColors.mainColor,
                    ),
                    // border: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Extract repeated widget structure to a method
  Widget _buildContactInfo(String label, String name) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF6A6A6A),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          name,
          style: TextStyle(
            color: const Color(0xFF2A2A2A),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildButton(
      {required BuildContext context,
      required DataClass data,
      required Function() onRequest,
      required Function() onPressed}) {
    if (data.isFullSlot == true) {
      return MyButton(
        onPressed: (v) {
          onRequest.call();
        },
        isEnable: data.isRequestClassLesson == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: data.textRequestClassLesson ?? '',
        colorText: Colors.white,
        color: data.isRequestClassLesson == true
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color: data.isRequestClassLesson == true
              ? MyColors.lightGrayColor.withOpacity(0.6)
              : MyColors.mainColor,
        ),
        // border: null,
      );
    } else {
      return MyButton(
        onPressed: (v) {
          if (data.isBooking == true) {
            onPressed.call();
          } else {
            MyPopupMessage.showPopUpWithIcon(
              title: 'profile.notification'.tr(),
              context: context,
              barrierDismissible: false,
              description: data.textIsBook ?? '',
              colorIcon: MyColors.redColor,
              iconAssetPath: 'booking/booking_not_data.svg',
              confirmText: 'bookingClass.goBack'.tr(),
            );
          }
        },
        isEnable:
            data.status != 0 && data.status != 2 && data.isFullSlot == false,
        height: 35.h,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
        ),
        text: 'bookingClass.book'.tr(),
        colorText: Colors.white,
        color: (data.isFullSlot == true || data.status == 0 || data.status == 2)
            ? MyColors.lightGrayColor.withOpacity(0.6)
            : MyColors.mainColor,
        border: Border.all(
          width: 0.5,
          color:
              (data.isFullSlot == true || data.status == 0 || data.status == 2)
                  ? MyColors.lightGrayColor.withOpacity(0.6)
                  : MyColors.mainColor,
        ),
        // border: null,
      );
    }
  }

  _statusWidget(DataClass data) {
    Color? textColor;
    String text = '';
    if (data.status == 0) {
      textColor = const Color(0xFFFF0000);
      text = 'Đã kết thúc';
    } else if (data.status == 2) {
      textColor = const Color(0xFFF96800);
      text = 'Đang diễn ra';
    } else {
      textColor = const Color(0xFF07B25C);
      text = 'Sắp diễn ra';
    }

    return Text(
      text,
      textAlign: TextAlign.right,
      style: TextStyle(
        color: textColor,
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 5, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1;

    while (startY < size.height) {
      canvas.drawLine(
        Offset(0, startY),
        Offset(0, startY + dashHeight),
        paint,
      );
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
