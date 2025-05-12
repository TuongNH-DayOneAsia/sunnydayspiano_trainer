import 'package:dayoneasia/screen/profile/update_information/cubit/update_information_state_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myutils/data/network/model/output/user_output.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/dimens.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../info_contract/info_contract_screen.dart';

class UpdateInformationScreen extends BaseStatelessScreenV2 {
  final DataUserInfo? dataUserInfo;

  UpdateInformationScreen({
    Key? key,
    this.dataUserInfo,
  }) : super(key: key);
  static const String route = '/update-information';

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  bool reloadAvatar = false;

  @override
  String get title => 'Cập nhật thông tin';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => UpdateInformationStateCubit(dataUserInfo: dataUserInfo),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return _StudentInfoForm(dataUserInfo: dataUserInfo);
  }
}

class _StudentInfoForm extends StatelessWidget {
  final DataUserInfo? dataUserInfo;

  const _StudentInfoForm({this.dataUserInfo});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UpdateInformationStateCubit, UpdateInformationStateState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Form(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 16.h,
                ),
                // PopupUnderWidget(),
                UserInfoCard(
                  items: [
                    UserInfoItem(
                      'profile.fullName'.tr(),
                      valueWidget: CustomTextField(
                          keyboardType: TextInputType.text,
                          inputBorderNone: true,
                          hintText: state.fullName ?? 'Họ và tên',
                          textStyle: TextStyle(fontSize: 13.sp),
                          onChanged: (value) => context.read<UpdateInformationStateCubit>().updateField('name', value)),
                    ),
                    UserInfoItem(
                      'profile.gender'.tr(),
                      valueWidget: PopupMenuButton<String>(
                        elevation: 2,
                        menuPadding: EdgeInsets.symmetric(vertical: 5.w, horizontal: 10.w),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        initialValue: state.gender ?? 'Nam',
                        onSelected: (String value) {
                          context.read<UpdateInformationStateCubit>().updateGender(value);
                        },
                        offset: const Offset(0, 40),
                        position: PopupMenuPosition.under,
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            height: 37.h,
                            value: 'Nam',
                            child: Text(
                              'Nam',
                              style: TextStyle(
                                  color: state.gender == 'Nam' ? Colors.orange : const Color(0xFF3B3B3B), fontSize: 12.sp),
                            ),
                          ),
                          const PopupMenuDivider(
                            height: 2,
                          ),
                          PopupMenuItem<String>(
                            height: 37.h,
                            value: 'Nữ',
                            child: Text(
                              'Nữ',
                              style: TextStyle(
                                  color: state.gender == 'Nữ' ? Colors.orange : const Color(0xFF3B3B3B), fontSize: 12.sp),
                            ),
                          ),
                          const PopupMenuDivider(
                            height: 2,
                          ),
                          PopupMenuItem<String>(
                            height: 37.h,
                            value: 'Khác',
                            child: Text(
                              'Khác',
                              style: TextStyle(
                                  color: state.gender == 'Khác' ? Colors.orange : const Color(0xFF3B3B3B), fontSize: 12.sp),
                            ),
                          ),
                        ],
                        child: SizedBox(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(state.gender ?? '', style: TextStyle(fontSize: 13.sp, color: MyColors.lightGrayColor2)),
                              const Icon(Icons.arrow_forward_ios, size: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                    UserInfoItem(
                      'profile.phoneNumber'.tr(),
                      valueWidget: CustomTextField(
                        keyboardType: TextInputType.phone,
                        inputBorderNone: true,
                        hintText: state.phoneNumber ?? 'Số điện thoại',
                        textStyle: TextStyle(fontSize: 13.sp),
                        onChanged: (value) => context.read<UpdateInformationStateCubit>().updateField('phone', value),
                      ),
                    ),
                    UserInfoItem(
                      'profile.email'.tr(),
                      valueWidget: CustomTextField(
                        keyboardType: TextInputType.emailAddress,
                        inputBorderNone: true,
                        hintText: state.email ?? 'Email',
                        textStyle: TextStyle(fontSize: 13.sp),
                        onChanged: (value) => context.read<UpdateInformationStateCubit>().updateField('email', value),
                      ),
                    ),
                    UserInfoItem(
                      'profile.dateOfBirth'.tr(),
                      valueWidget: RippleTextButton(
                        padding: EdgeInsets.zero,
                        text: state.birthDate == null ? 'Chưa chọn' : DateFormat('dd/MM/yyyy').format(state.birthDate!),
                        color: MyColors.lightGrayColor2,
                        onPressed: () async {
                          MyPopupMessage.showPopUpPickDate(
                            confirmText: 'bookingPractice.select'.tr(),
                            context: context,
                            initialDateTime: state.birthDate,
                            barrierDismissible: false,
                            cancelText: 'bookingClass.goBack'.tr(),
                            colorIcon: MyColors.greenColor,
                            onCancel: () {},
                            onConfirm: (date) {
                              context.read<UpdateInformationStateCubit>().updateBirthDate(date);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                UserInfoCard(
                  items: [
                    UserInfoItem('profile.idNumber'.tr(),
                        valueWidget: CustomTextField(
                          keyboardType: TextInputType.phone,
                          inputBorderNone: true,
                          hintText: state.idNumber?.isNotEmpty == true ? state.idNumber ?? '' : 'Số CCCD',
                          textStyle: TextStyle(fontSize: 13.sp),
                          onChanged: (value) => context.read<UpdateInformationStateCubit>().updateField('cccd', value),
                        )),
                    UserInfoItem(
                      'profile.dateOfIssue'.tr(),
                      valueWidget: RippleTextButton(
                        padding: EdgeInsets.zero,
                        text: state.dateOfIssue == null ? 'Chưa chọn' : DateFormat('dd/MM/yyyy').format(state.dateOfIssue!),
                        color: MyColors.lightGrayColor2,
                        onPressed: () async {
                          MyPopupMessage.showPopUpPickDate(
                            confirmText: 'bookingPractice.select'.tr(),
                            context: context,
                            barrierDismissible: false,
                            cancelText: 'bookingClass.goBack'.tr(),
                            colorIcon: MyColors.greenColor,
                            initialDateTime: state.dateOfIssue,
                            onCancel: () {},
                            onConfirm: (date) {
                              context.read<UpdateInformationStateCubit>().updateDateOfIssue(date);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),

                if (!state.isSubmitted)
                  Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: MyButton(
                        width: Dimens.getProportionalScreenWidth(context, 295),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        border: Border.all(
                          color: MyColors.mainColor,
                          width: 1,
                        ),
                        text: 'Gửi yêu cầu cập nhật',
                        colorText: MyColors.mainColor,
                        height: 38.h,
                        onPressed: (value) {
                          context.read<UpdateInformationStateCubit>().submitForm(
                              onSuccess: () {},
                              onError: (String error) {
                                MyPopupMessage.showPopUpWithIcon(
                                  title: 'Thông báo',
                                  context: context,
                                  barrierDismissible: false,
                                  description: error,
                                  colorIcon: MyColors.redColor,
                                  iconAssetPath: 'booking/booking_not_data.svg',
                                  confirmText: 'bookingClass.goBack'.tr(),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                if (state.isSubmitted)
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 16.w,vertical: 10.w),
                    child: Text(
                      state.msgSuccess ?? '',
                      style:  TextStyle(
                        color: const Color(0xFF9B9B9B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  )
              ],
            ),
          ),
        );
      },
    );
  }
}

class CustomPopupWidget extends StatefulWidget {
  const CustomPopupWidget({Key? key}) : super(key: key);

  @override
  _CustomPopupWidgetState createState() => _CustomPopupWidgetState();
}

class _CustomPopupWidgetState extends State<CustomPopupWidget> {
  OverlayEntry? _overlayEntry;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showPopup(context);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.blue,
        child: const Text('Nhấn vào đây để mở Popup'),
      ),
    );
  }

  void _showPopup(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = _createOverlayEntry(size, offset);
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _removePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry(Size size, Offset offset) {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: _removePopup,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _removePopup();
                      print('Item 1 Selected');
                    },
                    child: const Text('Popup Item 1'),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      _removePopup();
                      print('Item 2 Selected');
                    },
                    child: const Text('Popup Item 2'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PopupUnderWidget extends StatefulWidget {
  @override
  _PopupUnderWidgetState createState() => _PopupUnderWidgetState();
}

class _PopupUnderWidgetState extends State<PopupUnderWidget> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isPopupVisible = false;

  void _togglePopup(BuildContext context) {
    if (_isPopupVisible) {
      _hidePopup();
    } else {
      _showPopup(context);
    }
  }

  void _showPopup(BuildContext context) {
    final overlay = Overlay.of(context)!;
    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hidePopup,
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Positioned(
            // width: MediaQuery.of(context).size.width * 0.9,
            width: 240.w,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: const Offset(-20, 50),
              child: Material(
                elevation: 8.0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Chọn ngày tháng'),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('06'),
                          Text('08'),
                          Text('2020'),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(onPressed: _hidePopup, child: const Text('Hủy')),
                          TextButton(onPressed: _hidePopup, child: const Text('Chọn')),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    overlay.insert(_overlayEntry!);
    _isPopupVisible = true;
  }

  void _hidePopup() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _isPopupVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () => _togglePopup(context),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.orange),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text('Chọn ngày cấp'),
        ),
      ),
    );
  }
}
