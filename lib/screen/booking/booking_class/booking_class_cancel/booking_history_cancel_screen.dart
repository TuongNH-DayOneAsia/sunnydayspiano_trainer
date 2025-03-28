import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/widget/ab_booking_info_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class BookingClassCancelScreen extends AbClassInfoScreen {
  static const String route = '/booking-history-cancel';
  final String? _classId;
  final TypeViewBooking _typeViewBooking;

  const BookingClassCancelScreen({
    super.key,
    super.classId,
    required super.typeViewBooking,
  })  : _classId = classId,
        _typeViewBooking = typeViewBooking;
  @override
  void onBack({required BuildContext context, bool? value}) {
    Navigator.of(context).pop(true);
  }

  @override
  String? get classId => _classId;

  @override
  String? get title => 'bookingClass.canceledSchedule'.tr();

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget buttonWidget(BuildContext context) {
    return const SizedBox();
  }
}
