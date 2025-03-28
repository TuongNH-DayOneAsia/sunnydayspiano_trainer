import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:dayoneasia/screen/booking/booking_practice/practice_detail/cubit/booking_practice_detail_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_detail_practice_output.dart';
import 'package:myutils/data/network/model/output/count_cancel_booking_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class BookingPracticeDetailScreen extends BaseStatelessScreenV2 {
  static String route = '/booking-practice-detail';

  @override
  Color? get backgroundColor => MyColors.backgroundColor;
  final String? bookingCode;
  final RefreshAction? refreshAction;

  // @override
  // String? get title => 'bookingClass.bookingDetail'.tr(); // ở đây sẽ có thay đổi

  const BookingPracticeDetailScreen({
    super.key,
    required this.bookingCode,
    this.refreshAction,
  });
  @override
  Widget? buildTitle(BuildContext context) {
    return BlocBuilder<BookingPracticeDetailCubit, BookingPracticeDetailState>(
      builder: (context, state) {
        return Text(
          state.bookingDetailPracticeOutput?.data?.statusBooking == null
              ? ""
              : state.bookingDetailPracticeOutput?.data?.statusBooking == 1
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
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingPracticeDetailCubit(bookingCode: bookingCode)..callApiDetail(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocConsumer<BookingPracticeDetailCubit, BookingPracticeDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: (state.bookingDetailPracticeOutput?.data != null)
              ? Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Card(
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              margin: EdgeInsets.zero,
                              child: Column(
                                children: [
                                  _buildHeader(
                                      data: state
                                          .bookingDetailPracticeOutput!.data),
                                  const Divider(),
                                  _buildClassDetails(
                                      data: state
                                          .bookingDetailPracticeOutput!.data,
                                      context: context),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.w),
                            if (state.bookingDetailPracticeOutput?.data
                                    ?.statusBooking !=
                                null)
                              _additionalInfoWidget(
                                  state.bookingDetailPracticeOutput?.data),
                            // SizedBox(height: 16.w),
                            HtmlWidget(
                              context.read<BookingPracticeDetailCubit>().noteDetailBookingClassPractice,
                            ),
                            SizedBox(height: 30.h),
                            // if (state.bookingDetailPracticeOutput?.data
                            //         ?.bookNote?.isNotEmpty ==
                            //     true) ...[
                            //   Align(
                            //     alignment: Alignment.centerLeft,
                            //     child: Text(
                            //       '${'bookingClass.noteShort'.tr()}:',
                            //       textAlign: TextAlign.left,
                            //       style: TextStyle(
                            //         color: const Color(0xFF3B3B3B),
                            //         fontSize: 12.sp,
                            //         fontWeight: FontWeight.w400,
                            //       ),
                            //     ),
                            //   ),
                            //   HtmlWidget(
                            //     state.bookingDetailPracticeOutput?.data
                            //             ?.bookNote ??
                            //         '',
                            //   ),
                            // ],
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: context
                          .read<BookingPracticeDetailCubit>()
                          .showButtonCancel(),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: RippleTextButton(
                          onPressed: () {
                            context
                                .read<BookingPracticeDetailCubit>()
                                .countBookingCancel(onSuccess: (data) {
                              _showPopupHtml(
                                  context: context,
                                  bookingCode: bookingCode ?? '',
                                  refreshAction: refreshAction ??
                                      RefreshAction.refreshPracticeList,
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
                                  iconAssetPath: 'booking/booking_not_data.svg',
                                  bookingCode: bookingCode ?? '',
                                  refreshAction: refreshAction ??
                                      RefreshAction.refreshPracticeList,
                                  data: DataCancelBooking(
                                    blockUserBooking: true,
                                    messageNote: v,
                                  ));
                            });
                          },
                          textDecoration: TextDecoration.underline,
                          text: 'bookingClass.cancelBooking'.tr(),
                          color: MyColors.lightGrayColor2,
                        ),
                      ),
                    )
                  ],
                )
              : Center(
                  child:
                      Text(state.bookingDetailPracticeOutput?.message ?? '')),
        );
      },
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
      onConfirm: data?.blockUserBooking == true
          ? null
          : () => _cancelBooking(context, bookingCode ?? '', refreshAction),
      htmlContent: data?.messageNote ?? '',
    );
  }

  void _cancelBooking(
      BuildContext context, String? bookingCode, RefreshAction? refreshAction) {
    context.read<BookingPracticeDetailCubit>().cancelBooking(
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

  void _navigateToRoomDetailScreen(BuildContext context, String? bookingCode) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.pushReplacement(BookingPracticeDetailScreen.route, extra: {
        'bookingCode': bookingCode,
        'refreshAction': RefreshAction.refreshPracticeList
      });
    });
  }

  void _showErrorPopup(BuildContext context, String message) {
    showPopupError(
      context: context,
      description: message,
      title: 'bookingClass.cancelBookingNotSuccess'.tr(),
    );
  }

  Widget _additionalInfoWidget(DataDetailPractice? data) {
    Row buildInfoRow(
        {required String label, required String value, int? color}) {
      return Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: MyColors.lightGrayColor2,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
          Text(
            ' $value',
            style: TextStyle(
              color: color != null ? Color(color) : MyColors.lightGrayColor2,
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
            ),
          ),
        ],
      );
    }

    final Map<int, String> statusToCreatedAt = {
      bookingCancel: '${'bookingClass.cancelDate'.tr()}:',
      bookingBooked: '${'bookingClass.bookingDate'.tr()}:',
    };
    String createdAt = statusToCreatedAt[data?.statusBooking] ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'bookingClass.additionalInfo'.tr(),
          style: TextStyle(
            fontSize: 16.sp,
            color: MyColors.darkGrayColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        Card(
          elevation: 0,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildInfoRow(
                    label: createdAt,
                    value: data?.statusBooking == bookingCancel
                        ? data?.cancelDate ?? '---'
                        : data?.createdAt ?? '---'),
                SizedBox(height: 4.h),
                buildInfoRow(
                    label: '${'bookingClass.bookingStatus'.tr()}:',
                    value: data?.statusBookingText ?? '---',
                    color:
                        (int.parse(data?.statusBookingColor ?? '0xFF6A6A6A'))),
                SizedBox(height: 4.h),
                if (data?.statusBooking != bookingCancel)
                  buildInfoRow(
                      label: '${'bookingClass.classStatus'.tr()}:',
                      value: data?.statusInClassText ?? '---',
                      color: (int.parse(
                          data?.statusInClassColor ?? '0xFF6A6A6A'))),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
      ],
    );
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

  Widget _buildHeader({DataDetailPractice? data}) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0.w),
        child: Row(
          children: [
            Container(
                width: 24.w,
                height: 24.w,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.mainColor,
                ),
                child: MyAppIcon.iconNamedCommon(
                    iconName: 'booking/book_training.svg',
                    width: 20.w,
                    height: 20.w,
                    color: Colors.white)),
            const SizedBox(width: 8),
            Text(data?.classTypeName ?? '---',
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: MyColors.mainColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isCopyable = false, BuildContext? context}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15.w, horizontal: 30.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: isCopyable ? 40 : 35,
            child: Text(label,
                style: TextStyle(
                    fontSize: 14.sp, color: MyColors.lightGrayColor2)),
          ),
          Expanded(
              flex: isCopyable ? 60 : 65,
              child: Text(value,
                  style: TextStyle(
                      fontSize: 14.sp, color: MyColors.darkGrayColor))),
          if (isCopyable)
            Material(
              color: Colors.transparent,
              child: InkWell(
                customBorder: const CircleBorder(),
                splashColor: MyColors.mainColor.withOpacity(0.3),
                highlightColor: MyColors.mainColor.withOpacity(0.1),
                onTap: () async {
                  await ToolHelper.clipboard(context!, value);
                  //copy to clipboard
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
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

  Widget _buildClassDetails({DataDetailPractice? data, BuildContext? context}) {
    return Column(
      children: [
        _buildInfoRow('bookingClass.bookingCode'.tr(), data?.bookingCode ?? '---',
            isCopyable: true, context: context),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow('bookingClass.room'.tr(), data?.classroom ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.trainingTime'.tr(), data?.practiceTime ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.trainingDate'.tr(), data?.instrumentStartDate ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow('bookingClass.branch'.tr(), data?.branchName ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingPractice.time'.tr(), data?.instrumentDuration ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingPractice.codePiano'.tr(), data?.instrumentCode ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow('bookingClass.bookingDate'.tr(), data?.createdAt ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow('Gói dịch vụ', data?.productName ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
      ],
    );
  }

  Widget _buildNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lưu ý:',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: MyColors.darkGrayColor)),
        Text(
            '• Quý khách vui lòng đến trước giờ học 15 phút để thay đồ và chuẩn bị.',
            style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12.sp,
                color: MyColors.lightGrayColor2)),
        Text(
          '• Quý khách vui lòng tuân thủ nội quy của phòng tập.',
          style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: MyColors.lightGrayColor2),
        ),
        // Add more notes as needed
      ],
    );
  }
}
