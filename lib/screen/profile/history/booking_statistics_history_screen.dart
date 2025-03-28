import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

import '../../dashboard/booking_history/booking_history_screen.dart';

class BookingStatisticsHistoryScreen extends BookingHistoryScreen {
  static const String route = '/booking_statistics_statistics_screen';

  const BookingStatisticsHistoryScreen({super.key})
      : super(automaticallyImplyLeading: true);

  @override
  String? get title => 'global.history'.tr();

  @override
  Color? get backgroundColor => MyColors.backgroundColor;
}