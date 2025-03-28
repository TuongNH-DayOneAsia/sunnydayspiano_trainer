import 'package:dayoneasia/screen/booking/booking_class/booking_class_cancel/booking_history_cancel_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/widget/ab_booking_info_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class BookingClassDetailScreen extends AbClassInfoScreen {
  static const String route = '/booking-class-detail';
  final String? _classId;
  final TypeViewBooking _typeViewBooking;
  final RefreshAction? refreshAction;

  const BookingClassDetailScreen({
    super.key,
    super.classId,
    this.refreshAction,
    required super.typeViewBooking,
  })  : _classId = classId,
        _typeViewBooking = typeViewBooking;

  @override
  String? get classId => _classId;

  @override
  String? get title => 'bookingClass.bookedSchedule'.tr();

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  void onBack({required BuildContext context, bool? value}) {
    Navigator.of(context).pop(true);
  }
  @override
  Widget? buildTitle(BuildContext context) {
    return BlocBuilder<BookingClassDetailCubit, BookingClassDetailState>(
      builder: (context, state) {
        return Text(
          state.dataClass?.statusBooking == null
              ? ''
              :    state.dataClass?.statusBooking == 1
              ? "Lịch đã đặt"
              : "Lịch đã huỷ",
          style: GoogleFonts.beVietnamPro(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: (appColorTransparent ?? false) ? Colors.white : Colors.black,
          ),
        );
      },
    );
  }
  @override
  Widget buttonWidget(BuildContext context) {
    print('refreshAction $refreshAction');
    if (!context.read<BookingClassDetailCubit>().showButtonCancel()) {
      return const SizedBox();
    }
    return Align(
      alignment: Alignment.bottomRight,
      child: RippleTextButton(
        onPressed: () {
          context.read<BookingClassDetailCubit>().countBookingCancel(onSuccess: (data) {
            _showPopupHtml(
                context: context,
                bookingCode: classId ?? '',
                refreshAction: refreshAction ?? RefreshAction.refreshPracticeList,
                data: data);
          }, onError: (message) {
            MyPopupMessage.showPopUpWithIcon(
              title: title,
              context: context,
              barrierDismissible: false,
              description: message,
              colorIcon: MyColors.redColor,
              iconAssetPath: 'booking/booking_not_data.svg',
              confirmText: 'bookingClass.goBack'.tr(),
            );
          }, onBookingBlock: (v) {
            _showPopupHtml(
                context: context,
                bookingCode: classId ?? '',
                refreshAction: refreshAction ?? RefreshAction.refreshPracticeList,
                data: DataCancelBooking(blockUserBooking: true, messageNote: v));
          });
        },
        textDecoration: TextDecoration.underline,
        text: 'bookingClass.cancelBooking'.tr(),
        color: MyColors.lightGrayColor2,
      ),
    );
  }

  void _showPopupHtml(
      {required BuildContext context,
      required String bookingCode,
      String? title,
      String? iconAssetPath,
      bool? isTextTitleCenter,
      required RefreshAction refreshAction,
      required DataCancelBooking? data}) {
    MyPopupMessage.confirmPopUpHTML(
      isTextTitleCenter: isTextTitleCenter,
      cancelText: 'bookingClass.goBack'.tr(),
      confirmColor: MyColors.redColor,
      iconAssetPath: iconAssetPath,
      width: Dimens.getScreenWidth(context),
      fontWeight: FontWeight.w500,
      confirmText: 'bookingClass.cancelBooking'.tr(),
      title: title ?? 'bookingClass.cancelBooking'.tr(),
      context: context,
      barrierDismissible: false,
      description: 'bookingClass.confirmCancelBookingMessage'.tr(),
      onConfirm: data?.blockUserBooking == true ? null : () => _cancelBooking(context, refreshAction),
      htmlContent: data?.messageNote ?? '',
    );
  }

  void _cancelBooking(BuildContext context, RefreshAction? refreshAction) {
    context.read<BookingClassDetailCubit>().cancelBooking(
          bookingCode: classId ?? '',
          onSuccess: () {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pushReplacement(BookingClassCancelScreen.route, extra: classId);
            });
          },
          onError: (String message) {
            showPopupError(context: context, description: message, title: 'bookingClass.cancelBookingNotSuccess'.tr());
          },
          onBookingBlock: (v) {
            _showPopupHtml(
                isTextTitleCenter: true,
                title: 'Tính năng đã bị tạm khóa',
                iconAssetPath: 'booking/booking_not_data.svg',
                context: context,
                bookingCode: classId ?? '',
                refreshAction: refreshAction ?? RefreshAction.refreshHistory,
                data: DataCancelBooking(
                  blockUserBooking: true,
                  messageNote: v,
                ));
          },
          refreshAction: refreshAction ?? RefreshAction.refreshHistory,
        );
  }
}
