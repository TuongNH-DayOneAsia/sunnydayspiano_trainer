import 'package:dayoneasia/screen/booking/booking_11/booking/booking_11_screen.dart';
import 'package:dayoneasia/screen/booking/booking_class/class_list/booking_class_list_screen.dart';
import 'package:dayoneasia/screen/dashboard/booking_history/cubit/booking_history_cubit.dart';
import 'package:dayoneasia/screen/dashboard/home/contracts/cubit/contracts_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/data/network/model/output/contracts/booking_class_type_v5_output.dart'
    as DataContractV5;

class ContractsScreen extends BaseStatelessScreenV2 {
  final String? titleAppbar;
  final DataContractV5.Data? data;
  final String? messageEmpty;
  static const String route = '/contracts';

  @override
  String get title => titleAppbar ?? 'booking11.selectContract11'.tr();

  const ContractsScreen(
      {super.key, this.titleAppbar, this.data, this.messageEmpty});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContractsCubit(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return CourseListScreen(
      data: data,
      messageEmpty: messageEmpty,
    );
  }
}

class CourseListScreen extends StatefulWidget {
  final DataContractV5.Data? data;
  final String? messageEmpty;

  const CourseListScreen({super.key, this.data, this.messageEmpty});

  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  int? selectedItemIndex;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContractsCubit, ContractsState>(
      builder: (context, state) {
        final contracts = widget.data?.items ?? [];
        if (contracts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Text(
                widget.messageEmpty ?? 'Không có hợp đồng',
                textAlign: TextAlign.center,
              ),
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              children: [
                if (widget.data?.messages?.isNotEmpty == true) _buildMessageBanner(),
                SizedBox(height: 10.h),
                _buildHeaderContainer(),
                SizedBox(height: 10.h),
                _buildCourseSelectionList(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMessageBanner() {
    return Container(
      decoration: ShapeDecoration(
        color: const Color(0x19FF4545),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      padding: EdgeInsets.all(16.w),
      child: Text(
        widget.data?.messages ?? '---',
        style: TextStyle(fontSize: 12.sp, color: MyColors.redColor),
      ),
    );
  }

  Widget _buildHeaderContainer() {
    return DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(-0.98, -0.18),
          end: Alignment(0.98, 0.18),
          colors: [Color(0xFFFFF0E2), Color(0xFFFFF9F3), Color(0xFFFFE6CF)],
        ),
        border: Border(
          top: BorderSide(width: 0.5, color: Color(0xFFEE8100)),
          left: BorderSide(width: 0.5, color: Color(0xFFEE8100)),
          right: BorderSide(width: 0.5, color: Color(0xFFEE8100)),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(100),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            MyAppIcon.iconNamedCommon(
              iconName: widget.data?.iconPath() ?? '',
              width: 25.w,
              height: 25.w,
            ),
            const SizedBox(width: 8),
            Text(
              widget.data?.name ?? '---',
              style: TextStyle(
                color: const Color(0xFFFFA63D),
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseSelectionList() {
    final list = widget.data?.items ?? [];
    if (list.isEmpty) return const SizedBox();

    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => _CourseListItem(
        data: list[index],
        isSelected: selectedItemIndex == index,
        isActive: widget.data?.active == true && list[index].isBooking == true,
        onTap: () {
          setState(() => selectedItemIndex = index);
          _handleItemSelection(context: context, dataSub: list[index]);
        },
        hideTotal: context.read<ContractsCubit>().hideTotalLearned(),
        contractKey: widget.data?.key,
      ),
    );
  }

  void _handleItemSelection({
    required BuildContext context,
    required DataContractV5.Items dataSub,
  }) {
    if (dataSub.slugContract?.isEmpty == true) return;

    final isBooking = dataSub.isBooking == true;
    if (dataSub.key == 'CLASS' && isBooking) {
      context.push(BookingClassListScreen.route, extra: dataSub);
    } else if (dataSub.key == 'CLASS_PRACTICE' || (dataSub.key == 'CLASS' && !isBooking)) {
      _showPopupError(context: context, description: dataSub.messages ?? '---');
    } else if (isBooking) {
      context.push(Booking11Screen.route, extra: dataSub);
    } else {
      _showPopupError(context: context, description: dataSub.messages ?? '---');
    }
  }

  void _showPopupError({
    required BuildContext context,
    required String description,
  }) {
    MyPopupMessage.showPopUpWithIcon(
      title: 'Thông báo',
      context: context,
      barrierDismissible: false,
      description: description,
      colorIcon: MyColors.redColor,
      iconAssetPath: 'booking/booking_not_data.svg',
      confirmText: 'bookingClass.goBack'.tr(),
    );
  }
}

class _CourseListItem extends StatelessWidget {
  final DataContractV5.Items data;
  final bool isSelected;
  final bool isActive;
  final VoidCallback onTap;
  final bool hideTotal;
  final String? contractKey;

  const _CourseListItem({
    required this.data,
    required this.isSelected,
    required this.isActive,
    required this.onTap,
    required this.hideTotal,
    this.contractKey,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isActive ? 1.0 : 0.5,
      child: InkWell(
        onTap: isActive ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.fromLTRB(4.w, 16.w, 16.w, 16.w),
          child: Row(
            children: [
              _buildRadioButton(),
              Expanded(
                flex: 7,
                child: _buildContentColumn(),
              ),
              Expanded(
                flex: 3,
                child: _buildStatusIndicator(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton() {
    return IconButton(
      onPressed: isActive ? onTap : null,
      icon: Icon(
        isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: isSelected
            ? MyColors.mainColor
            : (isActive ? Colors.grey : Colors.grey.withOpacity(0.5)),
      ),
    );
  }

  Widget _buildContentColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          data.productName ?? '---',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isActive ? Colors.black : Colors.grey,
          ),
        ),
        if (!hideTotal) ...[
          SizedBox(height: 2.h),
          Text(
            'Đã học: ${data.totalLearned}/${data.total} buổi',
            style: TextStyle(
              color: const Color(0xFF6A6A6A),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
        if (data.messageBlock?.isNotEmpty == true) ...[
          SizedBox(height: 2.h),
          Text(
            data.messageBlock ?? '',
            style: TextStyle(color: data.colorStatus()),
          ),
        ],
      ],
    );
  }

  Widget _buildStatusIndicator() {
    if (data.isBooking == true && contractKey == 'CLASS_PRACTICE') {
      return Text(
        data.statusName ?? '---',
        textAlign: TextAlign.end,
        style: TextStyle(
          color: data.colorStatus(),
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (contractKey == 'CLASS') return const SizedBox();

    return Container(
      width: 32.w,
      height: 32.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: (data.isBooking == true)
            ? const LinearGradient(
          begin: Alignment(0.50, 0.00),
          end: Alignment(0.50, 1.00),
          colors: [Color(0xFFFFA63D), Color(0xFFFF8B00), Color(0xFFEE8100)],
        )
            : null,
        color: data.isBooking == true ? null : const Color(0xFFB6B6B6),
      ),
      child: Center(
        child: Text(
          MyString.alphaText(data.key ?? ''),
          style: TextStyle(
            fontSize: data.key == ClassType.P1P2.name ? 8.sp : 14.sp,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}