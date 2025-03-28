import 'dart:math';

import 'package:dayoneasia/screen/booking/booking_11/booking/ui/item_coach_widget.dart';
import 'package:dayoneasia/screen/booking/booking_11/booking/ui/time_grid_widget.dart';
import 'package:dayoneasia/screen/booking/booking_11/example/example.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/data/network/model/output/booking_11/booking_11_output.dart';
import 'package:myutils/data/network/model/output/booking_11/coaches_output.dart';
import 'package:myutils/data/network/model/output/booking_11/contracts_output.dart';
import 'package:myutils/data/network/model/output/currrent_week_output.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/tab/my_tab_bar.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../../../dashboard/booking_history/cubit/booking_history_cubit.dart';
import '../../branch_list_screen/branch_list_screen.dart';
import '../coach_list/coach_list_screen.dart';
import '../detail/booking_11_detail_screen.dart';
import 'cubit/booking_11_cubit.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
as DataContractV5;
class Booking11Screen extends StatelessWidget {
  static const String route = '/booking-one-one';
  final DataContractV5.Items? data;

  const Booking11Screen({super.key, this.data});

  @override
  Widget build(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => Booking11Cubit(data: data)
        ..loadInitialData()
        ..loadCurrentWeek(),
      child: BlocBuilder<Booking11Cubit, Booking11State>(
        builder: (context, state) {
          return Container(
            color: MyColors.backgroundColor,
            // padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _appBar2(context, state),
                      _buildMainContent(context, state),
                    ],
                  ),
                ),
                _buildContinueButton(context: context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage(
      {required BuildContext context,
      required double coverHeight,
      required double bottom}) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: bottom),
      height: coverHeight,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment(-0.98, -0.18),
          end: Alignment(0.98, 0.18),
          colors: [Color(0xFFFFE6CF), Color(0xFFFFC894), Color(0xFFFFF0E2)],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 26.0.w),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            ),
            SizedBox(width: 20.w),
            Text(
              nameAppbar(),
              style: TextStyle(
                color: const Color(0xFF2A2A2A),
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String nameAppbar() {
    final key = data?.key ?? '';
    final Map<String, String> bookingIcons = {
      ClassType.ONE_PRIVATE.name: 'Lớp 1:1 không gian riêng',
      ClassType.ONE_GENERAL.name: 'Lớp 1:1 không gian chung',
      ClassType.P1P2.name: 'Trải nghiệm huấn luyện viên',
    };
    return bookingIcons[key] ?? 'Lớp 1:1 không gian chung';
  }

  Widget _appBar2(BuildContext context, Booking11State state) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final coverHeight = max(screenHeight * 0.1, 150.0);
    final cardHeight = min(coverHeight * 0.4, 50.0);
    final top = coverHeight - cardHeight / 2;
    final bottom = cardHeight / 2;
    print('cardHeight: $cardHeight');

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        _buildBackgroundImage(
            context: context, coverHeight: coverHeight, bottom: bottom),
        Positioned(
          top: top,
          left: screenWidth * 0.05,
          right: screenWidth * 0.05,
          child: SizedBox(
            height: ToolHelper.isIpad() ? 60.h : cardHeight,
            child: _buildBranchSelector(context, state),
          ),
        ),
      ],
    );
  }

  Widget _buildBranchSelector(BuildContext context, Booking11State state) {
    return InkWell(
      onTap: () => _handleBranchSelection(context, state),
      child: Container(
        decoration: _getShadowedDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
              child: Row(
                children: [
                  MyAppIcon.iconNamedCommon(
                    width: 30.w,
                    height: 30.w,
                    iconName: 'booking/location.svg',
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      state.dataBranchSelected?.name ??
                          '${'bookingClass.selectBranch'.tr()}...',
                      style: _getBranchTextStyle(state),
                    ),
                  ),
                ],
              ),
            ),
            // Positioned(
            //   right: 0,
            //   child: MyAppIcon.iconNamedCommon(
            //     iconName: 'dashboard/piano2.svg',
            //     // fit: BoxFit.fill,
            //   ),
            // ),
            if (state.dataBranchSelected == null)
              Positioned(
                right: 30.w,
                top: 0,
                bottom: 0,
                child: const Icon(Icons.chevron_right,
                    size: 24.0, color: Colors.white),
              ),
          ],
        ),
      ),
    );

    return InkWell(
      onTap: () => _handleBranchSelection(context, state),
      child: Container(
        decoration: _getShadowedDecoration(),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
              child: Row(
                children: [
                  MyAppIcon.iconNamedCommon(
                    width: 30.w,
                    height: 30.w,
                    iconName: 'booking/location.svg',
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      state.dataBranchSelected?.name ??
                          '${'bookingClass.selectBranch'.tr()}...',
                      style: _getBranchTextStyle(state),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              child: MyAppIcon.iconNamedCommon(
                iconName: 'dashboard/piano2.svg',
                // fit: BoxFit.fill,
              ),
            ),
            if (state.dataBranchSelected == null)
              Positioned(
                right: 30.w,
                top: 0,
                bottom: 0,
                child: const Icon(Icons.chevron_right,
                    size: 24.0, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, Booking11State state) {
    if (state.dataBranchSelected == null) {
      return _buildEmptyState();
    }
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCoachSelector(context, state),
            _buildCoachContent(state, context),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({String? message}) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: MyAppIcon.iconNamedCommon(iconName: 'booking/empty.svg'),
          ),
          SizedBox(height: 22.h),
          Text(
            message ?? 'Mời bạn chọn chi nhánh\nđể tiếp tục!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xFF8D8D8D),
              fontSize: 14.sp,
              height: 1.40,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoachSelector(BuildContext context, Booking11State state) {
    return InkWell(
      onTap: () => _handleCoachSelection(context, state),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0.w, vertical: 10.0.w),
        decoration: _getCoachSelectorDecoration(state),
        child: state.dataCoachSelected?.name?.isNotEmpty == true
            ? ItemCoachWidget(coach: state.dataCoachSelected)
            : Row(
                children: [
                  Center(
                    child: MyAppIcon.iconNamedCommon(
                        iconName: 'dashboard/user-unactive.svg',
                        width: 20.w,
                        height: 20.w),
                  ),
                  SizedBox(width: 12.0.w),
                  Expanded(
                    child: Text(
                      'Huấn Luyện Viên',
                      style: TextStyle(
                        fontSize: 14.0.sp,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF2A2A2A),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right,
                      size: 24.0, color: Colors.black54),
                ],
              ),
      ),
    );
  }

  Widget _buildCoachContent(Booking11State state, BuildContext context) {
    if (state.dataCoachSelected?.slug?.isEmpty == true ||
        state.dataCoachSelected?.slug == null) {
      return _buildEmptyState(
          message: 'Mời bạn chọn huấn luyện viên\nđể tiếp tục!');

    }
    return Expanded(
      child: Column(
        children: [
          const SizedBox(height: 10.0),
          _buildWeekCalendar(context, state),
          const SizedBox(height: 10.0),
          const Expanded(child: TimeGridViewV2()),
        ],
      ),
    );
  }

  Widget _buildWeekCalendar(BuildContext context, Booking11State state) {
    return state.currentWeek == null
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w),
            child: MyTabbedPage2<DataCalendar>(
              items: state.currentWeek!,
              titleBuilder: (date) => date.day.toString(),
              subtitleBuilder: (date) => date.date.toString(),
              onTap: (index) {
                final data = state.currentWeek![index];

                context
                    .read<Booking11Cubit>()
                    .emitDataCalendarSelected(data: data);
              },
            ),
          );
  }

  Widget _buildContinueButton({required BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 26.h),
      child: MyButton(
        width: double.infinity,
        height: 40.h,
        text: 'Tiếp tục',
        fontSize: 14.sp,
        border: Border.all(
          color: context.read<Booking11Cubit>().isEnableButton()
              ? MyColors.mainColor
              : MyColors.lightGrayColor.withOpacity(0.6),
          width: 0.1,
        ),
        isEnable: context.read<Booking11Cubit>().isEnableButton(),
        color: context.read<Booking11Cubit>().isEnableButton()
            ? MyColors.mainColor
            : MyColors.lightGrayColor.withOpacity(0.6),
        onPressed: (value) {
          _handleOnClickButton(context);
        },
      ),
    );
  }

  void _showBookingConfirmation(BuildContext context) {
    print(
        'state.inputBooking: ${context.read<Booking11Cubit>().getDataBooking11Input().bookingToJson()}');
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
        context.read<Booking11Cubit>().booking(
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
      },
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
      description:
          context.read<Booking11Cubit>().textBookingSuccessDes(dataBooking),
      iconAssetPath: 'booking/success.svg',
      colorIcon: MyColors.greenColor,
      onCancel: () {},
      onConfirm: () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            context.push(
              Booking11DetailScreen.route,
              extra: {
                'mode': Booking11DetailScreenMode.detail,
                'bookingCode': dataBooking?.bookingCode ?? '',
                'refreshAction': RefreshAction.refreshBooking11List,
              },
            );
          },
        );
      },
    );
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

  _handleOnClickButton(BuildContext context) {
    _showBookingConfirmation(context);
  }

