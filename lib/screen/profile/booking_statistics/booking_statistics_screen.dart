import 'dart:math';

import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/profile/booking_statistics/cubit/booking_statistics_cubit.dart';
import 'package:dayoneasia/screen/profile/history/booking_statistics_history_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/src/html_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class BookingStatisticsScreen extends BaseStatelessScreenV2 {
  static const String route = '/booking_statistics_screen';
  final ClassType? classType;

  const BookingStatisticsScreen({super.key, this.classType});

  @override
  Color get backgroundColor => MyColors.backgroundColor;

  @override
  String get title => classType?.name == ClassType.CLASS.name
      ? 'profile.groupClassBookingStatistics'.tr()
      : 'profile.groupPracticeBookingStatistics'.tr();

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => BookingStatisticsCubit(classType),
      child: _BuildBodyV2(classType: classType),
    );
  }
}

class _BuildBodyV1 extends StatefulWidget {
  const _BuildBodyV1();

  @override
  State<_BuildBodyV1> createState() => _BuildBodyV1State();
}

class _BuildBodyV1State extends State<_BuildBodyV1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMonthCard(),
                      SizedBox(height: 16.h),
                      _buildStatistics(),
                      if ((state.total ?? 0) > 0) ...[
                        SizedBox(height: 16.h),
                        // const CancelledScheduleCard(),
                        SizedBox(height: 16.h),
                        HtmlWidget(
                          state.statisticsOutput?.data?.messageNote ?? '',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if ((state.total ?? 0) > 0) _buildHistoryButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthCard() {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (state.statisticsYearsOutput?.data?.isEmpty == true) return;
            MyPopupMessage.showPopUpYears(
              context: context,
              iconAssetPath: '',
              yearSelected: state.yearSelected,
              dateSelected: state.monthSelected,
              listYears: state.statisticsYearsOutput?.data ?? [],
              onConfirm: (date, year) {
                context.read<BookingStatisticsCubit>().changeDate(date, year);
              },
            );
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'bookingClass.month ${state.dateSelected}'.tr(),
                    style: TextStyle(
                      color: MyColors.darkGrayColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Transform.rotate(
                    angle: 1.57,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: MyColors.lightGrayColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistics() {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        if ((state.total ?? 0) > 0) {
          return _buildStatisticsCard(state);
        } else {
          return _buildEmptyStatistics();
        }
      },
    );
  }

  Widget _buildEmptyStatistics() {
    return Center(
      child: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height * 0.18),
          MyAppIcon.iconNamedCommon(iconName: 'calendar-empty.svg'),
          SizedBox(height: 18.h),
          Text(
            'bookingClass.noBookingData'.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF6A6A6A),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard(BookingStatisticsState state) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              _buildStatisticsHeader(),
              SizedBox(height: 26.h),
              PieChartCustomWidget(
                data: state.listPoint ?? [],
                total: state.total.toString(),
              ),
              SizedBox(height: 26.h),
              _buildAttendanceStats(state),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatisticsHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'statistic.completeBooking'.tr(),
        style: TextStyle(
          color: const Color(0xFF3B3B3B),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(BookingStatisticsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.done_outline,
            count: state.statisticsOutput?.data?.booked ?? 0,
            label: 'bookingClass.booked'.tr(),
            subLabel: '',
            color: MyColors.mainColor,
            urlPath: 'booking/success.svg',
            widthIcon: 21.w,
          ),
        ),
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.check_circle_outline,
            count: state.statisticsOutput?.data?.attended ?? 0,
            label: 'bookingClass.classAttended'.tr(),
            subLabel: '(bookingClass.session)'.tr(),
            color: MyColors.emeraldGreenColor,
            urlPath: 'booking/heart.svg',
          ),
        ),
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.cancel_outlined,
            count: state.statisticsOutput?.data?.late ?? 0,
            label: 'bookingClass.classAbsent'.tr(),
            subLabel: '(bookingClass.maximum ${state.statisticsOutput?.data?.notYetClass ?? 0} bookingClass.times)'.tr(),
            color: Colors.red,
            urlPath: 'booking/cancel.svg',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: MyButton(
              width: Dimens.getProportionalScreenWidth(context, 295),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              border: Border.all(color: MyColors.mainColor, width: 1),
              text: 'global.history'.tr(),
              colorText: MyColors.mainColor,
              height: 38.h,
              onPressed: (_) {
                context.pop();
                EventBus.shared.goToScreenHistory();
              },
            ),
          ),
        );
      },
    );
  }
}

class _BuildBodyV2 extends StatefulWidget {
  final ClassType? classType;

  const _BuildBodyV2({super.key, this.classType});

  @override
  State<_BuildBodyV2> createState() => _BuildBodyV2State();
}

