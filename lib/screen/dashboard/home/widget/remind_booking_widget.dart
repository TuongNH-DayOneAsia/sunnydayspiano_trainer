import 'dart:async';

import 'package:dayoneasia/screen/booking/booking_11/detail/booking_11_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/cubit/home/home_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/remind_booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:shimmer/shimmer.dart';

class RemindBookingWidget extends StatefulWidget {
  const RemindBookingWidget({super.key});

  @override
  State<RemindBookingWidget> createState() => _RemindBookingWidgetState();
}

class _RemindBookingWidgetState extends State<RemindBookingWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    LocalStream.shared.refreshDataInHome = () {
      context.read<HomeCubit>().remindBooking();
      context.read<HomeCubit>().menusInHome();
      // context.read<HomeCubit>().bookingClassTypesV3();
    };
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
        stream: LocalStream.shared.localeStream,
        builder: (context, snapshot) {
          return BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {

              if(state.remindBookingOutput== null){
                  return buildShimmerLoadingEffect();
              } else if (state.remindBookingOutput?.data?.isEmpty ?? false) {
                return _noData(message: state.remindBookingOutput?.message ?? '---');
              } else {
                return const _InfoDataWidget();
              }
            },
          );
        });
  }
  Widget buildShimmerLoadingEffect() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(52),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  // Icon placeholder
                  Container(
                    width: 24.w,
                    height: 24.h,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Title placeholder
                      Container(
                        width: 100.w,
                        height: 12.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      // Message placeholder
                      Container(
                        width: 150.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _noData({required String message}) {
    if (message.isEmpty == true) return const SizedBox();
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Card(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(52),
        ),
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  MyAppIcon.iconNamedCommon(iconName: 'remind-booking.svg'),
                  SizedBox(width: 8.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'home.upcomingReminder'.tr(),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: MyColors.lightGrayColor2,
                        ),
                      ),
                      Text(
                        message,
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoDataWidget extends StatefulWidget {
  const _InfoDataWidget({super.key});

  @override
  State<_InfoDataWidget> createState() => _InfoDataWidgetState();
}

class _InfoDataWidgetState extends State<_InfoDataWidget> {
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16.w),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          final remindBookings = state.remindBookingOutput?.data;
          final itemCount = remindBookings?.length ?? 0;
          if (remindBookings == null) return const SizedBox();
          return Column(
            children: [
              itemCount == 0
                  ? _buildEmptyState(state.remindBookingOutput?.message ?? '')
                  : _buildExpandablePageView(remindBookings ?? [], itemCount),
              if (itemCount > 1) ...[
                SizedBox(height: 8.h),
                _buildDotIndicator(itemCount),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(52)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.w),
        child: child,
      ),
    );
  }

  Widget _buildInfoText(String? text) {
    return Text(
      text ?? '',
      style: TextStyle(color: MyColors.lightGrayColor2),
    );
  }

  Widget _buildEmptyState(String message) {
    return _buildCard(
      child: Row(
        children: [
          MyAppIcon.iconNamedCommon(iconName: 'noti.svg'),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                ),
                _buildInfoText('Đặt lịch ngay'),
              ],
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
            size: 14,
          )
        ],
      ),
    );
  }

  Widget _buildExpandablePageView(List<DataRemindBooking> remindBookings, int itemCount) {
    if (remindBookings.isEmpty == true) {
      return _buildEmptyState('Bạn chưa có lịch nào');
    }
    return _BuildExpandablePageView(
      remindBookings: remindBookings,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
    );
  }

  Widget _buildDotIndicator(int itemCount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemCount,
        (index) => Container(
          // width: _currentPage == index ? 28.w : 4.w,
          width: 4.w,
          height: 4.w,
          margin: EdgeInsets.symmetric(horizontal: 2.w),
          decoration: BoxDecoration(
            shape: _currentPage == index ? BoxShape.rectangle : BoxShape.circle,
            color: _currentPage == index ? MyColors.mainColor : MyColors.lightGrayColor,
            borderRadius: _currentPage == index ? BorderRadius.circular(4.w) : null,
          ),
        ),
      ),
    );
  }
}

