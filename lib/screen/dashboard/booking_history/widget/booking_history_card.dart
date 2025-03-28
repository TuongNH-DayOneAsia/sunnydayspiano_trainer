import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/data/network/model/output/history_booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../cubit/booking_history_cubit.dart';

  class BookingHistoryCard extends StatelessWidget {
    final DataHistoryBooking data;
    final Function() onPressed;

    const BookingHistoryCard({
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.classLessonStartDate ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 12.sp,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          data.classTypeName ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16.sp,
                            color: MyColors.darkGrayColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 70.h,
                    child: VerticalDivider(
                      color: MyColors.lightGrayColor,
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.branchName ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.lightGrayColor2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          data.classroomName ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.lightGrayColor2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          data.type == ClassType.CLASS.name
                              ? '${'bookingClass.coachInClass'.tr()}: ${data.coach ?? ''}'
                              : data.instrumentStartEndTime ?? '',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: MyColors.lightGrayColor2,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        if (data.type != ClassType.CLASS.name &&
                            data.type != ClassType.CLASS_PRACTICE.name)
                          Text(
                            data.coach ?? '',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: MyColors.lightGrayColor2,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.black, fontSize: 14),
                      children: [
                        TextSpan(
                          text: "${data.statusBookingText ?? ''}\n",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: Color(int.parse(
                                data.statusBookingColor ?? '0xFF000000')),
                          ),
                        ),
                        TextSpan(
                          text: "${data.statusInClassText ?? ''}\n",
                          style: GoogleFonts.beVietnamPro(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w300,
                            color: Color(int.parse(
                                data.statusInClassColor ?? '0xFF000000')),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Text(
                  //   data.id.toString() ?? '',
                  //   style: TextStyle(
                  //     fontWeight: FontWeight.w400,
                  //     fontSize: 12.sp,
                  //   ),
                  // ),
                  MyButton(
                    border: Border.all(color: MyColors.lightGrayColor, width: 1),
                    onPressed: (v) {
                      onPressed.call();
                    },
                    fontSize: 12.sp,
                    height: 35.h,
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    text: 'bookingClass.details'.tr(),
                    colorText: MyColors.lightGrayColor2,
                    color: Colors.white,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }
