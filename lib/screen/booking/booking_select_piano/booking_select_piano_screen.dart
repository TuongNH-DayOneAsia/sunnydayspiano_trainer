import 'dart:ui';

import 'package:dayoneasia/screen/booking/booking_select_piano/booking_select_piano_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/output/list_piano_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../booking_class/class_detail/booking_class_detail_screen.dart';
import 'cubit/booking_select_piano_cubit.dart';

class BookingSelectPianoScreen extends BaseStatelessScreenV2 {
  final String? classId;
  final String? keyType;
  static const String route = '/booking-select-piano';

  const BookingSelectPianoScreen({
    super.key,
    this.keyType,
    this.classId,
  });

  @override
  String get title => 'Chọn vị trí đàn';

  @override
  bool get automaticallyImplyLeading => true;

  @override
  Color? get backgroundColor => Colors.white;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingSelectPianoCubit(keyType: keyType),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BookingSelectPianoCubit, BookingSelectPianoState>(
      builder: (context, state) {
        // if (state.isInitialLoading) {
        //   return const Center(child: CircularProgressIndicator());
        // } else if (state.error?.isNotEmpty == true) {
        //   return Center(child: Text(state.error!));
        // }
        return _BodyWidget(state: state, classId: classId);
      },
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final BookingSelectPianoState state;

  final String? classId;

  const _BodyWidget({required this.state, this.classId});

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  List<DataPiano> _pianos = [];

  @override
  void initState() {
    super.initState();

    _pianos = [
      DataPiano(instrumentCode: "CA01", isBooking: false),
      DataPiano(instrumentCode: "CA02", isBooking: true),
      DataPiano(instrumentCode: "CA03", isBooking: false),
      DataPiano(instrumentCode: "CA04", isBooking: false),
      DataPiano(instrumentCode: "CA05", isBooking: false),
      DataPiano(instrumentCode: "CA06", isBooking: true),
      DataPiano(instrumentCode: "CA07", isBooking: false),
      DataPiano(instrumentCode: "CA08", isBooking: false),
      DataPiano(instrumentCode: "CA09", isBooking: false),
      DataPiano(instrumentCode: "CA10", isBooking: false),
      DataPiano(instrumentCode: "CA11", isBooking: false),
      DataPiano(instrumentCode: "CA12", isBooking: false),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingSelectPianoCubit, BookingSelectPianoState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: MyColors.mainColor,
                onRefresh: () async {
                  await context.read<BookingSelectPianoCubit>().refresh();
                  return Future.delayed(const Duration(milliseconds: 1000));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 28.w,
                    ),
                    Text(
                      'Bục giảng',
                      style: TextStyle(
                        color: const Color(0xFF2A2A2A),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    MyAppIcon.iconNamedCommon(
                        iconName: 'booking/curved_dashed_line.svg'),
                    SizedBox(height: 26.h),
                    Expanded(
                        child: PianoGridWidget(
                      crossAxisCountFromApi: 4,
                      hasHeight: true,
                      isScroll: true,
                      onSelect: (dataPianoSelected) {
                        context
                            .read<BookingSelectPianoCubit>()
                            .selectPiano(dataPianoSelected);
                      },
                      pianos: _pianos,
                      dataPianoSelected: state.selectedPiano,
                    ))
                  ],
                ),
              ),
            ),
            SizedBox(height: 26.h),
            Column(
              children: [
                noteWidget(),
                // AnimatedSwitcher(
                //   duration: const Duration(milliseconds: 300),
                //   transitionBuilder:
                //       (Widget child, Animation<double> animation) {
                //     return FadeTransition(
                //       opacity: animation,
                //       child: SlideTransition(
                //         position: Tween<Offset>(
                //           begin: const Offset(0, 0.3),
                //           end: Offset.zero,
                //         ).animate(animation),
                //         child: child,
                //       ),
                //     );
                //   },
                //   child: state.selectedPiano == null
                //       ? Visibility(
                //           visible: _pianos.isNotEmpty,
                //           child: Column(
                //             key: const ValueKey("warning_text"),
                //             children: [
                //               SizedBox(height: 10.h),
                //               Text(
                //                 '* Vui lòng chọn chỗ trống',
                //                 textAlign: TextAlign.center,
                //                 style: TextStyle(
                //                   color: const Color(0xFFFF4545),
                //                   fontSize: 14.sp,
                //                   fontWeight: FontWeight.w400,
                //                 ),
                //               ),
                //             ],
                //           ),
                //         )
                //       : const SizedBox.shrink(),
                // ),
                Stack(
                  children: [
                    CustomPaint(
                      size: Size(double.infinity, 200.h),
                      painter: CurvedPainter(),
                    ),
                    Positioned(
                      top: 0,
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          HtmlWidget(
                            context
                                .read<BookingSelectPianoCubit>()
                                .noteBookingClass,
                          ),
                          _buildBookingButton(context, state),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildBookingButton(
      BuildContext context, BookingSelectPianoState state) {
    return Container(
      // color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: MyButton(
          width: Dimens.getProportionalScreenWidth(context, 295),
          fontSize: 14.sp,
          text: 'Tiếp tục',
          isEnable:
              context.read<BookingSelectPianoCubit>().isEnableButtonBook(),
          color: context.read<BookingSelectPianoCubit>().isEnableButtonBook()
              ? MyColors.mainColor
              : MyColors.lightGrayColor.withOpacity(0.6),
          border: Border.all(
            color: context.read<BookingSelectPianoCubit>().isEnableButtonBook()
                ? MyColors.mainColor
                : MyColors.lightGrayColor.withOpacity(0.6),
            width: 0.5,
          ),
          height: 38.h,
          onPressed: (value) {
            if (kDebugMode) {
              print(
                  'state.selectedPiano: ${state.selectedPiano?.instrumentCode ?? ''}');

              context
                  .push(BookingClassDetailsScreen.route, extra: widget.classId)
                  .then((value) {
                if (value == true) {
                  context.pop(true);
                }
              });
            }
          },
        ),
      ),
    );
  }
}

class CurvedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange.withOpacity(0.2)
      ..style = PaintingStyle.fill;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, size.height * 0.3, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CurvedDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Create a curved path
    Path path = Path();
    path.moveTo(0, size.height / 2);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height / 2);

    // Draw a dashed line along the path
    double dashWidth = 5;
    double dashSpace = 5;
    double distance = 0;

    for (PathMetric pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        double nextDistance = distance + dashWidth;
        if (nextDistance > pathMetric.length) {
          nextDistance = pathMetric.length;
        }

        canvas.drawPath(
          pathMetric.extractPath(distance, nextDistance),
          paint,
        );

        distance = nextDistance + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget noteWidget() {
  List<Map<String, dynamic>> legends = [
    {'color': MyColors.grey, 'text': 'Chỗ đã được đặt', 'hasBorder': false},
    {'color': const Color(0xFFFF8B00), 'text': 'Chỗ trống', 'hasBorder': true},
    {
      'color': const Color(0xFFFF8B00),
      'text': 'Chỗ bạn chọn',
      'hasBorder': false
    },
  ];

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: legends
        .map((item) => Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 17.w,
                    height: 17.w,
                    decoration: BoxDecoration(
                      color: item['hasBorder'] ? null : item['color'],
                      border: item['hasBorder']
                          ? Border.all(width: 1.5, color: item['color'])
                          : null,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    item['text'],
                    style: TextStyle(
                      color: const Color(0xFF6A6A6A),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ))
        .toList(),
  );
}
