import 'package:dayoneasia/screen/booking/booking_11/booking/cubit/booking_11_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_11/list_time_11_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';

class TimeGridViewV2 extends StatefulWidget {
  const TimeGridViewV2({super.key});

  @override
  _TimeGridViewStateV2 createState() => _TimeGridViewStateV2();
}

class _TimeGridViewStateV2 extends State<TimeGridViewV2> {
  String? startTime;
  String? endTime;
  late TimeSection selectedSection;

  @override
  void initState() {
    super.initState();
    EventBus.shared.refreshBooking11List = () {
      context.read<Booking11Cubit>().emitDataCalendarSelected();
    };
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.94, 0.34),
          end: Alignment(0.94, -0.34),
          colors: [
            Color(0xFFFFFAF6),
            Color(0xFFFFF8F1),
            Color(0xFFFFF9F3),
            Color(0xFFFFE5CD)
          ],
        ),
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 0.5),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildTitleSection(),
          Container(
              child: _buildDurationBadge()),
        ],
      ),
    );
  }

  Widget _buildTitleSection() {
    return Expanded(
      child: Row(
        children: [
          _buildColorIndicator(const Color(0xFFB6B6B6)),
          SizedBox(width: 4.w),
          _buildIndicatorText('Đã được đặt'),
          SizedBox(width: 4.w),
          _buildColorIndicator(const Color(0xFFFF8B00)),
          SizedBox(width: 4.w),
          _buildIndicatorText('Giờ bạn chọn'),
        ],
      ),
    );
  }

  Widget _buildColorIndicator(Color color) {
    return Container(
      width: 14.w,
      height: 14.w,
      decoration: ShapeDecoration(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              color == const Color(0xFFB6B6B6) ? 8.40 : 6),
        ),
      ),
    );
  }

  Widget _buildIndicatorText(String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: const Color(0xFF6A6A6A),
        fontSize: 10.sp,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _buildDurationBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'Thời lượng: 1 tiếng',
        style: TextStyle(
          fontSize: 12.sp,
          color: MyColors.mainColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Booking11Cubit, Booking11State>(
      builder: (context, state) => Card(
        margin: EdgeInsets.zero,
        child: Column(
          children: [
            _buildHeader(),
            // _buildTimeSelectionButtons(),
            _buildTimeGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeGrid(BuildContext context) {
    return BlocBuilder<Booking11Cubit, Booking11State>(
      builder: (context, state) {
        if (state.timeSlots?.isEmpty == true) {
          return Expanded(
            child: Center(
              child: Text(state.error ?? 'Không có dữ liệu'),
            ),
          );
        }

        return const _BuildListTime();
      },
    );
  }
}

class _BuildListTime extends StatefulWidget {
  const _BuildListTime();

  @override
  State<_BuildListTime> createState() => _BuildListTimeState();
}

class _BuildListTimeState extends State<_BuildListTime> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSection();
    });
  }

  void scrollToSection() {
    final now = DateTime.now();
    final state = context.read<Booking11Cubit>().state;
    final fullDate = state.dataCalendarSelected?.fullDate;

    if (fullDate == null) {
      return;
    }

    final dateTime = DateTime.parse(fullDate);
    if (dateTime.day != now.day) {
      _scrollToPosition(0);
      return;
    }

    final offset = _calculateOffset(now.hour);
    _scrollToPosition(offset);
  }

  double _calculateOffset(int hour) {
    final maxScroll = _scrollController.position.maxScrollExtent;

    if (hour < 12) return 0;  // Morning
    if (hour < 18) return maxScroll / 2;  // Afternoon
    return maxScroll;  // Evening
  }

  void _scrollToPosition(double offset) {
    _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut
    );
  }
  Widget _buildTimeSlot(
      BuildContext context, int index, DataTimeSlot? timeSlot) {
    if (timeSlot == null) return Container();

    return GestureDetector(
      onTap: () {
        context.read<Booking11Cubit>().toggleSelection(
              index: index,
              onBookedSlot: () {
                context.read<Booking11Cubit>().showToast(
                      'Khung giờ này đã được đặt. Vui lòng chọn khung giờ khác.',
                      toastGravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color(0xFFFFECEC),
                      textColor: const Color(0xFFFF4646),
                    );
              },
              onInsufficientTime: () {
                context.read<Booking11Cubit>().showToast(
                      'Đã hết giờ cho ngày hôm nay. Vui lòng chọn thời gian khác.',
                      toastGravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color(0xFFFFECEC),
                      textColor: const Color(0xFFFF4646),
                    );
              },
              onOverlappingBooking: () {
                context.read<Booking11Cubit>().showToast(
                      'Thời lượng chưa đủ cho một buổi học. Vui lòng chọn khung giờ khác',
                      toastGravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 1,
                      backgroundColor: const Color(0xFFFFECEC),
                      textColor: const Color(0xFFFF4646),
                    );
              },
              onTimeRangeSelected: (selectedRange) {},
              onClearSelection: () {},
            );
        // handleTimeSelection(index, context);
      },
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: _buildTimeSlotBgColor(timeSlot),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          timeSlot.time ?? '',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: _buildTimeSlotTextColor(timeSlot),
          ),
        ),
      ),
    );
  }

  Color _buildTimeSlotTextColor(DataTimeSlot timeSlot) {
    return timeSlot.isBooked == true
        ? Colors.white
        : timeSlot.isActive == false
            ? Colors.grey
            : timeSlot.isSelected == true
                ? MyColors.mainColor
                : const Color(0xFF2A2A2A);
  }

  Color? _buildTimeSlotBgColor(DataTimeSlot timeSlot) {
    return timeSlot.isSelected == true
        ? Colors.orange.withOpacity(0.2)
        : timeSlot.isBooked == true
            ? MyColors.lightGrayColor.withOpacity(0.5)
            : timeSlot.isActive == false
                ? null
                : Colors.white;
  }

  BoxDecoration _buildTimeSlotDecoration(
    bool isFirstSelected,
    bool isLastSelected,
    bool isSelected,
  ) {
    return BoxDecoration(
      color: isSelected ? const Color(0x0CFF8B00) : null,
      border: Border(
        left: isFirstSelected
            ? BorderSide(color: MyColors.mainColor, width: 4)
            : BorderSide.none,
        right: isLastSelected
            ? BorderSide(color: MyColors.mainColor, width: 4)
            : BorderSide.none,
      ),
      borderRadius: BorderRadius.only(
        topLeft: isFirstSelected ? const Radius.circular(12) : Radius.zero,
        bottomLeft: isFirstSelected ? const Radius.circular(12) : Radius.zero,
        topRight: isLastSelected ? const Radius.circular(12) : Radius.zero,
        bottomRight: isLastSelected ? const Radius.circular(12) : Radius.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<Booking11Cubit, Booking11State>(
      builder: (context, state) {
        return Expanded(
          child: RawScrollbar(
            thickness: 2,
            thumbColor: MyColors.mainColor,
            trackVisibility: true,
            controller: _scrollController,
            radius: const Radius.circular(20),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: GridView.builder(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                shrinkWrap: true,
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                  childAspectRatio: 1.9,
                ),
                itemCount: state.timeSlots?.length,
                itemBuilder: (context, index) =>
                    _buildTimeSlot(context, index, state.timeSlots?[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}

