import 'package:dayoneasia/screen/booking/booking_class/class_list/widget/booking_select_branch_widget.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/booking_practice_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/widget/booking_durations_widget.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/widget/booking_list_piano_widget.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/widget/booking_pick_time_widget.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_list/widget/booking_seat_selection_legend_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/menus_in_home_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/image_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/booking_practice_list_cubit.dart';

class BookingPracticeListScreen extends BaseStatelessScreenV2 {
  final DataMenuV3? data;
  static const String route = '/booking-practice';

  const BookingPracticeListScreen({
    super.key,
    this.data,
  });

  @override
  String get title => 'home.schedulePracticeRoom'.tr().replaceAll('\n', ' ');

  @override
  bool get automaticallyImplyLeading => true;

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BookingPracticeListCubit(data: data)
        ..loadInitialData()
        ..callApiBannerClass(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        if (state.isInitialLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.error?.isNotEmpty == true) {
          return Center(child: Text(state.error!));
        }
        return _BodyWidget(state: state);
      },
    );
  }
}

class _BodyWidget extends StatefulWidget {
  final BookingPracticeListState state;

  const _BodyWidget({required this.state});

  @override
  State<_BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<_BodyWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    EventBus.shared.refreshPracticeList = () {
      context
          .read<BookingPracticeListCubit>()
          .listPiano(widget.state.listBookingInput.startTime ?? '');
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                color: MyColors.mainColor,
                onRefresh: () async {
                  await context.read<BookingPracticeListCubit>().refresh();
                  return Future.delayed(const Duration(milliseconds: 1000));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      _buildBranchesList(context),
                      SizedBox(height: 26.h),
                      _buildCurrentWeekTab(context),
                      SizedBox(height: 16.h),
                      _buildPickTimeWidget(),
                      SizedBox(height: 16.h),
                      _buildDurations(),
                      SizedBox(height: 16.h),
                      // SizedBox(height: 24.h),
                      _buildPianoList(state),
                      if (state.listPianoOutput?.data?.isNotEmpty == true) ...[
                        // SizedBox(height: 16.h),
                        _buildSeatSelectionLegend(),
                        // Center(child: noteWidget()),
                        SizedBox(height: 16.h),
                        _buildDivider(),
                        SizedBox(height: 8.h),
                        _buildNoteText(context),
                      ],
                      Padding(
                        padding: EdgeInsets.all(14.w),
                        child: HtmlWidget(
                          context
                              .read<BookingPracticeListCubit>()
                              .noteBookingClassPractice,
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ),
            _buildBookingButton(context, state),
          ],
        );
      },
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0.sp),
      child: const Divider(
        color: Color(0xFFE5E5E5),
        thickness: 1,
        height: 1,
      ),
    );
  }

  Widget _buildDurations() {
    return const BookingDurationsWidget();
  }

  Widget _buildSeatSelectionLegend() {
    return const BookingSeatSelectionLegend();
  }

  Widget _buildPickTimeWidget() {
    return const BookingPickTimeWidget();
  }

  Widget _buildBackgroundImage() {
    return SizedBox(
      width: double.infinity,
      child: MyImage.imgFromCommon(
        assetName: 'assets/images/background_booking.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildBranchesList(BuildContext context) {
    return widget.state.branches == null
        ? const SizedBox.shrink()
        : BookingSelectBranchWidget(
            branches: widget.state.branches!,
            dataSelected: widget.state.dataBranchSelected,
            onSelectBranch: (value) {
              context.read<BookingPracticeListCubit>().emitIndexBranchSelected(value);
            },
            banners: widget.state.bannerClassTypeOutput?.data ?? [],
          );
  }

  Widget _buildCurrentWeekTab(BuildContext context) {
    return widget.state.currentWeek == null
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: MyTabbedPage2<DataCalendar>(
              items: widget.state.currentWeek!,
              titleBuilder: (date) => date.day.toString(),
              subtitleBuilder: (date) => date.date.toString(),
              onTap: (index) {
                context.read<BookingPracticeListCubit>().filter(
                    dateSelected:
                        widget.state.currentWeek![index].fullDate ?? '');
              },
            ),
          );
  }

  Widget _buildPianoList(BookingPracticeListState state) {
    if (state.listPianoOutput?.data?.isEmpty ?? true) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        child: Text(
          state.textEmptyPiano ?? '',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: MyColors.lightGrayColor,
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            // height: 0.12,
          ),
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Center(
            child: Text(
              'bookingPractice.selectPianoEmpty'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.darkGrayColor,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        // SizedBox(
        //   height: 30.h,
        // ),
        const BookingListPianoWidget(),
      ],
    );
  }

  Widget _buildNoteText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Center(
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: DefaultTextStyle.of(context).style,
            children: <TextSpan>[
              TextSpan(
                text: '${'bookingClass.noteShort'.tr()}: ',
                style: TextStyle(
                  color: const Color(0xFFFF4444),
                  fontSize: 12.sp,
                ),
              ),
              TextSpan(
                text: 'bookingPractice.availablePiano'.tr(),
                style: TextStyle(
                  color: const Color(0xFF6A6A6A),
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingButton(BuildContext context, BookingPracticeListState state) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: MyButton(
          width: Dimens.getProportionalScreenWidth(context, 295),
          fontSize: 14.sp,
          text: 'bookingClass.bookNow'.tr(),
          isEnable: context.read<BookingPracticeListCubit>().isEnableButtonBook(),
          color: context.read<BookingPracticeListCubit>().isEnableButtonBook()
              ? MyColors.mainColor
              : MyColors.lightGrayColor.withOpacity(0.6),
          border: Border.all(
            color: context.read<BookingPracticeListCubit>().isEnableButtonBook()
                ? MyColors.mainColor
                : MyColors.lightGrayColor.withOpacity(0.6),
            width: 0.5,
          ),
          height: 38.h,
          onPressed: (value) => _showBookingConfirmation(context),
        ),
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    MyPopupMessage.confirmPopUp(
        cancelText: 'bookingClass.goBack'.tr(),
        cancelColor: MyColors.lightGrayColor2,
        confirmColor: MyColors.emeraldGreenColor,
        width: Dimens.getScreenWidth(context),
        fontWeight: FontWeight.w500,
        confirmText: 'bookingClass.confirm'.tr(),
        title: 'bookingClass.confirmBooking'.tr(),
        context: context,
        barrierDismissible: false,
        description: 'bookingClass.confirmBookingMessage'.tr(),
        onConfirm: () {
          context.read<BookingPracticeListCubit>().callApiBook(
              onBookingSuccess: (DataBooking? dataBooking) {
            _showPopUpSuccess(context, dataBooking);
          }, onBookingError: (String message) {
            _showPopupError(
                context: context,
                description: message,
                title: 'bookingClass.bookingFailed'.tr());
          }, onBookingBlock: (String v) {
            _showCancelBookingConfirmation(
              context: context,
              messageNote: v,
            );
          });
        });
  }

  void _showCancelBookingConfirmation(
      {required BuildContext context, required String messageNote}) {
    MyPopupMessage.confirmPopUpHTML(
      iconAssetPath: 'booking/booking_not_data.svg',
      cancelText: 'bookingClass.goBack'.tr(),
      confirmColor: MyColors.redColor,
      width: Dimens.getScreenWidth(context),
      fontWeight: FontWeight.w500,
      confirmText: 'bookingClass.cancelBooking'.tr(),
      title: 'Tính năng đã bị tạm khóa',
      context: context,
      barrierDismissible: false,
      isTextTitleCenter: true,
      description: 'bookingClass.confirmCancelBookingMessage'.tr(),
      htmlContent: messageNote,
    );
  }

  void _showPopUpSuccess(BuildContext context, DataBooking? dataBooking) {
    MyPopupMessage.showPopUpWithIcon(
        confirmText: 'bookingClass.details'.tr(),
        title: 'bookingClass.bookingSuccess'.tr(),
        context: context,
        barrierDismissible: false,
        cancelText: 'bookingClass.goBack'.tr(),
        subtitle: 'bookingClass.note'.tr(),
        description: context
            .read<BookingPracticeListCubit>()
            .textBookingSuccessDes(dataBooking),
        iconAssetPath: 'booking/success.svg',
        colorIcon: MyColors.greenColor,
        onCancel: () {},
        onConfirm: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.push(BookingPracticeDetailScreen.route,
                extra: {'bookingCode': dataBooking?.bookingCode ?? ''});
          });
        });
  }

  void _showPopupError(
      {required BuildContext context,
      required String description,
      required String title}) {
    MyPopupMessage.showPopUpWithIcon(
      title: title,
      context: context,
      barrierDismissible: false,
      description: description,
      colorIcon: MyColors.redColor,
      iconAssetPath: 'booking/booking_not_data.svg',
      confirmText: 'bookingClass.goBack'.tr(),
    );
  }
}