class _BuildBodyV2State extends State<_BuildBodyV2> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        print(' context.read<BookingStatisticsCubit>().inDev ${context.read<BookingStatisticsCubit>().inDev}');
        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildMonthCard(),
                      SizedBox(height: 16.h),
                      _buildStatistics(),
                      SizedBox(height: 16.h),
                      if (widget.classType == ClassType.CLASS ) ...[
                        // const CancelledScheduleCard(),
                        SizedBox(height: 16.h),
                        const TotalScheduleCard(),
                        SizedBox(height: 16.h),
                      ],
                      HtmlWidget(
                        state.statisticsOutput?.data?.messageNote ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              _buildHistoryButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMonthCard() {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            if (state.statisticsYearsOutput?.data?.isEmpty == true) return;
            MyPopupMessage.showPopUpYears(
              context: context,
              iconAssetPath: '',
              yearSelected: state.yearSelected,
              dateSelected: state.monthSelected,
              listYears: state.statisticsYearsOutput?.data ?? [],
              onConfirm: (date, year) {
                context.read<BookingStatisticsCubit>().changeDate(date, year);
              },
            );
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(16.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    state.dateSelected?.isNotEmpty == true ? 'bookingClass.month ${state.dateSelected}'.tr() : '',
                    style: TextStyle(
                      color: MyColors.darkGrayColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Transform.rotate(
                    angle: 1.57,
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 24,
                      color: MyColors.lightGrayColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistics() {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return _buildStatisticsCard(state);

        // if ((state.total ?? 0) > 0) {
        //   return _buildStatisticsCard(state);
        // } else {
        //   return _buildEmptyStatistics();
        // }
      },
    );
  }

  Widget _buildEmptyStatistics() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _buildStatisticsHeader(),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 18.h),
            MyAppIcon.iconNamedCommon(iconName: 'calendar-empty.svg'),
            SizedBox(height: 18.h),
            Text(
              'error.noData'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF6A6A6A),
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ))
      ],
    );
  }

  Widget _buildStatisticsCard(BookingStatisticsState state) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: EdgeInsets.all(16.0.w),
          child: (state.total ?? 0) > 0
              ? Column(
                  children: [
                    _buildStatisticsHeader(),
                    SizedBox(height: 26.h),
                    PieChartCustomWidget(
                      data: state.listPoint ?? [],
                      total: state.total.toString(),
                    ),
                    SizedBox(height: 26.h),
                    _buildAttendanceStats(state),
                    SizedBox(height: 16.h),
                  ],
                )
              : SizedBox(height: 300.h, child: _buildEmptyStatistics()),
        ),
      ),
    );
  }

  Widget _buildStatisticsHeader() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        'statistic.completeBooking'.tr(),
        style: TextStyle(
          color: const Color(0xFF3B3B3B),
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAttendanceStats(BookingStatisticsState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.done_outline,
            count: state.statisticsOutput?.data?.booked ?? 0,
            label: 'bookingClass.booked'.tr(),
            subLabel: '',
            color: MyColors.mainColor,
            urlPath: 'booking/success.svg',
            widthIcon: 21.w,
          ),
        ),
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.check_circle_outline,
            count: state.statisticsOutput?.data?.attended ?? 0,
            label: 'bookingClass.classAttended'.tr(),
            subLabel: '(bookingClass.session)'.tr(),
            color: MyColors.emeraldGreenColor,
            urlPath: 'booking/heart.svg',
          ),
        ),
        Expanded(
          child: AttendanceStatBox(
            icon: Icons.cancel_outlined,
            count: state.statisticsOutput?.data?.late ?? 0,
            label: 'bookingClass.classAbsent'.tr(),
            // subLabel: '(Tối đa ${state.statisticsOutput?.data?.notYetClass ?? 0} lần)',
            subLabel: widget.classType?.name == ClassType.CLASS.name
                ? ''
                : '(bookingClass.maximum ${state.statisticsOutput?.data?.notYetClass ?? 0} bookingClass.times)'.tr(),
            color: Colors.red,
            urlPath: 'booking/cancel.svg',
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryButton(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            child: MyButton(
              width: Dimens.getProportionalScreenWidth(context, 295),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              border: Border.all(color: MyColors.mainColor, width: 1),
              text: 'global.history'.tr(),
              colorText: MyColors.mainColor,
              height: 38.h,
              onPressed: (_) {
                // context.pop();
                // LocalStream.shared.goToScreenHistory();
                context.push(BookingStatisticsHistoryScreen.route);
              },
            ),
          ),
        );
      },
    );
  }
}

class DataPoint {
  final double value;
  final Color color;
  final Gradient? gradient;

  const DataPoint({
    required this.value,
    required this.color,
    this.gradient,
  });
}

class PieChartCustomWidget extends StatelessWidget {
  final List<DataPoint> data;
  final String total;

  const PieChartCustomWidget({super.key, required this.data, required this.total});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      data: data,
      radius: 80.h,
      child: Text(
        total,
        style: TextStyle(
          fontSize: 40.sp,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}

class PieChart extends StatelessWidget {
  const PieChart({
    required this.data,
    required this.radius,
    this.strokeWidth = 20,
    this.child,
    super.key,
  });

  final List<DataPoint> data;
  final double radius;
  final double strokeWidth;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _Painter(strokeWidth, data),
      size: Size.square(radius),
      child: SizedBox.square(
        dimension: radius * 2,
        child: Center(child: child),
      ),
    );
  }
}

