import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';

extension DateTimeExtension on DateTime {




  String toVietnameseWeekdayString() {
    initializeDateFormatting('vi_VN', null);
    return DateFormat('E', 'vi_VN').format(this);
  }

  String toVietnameseDateString() {
    initializeDateFormatting('vi_VN', null);
    return DateFormat('Md', 'vi_VN').format(this);
  }

  String toVietnameseDateTimeString() {
    initializeDateFormatting('vi_VN', null);
    return DateFormat('dd/MM/yyyy HH:mm', 'vi_VN').format(this);
  }
}