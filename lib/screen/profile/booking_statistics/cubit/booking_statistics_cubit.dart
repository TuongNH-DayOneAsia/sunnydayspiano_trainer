import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/profile/booking_statistics/booking_statistics_screen.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/output/statistics_output.dart';
import 'package:myutils/data/network/model/output/statistics_years_output.dart';
import 'package:myutils/data/repositories/booking_repository.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

part 'booking_statistics_state.dart';

class BookingStatisticsCubit extends WidgetCubit<BookingStatisticsState> {
  BookingStatisticsCubit(this.classType) : super(widgetState: const BookingStatisticsState());
  final BookingRepository _bookingRepository = injector();
  final ClassType? classType;

  @override
  void onWidgetCreated() => init();

  Future<void> init() => callApiStatisticsYears();

  Future<void> callApiStatisticsYears() async {
    try {
      final statisticsYearsOutput = await fetchApi(
        _bookingRepository.statisticsYears,
        showLoading: true,
      );

      final now = DateTime.now();
      final currentMonth = now.month.toString();
      final year = statisticsYearsOutput?.data?.lastOrNull?.toString() ?? now.year.toString();

      if (statisticsYearsOutput?.statusCode == ApiStatusCode.success) {
        if (statisticsYearsOutput?.data?.isEmpty ?? true) {
          emit(state.copyWith(
            monthSelected: currentMonth,
            dateSelected: '$currentMonth/${now.year}',
          ));
        } else {
          emit(state.copyWith(
            statisticsYearsOutput: statisticsYearsOutput,
            monthSelected: currentMonth,
            dateSelected: '$currentMonth/$year',
          ));
          await callApiStatistics(currentMonth);
        }
      }
    } catch (e) {
      handleError('Failed to fetch statistics years', e);
    }
  }

  Future<void> changeDate(String date, String year) async {
    emit(state.copyWith(
      yearSelected: year,
      monthSelected: date,
      dateSelected: '$date/$year',
      total: _calculateTotal(state.statisticsOutput?.data),
    ));
    await callApiStatistics(date);
  }

  Future<void> callApiStatistics(String date) async {
    try {
      final statisticsOutput = await fetchApi(
        () => _bookingRepository.statistics({
          'time': state.dateSelected ?? '',
          'type': (classType ?? ClassType.CLASS).name,
        },true),
        showLoading: true,
        millisecondsDelay: 1000
      );
      if (statisticsOutput?.statusCode == ApiStatusCode.success) {
        emit(_processStatisticsOutput(statisticsOutput));
      }
    } catch (e) {
      handleError('Failed to fetch statistics', e);
    }
  }

  BookingStatisticsState _processStatisticsOutput(StatisticsOutput? statisticsOutput) {
    final data = statisticsOutput?.data;
    final attended = (data?.attended ?? 0).toDouble();
    final late = (data?.late ?? 0).toDouble();
    final booked = (data?.booked ?? 0).toDouble();
    return state.copyWith(
      statisticsOutput: statisticsOutput,
      listPoint: _createDataPoints(late, attended, booked),
      total: _calculateTotal(data),
    );
  }

  int _calculateTotal(DataStatistics? data) {
    final attended = (data?.attended ?? 0).toDouble();
    final late = (data?.late ?? 0).toDouble();
    final booked = (data?.booked ?? 0);
    return (attended + late + booked).toInt();
  }

  List<DataPoint> _createDataPoints(double late, double attended, double booked) => [
        DataPoint(value: booked, color: MyColors.mainColor),
        DataPoint(value: late, color: Colors.red),
        DataPoint(
          value: attended,
          color: Colors.green,
          gradient: const LinearGradient(
            colors: [Color(0xFF7DD275), Color(0xFF47C272)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ];

  void handleError(String message, dynamic error) {
    if (kDebugMode) {
      print('$message: $error');
    }
    // Consider using a proper logging mechanism or error reporting service
  }
}