class _PainterData {
  const _PainterData(this.paint, this.radians, {this.gradient});

  final Paint paint;
  final double radians;
  final Gradient? gradient;
}

class _Painter extends CustomPainter {
  _Painter(this.strokeWidth, this.data);

  final double strokeWidth;
  final List<DataPoint> data;
  static const _pi = 3.14159265359;

  late final List<_PainterData> dataList = _createDataList();

  List<_PainterData> _createDataList() {
    final totalPercent = data.fold<double>(0, (sum, data) => sum + data.value);
    return data.map((e) {
      final paint = Paint()
        ..color = e.gradient == null ? e.color : Colors.transparent
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      final radians = totalPercent > 0 ? (e.value / totalPercent) * (2 * _pi) : (2 * _pi / data.length);

      return _PainterData(paint, radians, gradient: e.gradient);
    }).toList();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    double startAngle = -_pi / 2 + _pi / 6;

    for (final data in dataList) {
      final path = Path()..addArc(rect, startAngle, data.radians);
      if (data.gradient != null) {
        final rectGradient = Rect.fromCircle(center: rect.center, radius: rect.width / 2);
        final gradientPaint = Paint()
          ..shader = data.gradient!.createShader(rectGradient)
          ..style = PaintingStyle.stroke
          ..strokeWidth = data.paint.strokeWidth;

        canvas.drawPath(path, gradientPaint);
      } else {
        canvas.drawPath(path, data.paint);
      }

      startAngle += data.radians;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate != this;
}

class CircularPercentPainter extends CustomPainter {
  CircularPercentPainter({
    required this.dataPoints,
    this.ringWidth = 20.0,
    this.innerRadius = 0.0,
    this.centerTextColor = const Color(0xFF363D44),
    required this.centerTextSpans,
  });

  final List<DataPoint> dataPoints;
  final double ringWidth;
  final double innerRadius;
  final Color centerTextColor;
  final List<TextSpan> centerTextSpans;

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final outerRadius = min(centerX, centerY) + ringWidth / 2;

    double totalValue = dataPoints.fold(0, (sum, dataPoint) => sum + dataPoint.value);

    double startAngle = -pi / 2;

    for (DataPoint dataPoint in dataPoints) {
      final sweepAngle = (dataPoint.value / totalValue) * 2 * pi;
      final endAngle = startAngle + sweepAngle;

      final paint = Paint()
        ..color = dataPoint.value > 0 ? dataPoint.color : const Color(0xFFDDE0E4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ringWidth;

      final rect = Rect.fromCircle(center: Offset(centerX, centerY), radius: outerRadius);
      canvas.drawArc(rect, startAngle, sweepAngle, false, paint);

      startAngle = endAngle;
    }

    if (innerRadius > 0) {
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      final innerRect = Rect.fromCircle(center: Offset(centerX, centerY), radius: innerRadius);
      canvas.drawArc(innerRect, 0, 2 * pi, true, innerPaint);
    }

    final textPainter = TextPainter(
      text: TextSpan(
        style: TextStyle(
          color: centerTextColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        children: centerTextSpans,
      ),
      textAlign: TextAlign.center,
    );

    textPainter.layout(maxWidth: size.width - ringWidth, minWidth: 0);

    final textX = centerX - textPainter.width / 2;
    final textY = centerY - textPainter.height / 2;

    textPainter.paint(canvas, Offset(textX, textY));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class AttendanceStatBox extends StatelessWidget {
  final IconData icon;
  final num count;
  final String label;
  final String subLabel;
  final Color color;
  final String urlPath;
  final double? widthIcon;

  const AttendanceStatBox(
      {super.key,
      required this.icon,
      required this.count,
      required this.label,
      required this.subLabel,
      required this.color,
      required this.urlPath,
      this.widthIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MyAppIcon.iconNamedCommon(
          iconName: urlPath,
          width: widthIcon ?? 21.w,
          height: widthIcon ?? 21.w,
        ),
        const SizedBox(height: 5),
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF3B3B3B),
          ),
        ),
        Text(
          subLabel,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6A6A6A),
          ),
        ),
      ],
    );
  }
}

class CancelledScheduleCard extends StatelessWidget {
  const CancelledScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Lịch đã hủy',
                          style: TextStyle(
                            color: const Color(0xFF3B3B3B),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Chỉ được hủy tối đa ${state.statisticsOutput?.data?.limitCancel ?? 0} lần',
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: const Color(0xFF6A6A6A),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      '${state.statisticsOutput?.data?.remaining ?? 0}/${state.statisticsOutput?.data?.limitCancel ?? 0} lần',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class TotalScheduleCard extends StatelessWidget {
  const TotalScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingStatisticsCubit, BookingStatisticsState>(
      builder: (context, state) {
        if(context.read<BookingStatisticsCubit>().inDev){
          return const SizedBox();
        }
        return Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(16.0.w),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Số buổi còn lại',
                      style: TextStyle(
                        color: const Color(0xFF3B3B3B),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '${state.statisticsOutput?.data?.numberShowContractAvailable ?? 0}/${state.statisticsOutput?.data?.numberShowContract ?? 0}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