class _BuildExpandablePageView extends StatefulWidget {
  final List<DataRemindBooking> remindBookings;
  final Function(int) onPageChanged;

  const _BuildExpandablePageView({super.key, required this.remindBookings, required this.onPageChanged});

  @override
  State<_BuildExpandablePageView> createState() => _BuildExpandablePageViewState();
}

class _BuildExpandablePageViewState extends State<_BuildExpandablePageView> {
  int _currentPage = 0;
  bool _isUserInteracting = false;
  Timer? _timer;
  final PageController _pageController = PageController(
    initialPage: 0,
  );

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && !_isUserInteracting) {
        int nextPage = _currentPage == widget.remindBookings.length - 1 ? 0 : _currentPage + 1;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  void _stopAutoScroll() {
    _timer?.cancel();
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          _isUserInteracting = true;
          _stopAutoScroll();
        } else if (notification is ScrollEndNotification) {
          _isUserInteracting = false;
          _startAutoScroll();
        }
        return true;
      },
      child: GestureDetector(
        onPanDown: (_) {
          _isUserInteracting = true;
          _stopAutoScroll();
        },
        onPanEnd: (_) {
          _isUserInteracting = false;
          _startAutoScroll();
        },
        child: ExpandablePageView.builder(
          controller: _pageController,
          itemCount: widget.remindBookings.length,
          itemBuilder: (context, index) => _buildBookingCard(context, widget.remindBookings[index]),
          onPageChanged: (index) {
            Future.microtask(() {
              if (mounted) {
                setState(() => _currentPage = index);
                widget.onPageChanged(index);
              }
            });
          },
        ),
      ),
    );
  }

  Widget _buildInfoText({String? text, IconData? icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFF7F7F7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon ?? Icons.calendar_month,
            color: MyColors.lightGrayColor2,
            size: 12.sp,
          ),
          const SizedBox(width: 4),
          Text(
            text ?? '',
            style: TextStyle(color: MyColors.lightGrayColor2, fontSize: 12.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _navigateToBookingDetails(BuildContext context, DataRemindBooking? data) {
    if (data?.type == ClassType.CLASS_PRACTICE.name) {
      context.push(BookingPracticeDetailScreen.route,
          extra: {'bookingCode': data?.bookingCode ?? '', 'refreshAction': RefreshAction.refreshDataInHome});
    } else if (data?.type == ClassType.CLASS.name) {
      context.push(
        BookingClassDetailScreen.route,
        extra: {
          'bookingCode': data?.bookingCode ?? '',
          'refreshAction': RefreshAction.refreshDataInHome,
        },
      );
    }else{
      context.push(Booking11DetailScreen.route, extra: {
        'mode': Booking11DetailScreenMode.detail,
        'bookingCode': data?.bookingCode ?? '',
        'refreshAction': RefreshAction.refreshDataInHome,
      });
    }
  }

  Widget _buildCard({required Widget child}) {
    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(52)),
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: child,
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, DataRemindBooking? data) {
    return Padding(
      padding: EdgeInsets.only(right: 16.w),
      child: GestureDetector(
        onLongPressStart: (_) {
          _isUserInteracting = true;
          _stopAutoScroll();
        },
        onLongPressEnd: (_) {
          _isUserInteracting = false;
          _startAutoScroll();
        },
        child: InkWell(
          onTap: () => _navigateToBookingDetails(context, data),
          child: _buildCard(
            child: Row(
              children: [
                MyAppIcon.iconNamedCommon(
                  iconName: 'remind-booking.svg',
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data?.classType ?? '',
                        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 4.h,
                      ),
                      Row(
                        children: [
                          _buildInfoText(text: data?.date),
                          SizedBox(
                            width: 8.h,
                          ),
                          _buildInfoText(text: data?.time, icon: Icons.access_time),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: MyColors.darkGrayColor,
                  size: 14.sp,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.time,
    required this.title,
    required this.room,
  });

  final String time;
  final String title;
  final String room;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(
            color: Colors.orange,
            width: 4,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Hôm nay',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Phòng: $room',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