class CustomSlider extends StatefulWidget {
  const CustomSlider({super.key});

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double? _value;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingPracticeListCubit, BookingPracticeListState>(
      builder: (context, state) {
        final durations = state.durationsOutput?.data ?? [30, 60, 90];
        if (_value == null && durations.isNotEmpty) {
          _value = double.parse(state.listBookingInput.duration ?? '30');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: MyColors.darkGrayColor,
                inactiveTrackColor: MyColors.lightGrayColor,
                thumbColor: Colors.white,
                overlayColor: Colors.black.withAlpha(32),
                overlayShape: SliderComponentShape.noOverlay,
                trackHeight: 2.5,
                activeTickMarkColor: MyColors.darkGrayColor,
                inactiveTickMarkColor: MyColors.lightGrayColor,
                tickMarkShape:
                    const RoundSliderTickMarkShape(tickMarkRadius: 5),
                trackShape: const RectangularSliderTrackShape(),
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 10.0),
              ),
              child: Slider(
                value: _value ?? 30,
                min: 0,
                max: 90,
                divisions: 3,
                onChanged: (value) {
                  setState(() {
                    if (value < 30) {
                      _value = 30;
                      context.read<BookingPracticeListCubit>().emitDurationSelected(
                          (_value?.toInt() ?? 30).toString());
                    } else {
                      _value = value;
                      context.read<BookingPracticeListCubit>().emitDurationSelected(
                          (_value?.toInt() ?? 30).toString());
                    }
                  });
                },
              ),
            ),
            SizedBox(
              height: 8.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: durations
                  .map((duration) => _buildLabel(
                      duration.toInt(), 'bookingClass.minutes'.tr()))
                  .toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildLabel(int value, String unit) {
    final isSelected = _value == value;
    final textColor = value == 0
        ? Colors.white
        : (isSelected ? MyColors.darkGrayColor : MyColors.lightGrayColor);
    return Column(
      children: [
        Text(
          '$value',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
            color: textColor,
          ),
        ),
        Text(
          unit,
          style: TextStyle(
            fontSize: 12.sp,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
