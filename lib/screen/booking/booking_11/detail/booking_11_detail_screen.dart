import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_detail_output.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../../../dashboard/booking_history/cubit/booking_history_cubit.dart';
import '../../booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'cubit/booking_11_detail_cubit.dart';

enum Booking11DetailScreenMode {
  confirm,
  detail,
}

class Booking11DetailScreen extends BaseStatelessScreenV2 {
  static const String route = '/booking-detail-1-1';
  final DataBooking11Detail? data;
  final String? bookingCode;
  final Booking11DetailScreenMode mode;
  final RefreshAction refreshAction;

  const Booking11DetailScreen({
    super.key,
    required this.mode,
    this.data,
    this.bookingCode,
    required this.refreshAction,
  });

  @override
  String get title => mode == Booking11DetailScreenMode.confirm
      ? 'Xác nhận đặt lịch'
      : 'Lịch sử đặt';

  @override
  Widget? buildTitle(BuildContext context) {
    return BlocBuilder<Booking11DetailCubit, Booking11DetailState>(
      builder: (context, state) {
        return Text(
          state.dataBooking11Detail?.statusBooking == null
              ? ""
              : state.dataBooking11Detail?.statusBooking == 1
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
  bool get automaticallyImplyLeading => true;

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          Booking11DetailCubit(mode: mode, data: data, bookingCode: bookingCode)
            ..initData(
              onBookingError: (message) {
                _showPopupError(
                  context: context,
                  description: message,
                  title: 'Thông báo',
                  onConfirm: () {
                    context.pop();
                  },
                );
              },
            ),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<Booking11DetailCubit, Booking11DetailState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      buildClassInfoCard(state, context),
                      SizedBox(height: 16.h),
                      buildAdditionalInfo(state),
                      SizedBox(height: 16.h),
                      HtmlWidget(
                        state.dataBooking11Detail?.bookingNote ?? '',
                      ),
                    ],
                  ),
                ),
              ),
              _buildButton(context: context),
            ],
          ),
        );
      },
    );
  }

  Widget buildClassInfoCard(Booking11DetailState state, BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white, // Light orange background
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        spacing: 5,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment(-0.98, -0.18),
                end: Alignment(0.98, 0.18),
                colors: [
                  Color(0xFFFFE6CF),
                  Color(0xFFFFF9F3),
                  Color(0xFFFFF0E2)
                ],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(20.w),
            child: Row(
              children: [
                const Icon(
                  Icons.people_outline,
                  color: Color(0xFFFF8B00), // Orange color
                  size: 24,
                ),
                SizedBox(width: 8.w),
                Text(
                  nameAppbar(state),
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFFFF8B00),
                  ),
                ),
              ],
            ),
          ),

          // Info rows
          _buildInfoRow(
              label: 'Mã đặt chỗ',
              value: state.dataBooking11Detail?.bookingCode ?? '---',
              context: context,
              isCopyable: true),
          _buildInfoRow(
              label: 'Chi nhánh',
              value: state.dataBooking11Detail?.dataBranchSelected?.name ?? '---'),
          _buildInfoRow(
              label: 'Phòng học',
              value: state.dataBooking11Detail?.classroom ?? '---'),
          _buildInfoRow(
              label: 'Huấn Luyện Viên',
              value:
                  state.dataBooking11Detail?.dataCoachSelected?.fullName ?? '---'),
          _buildInfoRow(
              label: 'Ngày học',
              value: state.dataBooking11Detail?.currentDateDisplay ?? '---'),
          _buildInfoRow(
              label: 'Bắt đầu',
              value: state.dataBooking11Detail?.startTime ?? '---'),
          _buildInfoRow(
              label: 'Kết thúc', value: state.dataBooking11Detail?.endTime ?? '---'),

          _buildInfoRow(
              label: 'Thời lượng',
              value: state.dataBooking11Detail?.durationString ?? '---'),

          _buildInfoRow(
              label: 'Gói dịch vụ',
              value: state.dataBooking11Detail?.productName ?? '---'),
        ],
      ),
    );
  }

  String nameAppbar(Booking11DetailState state) {
    final key = mode == Booking11DetailScreenMode.confirm
        ? data?.key ?? ''
        : state.dataBooking11Detail?.type ?? '';
    final Map<String, String> bookingIcons = {
      ClassType.ONE_PRIVATE.name: 'Lớp 1:1 không gian riêng',
      ClassType.ONE_GENERAL.name: 'Lớp 1:1 không gian chung',
      ClassType.P1P2.name: 'Trải nghiệm huấn luyện viên',
    };
    return bookingIcons[key] ?? 'Lớp 1:1 không gian chung';
  }

  Widget _buildInfoRow(
      {required String label,
      required String value,
      bool? isCopyable = false,
      BuildContext? context}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.5),
            width: 0.2,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140.w,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF6A6A6A),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: const Color(0xFF2A2A2A),
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          if (isCopyable == true && context != null)
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: MyColors.mainColor.withOpacity(0.3),
                highlightColor: MyColors.mainColor.withOpacity(0.1),
                onTap: () async {
                  await ToolHelper.clipboard(context, value);
                  //copy to clipboard
                },
                child: Container(
                  // padding: const EdgeInsets.all(8.0),
                  child: MyAppIcon.iconNamedCommon(
                      iconName: 'booking/copy.svg',
                      color: MyColors.mainColor,
                      width: 24.w,
                      height: 24.w),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _buildButton({required BuildContext context}) {
    if (mode == Booking11DetailScreenMode.confirm) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0.w, horizontal: 16.0),
        child: MyButton(
          width: double.infinity,
          height: 40.h,
          text: 'Tiếp tục',
          fontSize: 14.sp,
          border: Border.all(
            color: MyColors.mainColor,
            width: 0.1,
          ),
          isEnable: true,
          color: MyColors.mainColor,
          onPressed: (value) => _showBookingConfirmation(context: context),
        ),
      );
    } else {
      return Visibility(
        visible: context.read<Booking11DetailCubit>().showButtonCancel(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Align(
            alignment: Alignment.bottomRight,
            child: RippleTextButton(
              onPressed: () {
                context.read<Booking11DetailCubit>().countBookingCancel(
                  onSuccess: (data) {
                    _showPopupHtml(
                        context: context,
                        bookingCode: bookingCode ?? '',
                        refreshAction: refreshAction,
                        data: data);
                  },
                  onError: (message) {
                    MyPopupMessage.showPopUpWithIcon(
                      title: title,
                      context: context,
                      barrierDismissible: false,
                      description: message,
                      colorIcon: MyColors.redColor,
                      iconAssetPath: 'booking/booking_not_data.svg',
                      confirmText: 'bookingClass.goBack'.tr(),
                    );
                  },
                  onBookingBlock: (v) {
                    _showPopupHtml(
                      context: context,
                      iconAssetPath: 'booking/booking_not_data.svg',
                      bookingCode: bookingCode ?? '',
                      refreshAction: refreshAction,
                      data: DataCancelBooking(
                        blockUserBooking: true,
                        messageNote: v,
                      ),
                    );
                  },
                );
              },
              textDecoration: TextDecoration.underline,
              text: 'bookingClass.cancelBooking'.tr(),
              color: MyColors.redColor,
            ),
          ),
        ),
      );
    }
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
      onConfirm: data?.blockUserBooking == true
          ? null
          : () => _cancelBooking(context, bookingCode ?? '', refreshAction),
      htmlContent: data?.messageNote ?? '',
    );
  }

  void _navigateToRoomDetailScreen(BuildContext context, String? bookingCode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushReplacement(Booking11DetailScreen.route, extra: {
        'bookingCode': bookingCode,
        'refreshAction': refreshAction,
        'mode': Booking11DetailScreenMode.detail,
      });
    });
  }

  void showPopupError(
      {required BuildContext context,
      required String description,
      required String title}) {
    MyPopupMessage.showPopUpWithIcon(
      title: title,
      context: context,
      barrierDismissible: false,
      description: description,
      iconAssetPath: 'booking/booking_not_data.svg',
      colorIcon: MyColors.redColor,
      confirmText: 'bookingClass.goBack'.tr(),
    );
  }

  void _showErrorPopup(BuildContext context, String message) {
    showPopupError(
      context: context,
      description: message,
      title: 'bookingClass.cancelBookingNotSuccess'.tr(),
    );
  }

  void _cancelBooking(
      BuildContext context, String? bookingCode, RefreshAction? refreshAction) {
    context.read<Booking11DetailCubit>().cancelBooking(
          bookingCode: bookingCode ?? '',
          onSuccess: () => _navigateToRoomDetailScreen(context, bookingCode),
          onError: (String message) => _showErrorPopup(context, message),
          refreshAction: refreshAction ?? RefreshAction.refreshPracticeList,
          onBookingBlock: (v) {
            _showPopupHtml(
                isTextTitleCenter: true,
                title: 'Tính năng đã bị tạm khóa',
                iconAssetPath: 'booking/booking_not_data.svg',
                context: context,
                bookingCode: bookingCode ?? '',
                refreshAction:
                    refreshAction ?? RefreshAction.refreshPracticeList,
                data: DataCancelBooking(
                  blockUserBooking: true,
                  messageNote: v,
                ));
          },
        );
  }

  Widget buildAdditionalInfo(Booking11DetailState state) {
    if (mode == Booking11DetailScreenMode.confirm) {
      return const SizedBox.shrink();
    }
    final Map<int, String> statusToCreatedAt = {
      bookingCancel: '${'bookingClass.cancelDate'.tr()}:',
      bookingBooked: '${'bookingClass.bookingDate'.tr()}:',
    };
    final data = state.dataBooking11Detail;
    String createdAt =
        statusToCreatedAt[state.dataBooking11Detail?.statusBooking] ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin thêm',
          style: TextStyle(
            color: const Color(0xFF2A2A2A),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 15.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _infoItem(
                  createdAt,
                  data?.statusBooking == bookingCancel
                      ? data?.cancelDate ?? ''
                      : data?.createdAt ?? ''),
              const SizedBox(height: 8),
              _infoItem(
                  data?.statusBooking == bookingCancel
                      ? 'Người huỷ:'
                      : 'Người đặt:',
                  data?.statusBooking == bookingCancel
                      ? state.dataBooking11Detail?.cancelBy ?? '---'
                      : state.dataBooking11Detail?.bookingBy ?? '---'),
              const SizedBox(height: 8),
              _infoItem(
                data?.statusBooking == bookingCancel
                    ? 'Trạng thái huỷ:'
                    : 'Trạng thái Đặt lịch:',
                state.dataBooking11Detail?.statusBookingText ?? '---',
                valueColor: Color(int.parse(
                    state.dataBooking11Detail?.statusBookingColor ?? '0xFF28A745')),
              ),
              const SizedBox(height: 8),
              if (data?.statusBooking != bookingCancel)
                _infoItem(
                  'Trạng thái đến lớp:',
                  state.dataBooking11Detail?.statusInClassText ?? '---',
                  valueColor: Color(int.parse(
                      state.dataBooking11Detail?.statusInClassColor ??
                          '0xFFFF4545')),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _infoItem(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Color(0xFF6A6A6A),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            color: valueColor ?? const Color(0xFF6A6A6A),
          ),
        ),
      ],
    );
  }

  void _showPopUpSuccess(BuildContext context, DataBooking11? dataBooking) {
    MyPopupMessage.showPopUpWithIcon(
        confirmText: 'bookingClass.details'.tr(),
        title: 'bookingClass.bookingSuccess'.tr(),
        context: context,
        barrierDismissible: false,
        cancelText: 'bookingClass.goBack'.tr(),
        subtitle: 'bookingClass.note'.tr(),
        description: context
            .read<Booking11DetailCubit>()
            .textBookingSuccessDes(dataBooking),
        iconAssetPath: 'booking/success.svg',
        colorIcon: MyColors.greenColor,
        onCancel: () {},
        onConfirm: () {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.pushReplacement(Booking11DetailScreen.route, extra: {
              'mode': Booking11DetailScreenMode.detail,
              'bookingCode': dataBooking?.bookingCode ?? '',
              'refreshAction': refreshAction,
            });
          });
        });
  }

  void _showPopupError({
    required BuildContext context,
    required String description,
    required String title,
    VoidCallback? onConfirm,
  }) {
    MyPopupMessage.showPopUpWithIcon(
        title: title,
        context: context,
        barrierDismissible: false,
        description: description,
        colorIcon: MyColors.redColor,
        iconAssetPath: 'booking/booking_not_data.svg',
        confirmText: 'bookingClass.goBack'.tr(),
        onConfirm: () {
          onConfirm?.call();
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

  void _showBookingConfirmation({required BuildContext context}) {
    context.read<Booking11DetailCubit>().booking(
        onBookingSuccess: (DataBooking11? data) {
      _showPopUpSuccess(context, data);
    }, onBookingError: (message) {
      _showPopupError(
          context: context,
          description: message,
          title: 'bookingClass.bookingFailed'.tr());
    }, onBookingBlock: (v) {
      _showCancelBookingConfirmation(
        context: context,
        messageNote: v,
      );
    });
  }
}
