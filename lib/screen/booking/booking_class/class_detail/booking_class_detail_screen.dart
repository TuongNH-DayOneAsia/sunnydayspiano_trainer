import 'package:dayoneasia/screen/booking/booking_class/booking_class_detail/booking_class_detail_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_detail/widget/ab_booking_info_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/booking_class_detail_cubit.dart';

class BookingClassDetailsScreen extends AbClassInfoScreen {
  static String route = '/booking-class-view-detail';

  final String? _classId;
  final String? contractSlug;
  final TypeViewBooking _typeViewBooking;

  const BookingClassDetailsScreen({
    super.key,
    super.classId,
    this.contractSlug,
    required super.typeViewBooking,
  })  : _classId = classId,
        _typeViewBooking = typeViewBooking;

  @override
  String? get classId => _classId;

  @override
  // TODO: implement backgroundColor
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  String? get title => 'bookingClass.bookingDetail'.tr();

  @override
  Widget buttonWidget(BuildContext context) {
    return Hero(
      tag: 'buttonWidget',
      child: Padding(
        padding: EdgeInsets.only(bottom: 22.0.w),
        child: MyButton(
          width: 295.w,
          fontSize: 14.sp,
          text: 'bookingClass.bookNow'.tr(),
          color: MyColors.mainColor,
          height: 38.h,
          onPressed: (value) {
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
                  context.read<BookingClassDetailCubit>().callApiBook(
                      id: classId ?? '',
                      contractSlug: contractSlug ??'',
                      onBookingSuccess: (DataBooking? dataBooking) {
                        _showPopUpSuccess(context, dataBooking);
                      },
                      onBookingError: (String message) {
                        showPopupError(context: context, description: message, title: 'bookingClass.bookingFailed'.tr());
                      },
                      onBookingBlock: (v) {
                        _showCancelBookingConfirmation(context: context, messageNote: v);
                      });
                });
          },
        ),
      ),
    );
  }

  void _showCancelBookingConfirmation({required BuildContext context, required String messageNote}) {
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
        description: context.read<BookingClassDetailCubit>().textBookingSuccessDes(dataBooking),
        iconAssetPath: 'booking/success.svg',
        colorIcon: MyColors.greenColor,
        onCancel: () {
          context.pop();
        },
        onConfirm: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pushReplacement(BookingClassDetailScreen.route,
                extra: {'bookingCode': dataBooking?.bookingCode ?? '', 'refreshAction': RefreshAction.refreshClassList});
          });
        });
  }
}
