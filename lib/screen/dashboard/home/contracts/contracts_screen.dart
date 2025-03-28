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
  String get title => titleAppbar ?? 'Chọn hợp đồng lớp 1-1';

  const ContractsScreen({
    super.key,
    this.titleAppbar,
    this.data,
    this.messageEmpty
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ContractsCubit(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return CourseListScreen(data: data,messageEmpty: messageEmpty,);
  }
}

class CourseListScreen extends StatefulWidget {
  final DataContractV5.Data? data;
  final String? messageEmpty;

  const CourseListScreen({super.key, this.data,this.messageEmpty});

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
          return  Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0.w),
              child: Text(widget.messageEmpty ?? 'Không có hợp đồng',
              textAlign: TextAlign.center,),
            ),
          );
        }
        return Container(
          padding: EdgeInsets.all(16.w),
          height: double.infinity,
          child: Column(
            children: [
              if (widget.data?.messages?.isNotEmpty == true)
                Container(
                  decoration: ShapeDecoration(
                    color: const Color(0x19FF4545),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    widget.data?.messages ?? '---',
                    style: TextStyle(fontSize: 12.sp, color: MyColors.redColor),
                  ),
                ),
              SizedBox(height: 10.h),
              _buildHeaderContainer(widget.data),
              SizedBox(height: 10.h),
              _buildCourseSelectionList(data: widget.data),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderContainer(DataContractV5.Data? data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          MyAppIcon.iconNamedCommon(
              iconName: data?.iconPath() ?? '', width: 25.w, height: 25.w),
          const SizedBox(width: 8),
          Text(
            data?.name ?? '---',
            style: TextStyle(
              color: const Color(0xFFFFA63D),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourseSelectionList({DataContractV5.Data? data}) {
    final list = data?.items ?? [];
    if (list.isEmpty) return const SizedBox();
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (_, itemIndex) {
        final dataSub = list[itemIndex];
        final isSelected = selectedItemIndex == itemIndex;
        final isActive = (data?.active == true) && (dataSub.isBooking == true);
        return Opacity(
          opacity: isActive ? 1.0 : 0.5,
          child: InkWell(
            onTap: isActive
                ? () {
                    setState(() {
                      selectedItemIndex = itemIndex;
                    });
                    _handleItemSelection(dataSub: dataSub, context: context);
                  }
                : null,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              padding: EdgeInsets.only(
                left: 4.w,
                right: 16.w,
                top: 16.w,
                bottom: 16.w,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: isActive
                        ? () {
                            setState(() {
                              selectedItemIndex = itemIndex;
                            });
                            _handleItemSelection(
                              context: context,
                              dataSub: dataSub,
                            );
                          }
                        : null,
                    icon: Icon(
                      isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isSelected
                          ? MyColors.mainColor
                          : (isActive
                              ? Colors.grey
                              : Colors.grey.withOpacity(0.5)),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataSub.productName ?? '---',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.black : Colors.grey,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        if (!context.read<ContractsCubit>().hideTotalLearned())
                        Text(
                          'Đã học: ${dataSub.totalLearned}/${dataSub.total} buổi',
                          style: TextStyle(
                            color: const Color(0xFF6A6A6A),
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: dataSub.isBooking == true &&
                                widget.data?.key == 'CLASS_PRACTICE'
                            ? Text(
                                dataSub.statusName ?? '---',
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: dataSub.colorStatus(),
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : widget.data?.key != 'CLASS'
                                ? Container(
                                    width: 32.w,
                                    height: 32.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: (dataSub.isBooking == true && widget.data?.active == true)
                                ? const LinearGradient(
                              begin: Alignment(0.50, 0.00),
                              end: Alignment(0.50, 1.00),
                              colors: [Color(0xFFFFA63D), Color(0xFFFF8B00), Color(0xFFEE8100)],
                            )
                                : null,
                            color: (dataSub.isBooking == true && widget.data?.active == true)
                                ? null
                                : const Color(0xFFB6B6B6),
                          ),
                                    child: Center(
                                      child: Text(
                                        MyString.alphaText(
                                            dataSub.key ?? ''),
                                        style: TextStyle(
                                          fontSize: dataSub.key ==
                                                  ClassType.P1P2.name
                                              ? 8.sp
                                              : 14.sp,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  )
                                : Container()),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTextWithBreak(String text, Color textColor) {
    List<String> words = text.split(' ');
    if (words.length > 2) {
      return Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: '${words.sublist(0, words.length ~/ 2).join(' ')}\n',
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            TextSpan(
              text: words.sublist(words.length ~/ 2).join(' '),
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.start,
      );
    }
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
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
      return;
    } else if (dataSub.key == 'CLASS_PRACTICE' ||
        (dataSub.key == 'CLASS' && !isBooking)) {
      _showPopupError(
          context: context,
          description: dataSub.messages ?? '---',
          title: 'Thông báo');
    } else if (isBooking) {
      context.push(Booking11Screen.route, extra: dataSub);
    } else {
      _showPopupError(
          context: context,
          description: dataSub.messages ?? '---',
          title: 'Thông báo');
    }
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
