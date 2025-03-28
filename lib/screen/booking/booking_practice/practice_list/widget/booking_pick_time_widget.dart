import 'package:dayoneasia/screen/booking/booking_practice/practice_list/cubit/booking_practice_list_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';

class BookingPickTimeWidget extends StatelessWidget {
  const BookingPickTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        final isEnabled = state.dataBranchSelected != null;
        print('state.listBookingInput.startTime ${state.listBookingInput.startTime} ');
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          elevation: 0,
          child: InkWell(
            onTap: isEnabled ? () => _showTimePickerPopup(context) : null,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 20.0.w),
              child: Row(
                children: [
                  _buildLeadingIcon(isEnabled),
                  SizedBox(width: 14.w),
                  _buildTitle(isEnabled),
                  const Spacer(),
                  _buildTrailingWidget(state, isEnabled),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTrailingWidget(BookingPracticeListState state, bool isEnabled) {
    if (!isEnabled || state.listBookingInput.startTime == null) {
      return Icon(
        Icons.arrow_forward_ios_rounded,
        color: Colors.grey,
        size: 12.sp,
      );
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFF3F3F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        state.listBookingInput.startTime ?? '',
        style: TextStyle(
          color: MyColors.darkGrayColor,
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildLeadingIcon(bool isEnabled) {
    return Icon(
      Icons.access_time,
      color: isEnabled ? MyColors.darkGrayColor : MyColors.darkGrayColor.withOpacity(0.5),
      size: 20.sp,
    );
  }

  Widget _buildTitle(bool isEnabled) {
    return Text(
      'bookingPractice.startTime'.tr(),
      style: TextStyle(
        color: isEnabled ? MyColors.darkGrayColor : MyColors.darkGrayColor.withOpacity(0.5),
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _showTimePickerPopup(BuildContext context) {
    MyPopupMessage.showPopUpPickTime(
      classStartDate: context.read<BookingPracticeListCubit>().state.listBookingInput.classStartDate?.isNotEmpty == true
          ? DateTime.parse(context.read<BookingPracticeListCubit>().state.listBookingInput.classStartDate ?? '')
          : DateTime.now(),
      confirmText: 'bookingPractice.select'.tr(),
      context: context,
      barrierDismissible: false,
      cancelText: 'bookingClass.goBack'.tr(),
      iconAssetPath: 'booking/success.svg',
      colorIcon: MyColors.greenColor,
      onCancel: () {},
      onConfirm: (date) {
        context.read<BookingPracticeListCubit>().emitTimeSelected(date);
      },
      minimumDateString: context.read<BookingPracticeListCubit>().minimumDateString,
      maximumDateString: context.read<BookingPracticeListCubit>().maximumDateString,
      minuteInterval: int.parse(context.read<BookingPracticeListCubit>().minuteInterval),
    );
  }
}
