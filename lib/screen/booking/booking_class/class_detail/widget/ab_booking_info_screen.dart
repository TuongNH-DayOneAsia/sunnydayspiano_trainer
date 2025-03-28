import 'package:dayoneasia/screen/booking/booking_class/class_detail/cubit/booking_class_detail_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';

abstract class AbClassInfoScreen extends BaseStatelessScreenV2 {
  @override
  Color? get backgroundColor => MyColors.backgroundColor;
  final String? classId;
  final TypeViewBooking typeViewBooking;

  const AbClassInfoScreen({
    super.key,
    required this.classId,
    required this.typeViewBooking,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          BookingClassDetailCubit(classId: classId, typeViewBooking: typeViewBooking)
            ..callApiClassDetail(),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocConsumer<BookingClassDetailCubit, BookingClassDetailState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.dataClass == null) {
          return Center(
            child: Text(
              state.messageError ?? '',
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.zero,
                        child: Column(
                          // mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildHeader(dataClass: state.dataClass),
                            const Divider(),
                            _buildClassDetails(
                                dataClass: state.dataClass, context: context),
                          ],
                        ),
                      ),
                      SizedBox(height: 16.w),
                      if (state.dataClass?.statusBooking != null)
                        _additionalInfoWidget(state.dataClass),
                      // _buildNote(),
                      // if (state.dataClass?.bookNote?.isNotEmpty == true) ...[
                      //   SizedBox(height: 16.w),
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
                      //   // HtmlWidget(
                      //   //   state.dataClass?.bookNote ?? '',
                      //   // ),
                      // ],
                       HtmlWidget(
                         context.read<BookingClassDetailCubit>().bookingNote(),
                       ),


                    ],
                  ),
                ),

              ),
              buttonWidget(context),
            ],
          ),
        );
      },
    );
  }

  Widget buttonWidget(BuildContext context) {
    return Container();
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
      colorIcon: MyColors.redColor,
      iconAssetPath: 'booking/booking_not_data.svg',
      confirmText: 'bookingClass.goBack'.tr(),
    );
  }

  Widget _buildHeader({DataClass? dataClass}) {
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
                width: 24,
                height: 24,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.mainColor,
                ),
                child: MyAppIcon.iconNamedCommon(
                    iconName: 'booking/book_class.svg',
                    width: 20.w,
                    height: 20.w,
                    color: Colors.white)),
            const SizedBox(width: 8),
            Text('bookingClass.class'.tr(),
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
            child:
                Text(label, style: TextStyle(color: MyColors.lightGrayColor2)),
          ),
          Expanded(
              flex: isCopyable ? 60 : 65,
              child:
                  Text(value, style: TextStyle(color: MyColors.darkGrayColor))),
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

  Widget _buildClassDetails({DataClass? dataClass, BuildContext? context}) {
    return Column(
      children: [
        if (dataClass?.bookingCode?.isNotEmpty == true)
          _buildInfoRow(
              'bookingClass.bookingCode'.tr(), dataClass?.bookingCode ?? '---',
              isCopyable: true, context: context),
        // _buildInfoRow('bookingClass.classLessonCode'.tr(), dataClass?.classLessonCode ?? ''),

        _buildInfoRow('bookingClass.classLessonCode'.tr(),
            dataClass?.classLessonCode ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.room'.tr(),
            typeViewBooking == TypeViewBooking.detail
                ? dataClass?.classroom?.name ?? '---'
                : dataClass?.classroomName ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.trainingTime'.tr(),
            typeViewBooking == TypeViewBooking.detail
                ? '${dataClass?.classStartTime} - ${dataClass?.classEndTime}'
                : dataClass?.classLessonTimeStartToEnd ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.trainingDate'.tr(),
            typeViewBooking == TypeViewBooking.detail
                ? dataClass?.classStartDate ?? '---'
                : dataClass?.classLessonStartDate ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow('bookingClass.branch'.tr(),
            dataClass?.branch?.name ?? dataClass?.branchName ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        // _buildInfoRow('Mã đàn',
        //     '---'),
        // const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        _buildInfoRow(
            'bookingClass.coach'.tr(),
            typeViewBooking == TypeViewBooking.detail
                ? (dataClass?.nameCoach() ?? '---')
                : dataClass?.coaches ?? '---'),
        const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
        if (typeViewBooking == TypeViewBooking.detail)
          _buildInfoRow(
            capitalize('bookingClass.slot'.tr()),
            '${'bookingClass.booked'.tr()} ${dataClass?.instrumentsTotalBooked}/${dataClass?.instrumentsTotalActive} ${'bookingClass.slot'.tr()}',
          ),
        if (typeViewBooking != TypeViewBooking.detail) ...[
          const Divider(color: Color.fromRGBO(241, 241, 241, 1)),
          _buildInfoRow('Gói dịch vụ', dataClass?.productName ?? '---'),
        ]
      ],
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  Widget _additionalInfoWidget(DataClass? dataClass) {
    Row buildInfoRow(
        {required String label, required String value, int? color}) {
      return Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: MyColors.lightGrayColor2,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            ' $value',
            style: TextStyle(
              color: color != null ? Color(color) : MyColors.lightGrayColor2,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      );
    }

    final Map<int, String> statusToCreatedAt = {
      bookingCancel: '${'bookingClass.cancelDate'.tr()}:',
      bookingBooked: '${'bookingClass.bookingDate'.tr()}:',
    };
    String createdAt = statusToCreatedAt[dataClass?.statusBooking] ?? '';

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'bookingClass.additionalInfo'.tr(),
          style: TextStyle(
            fontSize: 16,
            color: MyColors.darkGrayColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 10.h),
        Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                buildInfoRow(
                    label: createdAt, value: dataClass?.createdAt ?? ''),
                const SizedBox(height: 4),
                buildInfoRow(
                    label: '${'bookingClass.bookingStatus'.tr()}:',
                    value: dataClass?.statusBookingText ?? '',
                    color: (int.parse(
                        dataClass?.statusBookingColor ?? '0xFF6A6A6A'))),
                const SizedBox(height: 4),
                if (dataClass?.statusBooking != bookingCancel)
                  buildInfoRow(
                      label: '${'bookingClass.classStatus'.tr()}:',
                      value: dataClass?.statusInClassText ?? '',
                      color: (int.parse(
                          dataClass?.statusInClassColor ?? '0xFF6A6A6A'))),
              ],
            ),
          ),
        ),
        SizedBox(height: 10.h),
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