// Helper methods
  void _handleBranchSelection(BuildContext context, Booking11State state) {
    final branches = state.branchesOutput?.data ?? [];
    if (branches.isNotEmpty == true && branches.length > 1) {
      context.push(BranchListScreen.route, extra: {
        'dataBranchSelected': state.dataBranchSelected,
        'branches': state.branchesOutput?.data ?? [],
      }).then((value) {
        if (value != null && value is DataInfoNameBooking) {
          context.read<Booking11Cubit>().emitIndexBranchSelected(value);
        }
      });
    } else {
      // context.read<Booking11Cubit>().showToast(
      //     toastGravity: ToastGravity.BOTTOM,
      //     state.branchesOutput?.message ?? 'Error');
    }
  }

  void _handleCoachSelection(BuildContext context, Booking11State state) {
    context.push(CoachListScreen.route, extra: {
      'dataCoachSelected': state.dataCoachSelected,
      'dataContractSelected': data,
      'dataBranchSelected': state.dataBranchSelected,
    }).then((value) {
      if (value != null && value is DataCoach) {
        context.read<Booking11Cubit>().emitIndexCoachSelected(value);
      }
    });
  }

// Styles and Decorations
  ShapeDecoration _getShadowedDecoration() {
    return ShapeDecoration(
      color: Colors.white,
      // color: Colors.orange,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
      shadows: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 3.39,
          offset: Offset(0, 2.35),
        ),
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 39,
          offset: Offset(0, 27),
        )
      ],
    );
  }

  TextStyle _getBranchTextStyle(Booking11State state) {
    return TextStyle(
      // color: Colors.white,
      fontSize: 14.sp,
      color: const Color(0xFF363535),
      // fontWeight: FontWeight.w600,
    );
  }

  BoxDecoration _getCoachSelectorDecoration(Booking11State state) {
    return BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
      ),
      borderRadius: const BorderRadius.all(
        Radius.circular(8.0),
      ),

      // borderRadius: BorderRadius.only(
      //   topLeft: const Radius.circular(8.0),
      //   topRight: const Radius.circular(8.0),
      //   bottomLeft: state.dataCoachSelected?.isEmpty == true
      //       ? const Radius.circular(8.0)
      //       : const Radius.circular(0.0),
      //   bottomRight: state.dataCoachSelected?.isEmpty == true
      //       ? const Radius.circular(8.0)
      //       : const Radius.circular(0.0),
      // ),
    );
  }

// BoxDecoration _getCoachContentDecoration(Booking11State state) {
//   return BoxDecoration(
//     color: Colors.white,
//     borderRadius: state.dataCoachSelected?.isEmpty == true
//         ? const BorderRadius.only(
//             bottomLeft: Radius.circular(8.0),
//             bottomRight: Radius.circular(8.0),
//           )
//         : null,
//   );
// }
}
