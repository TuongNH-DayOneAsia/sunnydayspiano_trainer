import 'package:dayoneasia/screen/booking/booking_practice/practice_list/booking_practice_list_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/cubit/booking_practice_list_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class BookingDurationsWidget extends StatefulWidget {

  const BookingDurationsWidget({super.key});

  @override
  _BookingDurationsWidgetState createState() => _BookingDurationsWidgetState();
}

class _BookingDurationsWidgetState extends State<BookingDurationsWidget> {
  num? selectedDuration;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        final durations = state.durationsOutput?.data ?? [30, 60, 90];
        if (selectedDuration == null && durations.isNotEmpty) {
          selectedDuration = num.parse(state.listBookingInput.duration ?? '90');
        }
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 16.0.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('bookingClass.selectDuration'.tr(), style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400)),
                // SizedBox(
                //   height: 10.h,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: durations.map((duration) => _buildDurationItem(duration, state)).toList(),
                // ),
                Row(
                  children: [
                    Icon(
                      Icons.hourglass_empty,
                      color: MyColors.darkGrayColor,
                    ),
                    SizedBox(
                      width: 14.w,
                    ),
                    Text(
                      'bookingClass.selectDuration'.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: MyColors.darkGrayColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                ),
                const CustomSlider(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDurationItem(num duration, BookingPracticeListState state) {
    bool isSelected = duration == selectedDuration;

    return InkWell(
      onTap: () {
        setState(() {
          selectedDuration = duration;
        });
        context
            .read<BookingPracticeListCubit>()
            .emitDurationSelected(selectedDuration.toString());
      },
      child: Row(
        children: [
          Icon(
            isSelected
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: MyColors.mainColor,
            // color: isSelected ? Colors.white : MyColors.mainColor,
            size: 16.sp,
          ),
          SizedBox(width: 5.w),
          Text(
            '$duration ${'bookingClass.minutes'.tr()}',
            style: TextStyle(
              // color: isSelected ? Colors.white : MyColors.mainColor,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}