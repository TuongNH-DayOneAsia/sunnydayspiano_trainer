import 'package:dayoneasia/screen/dashboard/profile/widget/avatar_widget.dart';
import 'package:dayoneasia/screen/profile/info_contract/cubit/info_contract_cubit.dart';
import 'package:dayoneasia/screen/profile/my_qr_code/my_qr_code_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/icon_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';

class InformationContractScreen extends BaseStatelessScreenV2 {
  static const String route = '/info-contract';

  InformationContractScreen({super.key});

  @override
  Color? get backgroundColor => MyColors.backgroundColor;

  bool reloadAvatar = false;

  @override
  String get title => 'Thông tin tài khoản'.tr();

  @override
  void onBack({required BuildContext context, bool? value}) {
    Navigator.of(context).pop(reloadAvatar);
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => InfoContractCubit()..callApiGetProfileInformation(),
      child: BlocBuilder<InfoContractCubit, InfoContractState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state.userOutput != null) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Expanded(
                      child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _upLoadAvt(pageContext, state),
                        SizedBox(height: 10.h),
                        _buildListButton(context, state),
                        SizedBox(height: 20.h),
                        UserInfoCard(
                          items: [
                            UserInfoItem('profile.studentCode'.tr(),
                                value: state.userOutput?.data?.studentCode ??
                                    '---'),
                            // UserInfoItem('Chi nhánh đăng ký'.tr(), value: state.userOutput?.data?.branches?.join(', ') ?? '---'),
                            UserInfoItem('Chi nhánh đăng ký'.tr(),
                                value: state.userOutput?.data?.branch ?? '---'),
                            UserInfoItem('profile.contractSigningDate'.tr(),
                                value: state.userOutput?.data?.dateContract ??
                                    '---'),
                            UserInfoItem('Ngày bắt đầu',
                                value: state.userOutput?.data?.contractStartDate ??
                                    '---'),
                            UserInfoItem('Ngày kết thúc',
                                value: state.userOutput?.data?.contractEndDate ??
                                    '---'),
                            // UserInfoItem('profile.timeStart'.tr(), value: state.userOutput?.data?.dateStart ?? '---'),
                            // UserInfoItem('profile.timeEnd'.tr(), value: state.userOutput?.data?.dateEnd ?? '---'),
                            if (!context.read<InfoContractCubit>().inDev)
                              UserInfoItem('Số buổi còn lại',
                                  value: state.userOutput?.data
                                          ?.numberShowContractAvailable
                                          .toString() ??
                                      '---'),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        UserInfoCard(
                          items: [
                            UserInfoItem('profile.fullName'.tr(),
                                value: state.userOutput?.data?.name ?? '---'),
                            if (!context
                                .read<InfoContractCubit>()
                                .inReleaseIOSFromApi)
                              UserInfoItem('profile.gender'.tr(),
                                  value:
                                      state.userOutput?.data?.gender ?? '---'),
                            if (state.userOutput?.data?.phone?.isNotEmpty ==
                                true)
                              UserInfoItem('profile.phoneNumber'.tr(),
                                  value:
                                      state.userOutput?.data?.phone ?? '---'),
                            UserInfoItem('profile.email'.tr(),
                                value: state.userOutput?.data?.email ?? '---'),
                            if (state.userOutput?.data?.birthday?.isNotEmpty ==
                                true)
                              UserInfoItem('profile.dateOfBirth'.tr(),
                                  value: state.userOutput?.data?.birthday ??
                                      '---'),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        UserInfoCard(
                          items: [
                            UserInfoItem('profile.idNumber'.tr(),
                                value: state.userOutput?.data?.cccd ?? '---'),
                            UserInfoItem('profile.dateOfIssue'.tr(),
                                value: state.userOutput?.data?.cccdDateIssue ??
                                    '---'),
                            UserInfoItem('profile.placeOfIssue'.tr(),
                                value: state.userOutput?.data?.cccdPlaceIssue ??
                                    '---'),
                          ],
                        ),
                      ],
                    ),
                  )),
                  // Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(vertical: 20.h),
                  //     child: MyButton(
                  //       width: Dimens.getProportionalScreenWidth(pageContext, 295),
                  //       fontSize: 14.sp,
                  //       fontWeight: FontWeight.w400,
                  //       border: Border.all(
                  //         color: MyColors.mainColor,
                  //         width: 1,
                  //       ),
                  //       text: 'Cập nhật thông tin',
                  //       colorText: MyColors.mainColor,
                  //       height: 38.h,
                  //       onPressed: (value) {
                  //         context.push(UpdateInformationScreen.route, extra: state.userOutput?.data);
                  //       },
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  Widget _buildListButton(BuildContext pageContext, InfoContractState state) {
    // if(pageContext.read<InfoContractCubit>().inReleaseProgress){
    //   return const SizedBox();
    // }
    return MyButton(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      leadingIcon: Container(
          child: MyAppIcon.iconNamedCommon(
              iconName: "profile/bell.svg",
              color: Colors.white,
              width: 16.w,
              height: 16.h)),
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      border: Border.all(
        color: MyColors.mainColor,
        width: 1,
      ),
      text: 'profile.yourQRCode'.tr(),
      color: MyColors.mainColor,
      colorText: Colors.white,
      height: 26.h,
      onPressed: (value) {
        if (state.userOutput?.data?.qrcodePath?.isNotEmpty == true) {
          pageContext.push(MyQrCodeScreen.route, extra: state.userOutput?.data);
        } else {
          SnackBar snackBar = SnackBar(
            content: Text('Mã QR chưa được cập nhật',
                style: TextStyle(color: Colors.white, fontSize: 14.sp)),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(pageContext).showSnackBar(snackBar);
        }
      },
    );
  }

  Widget _upLoadAvt(BuildContext pageContext, InfoContractState state) {
    return BlocBuilder<InfoContractCubit, InfoContractState>(
      builder: (context, state) {
        return Column(
          children: [
            // BlocBuilder<MainCubit, MainState>(
            //   builder: (context, state) {
            //     return Container(
            //       color: MyColors.mainColor,
            //       padding: const EdgeInsets.all(16),
            //       child: Row(
            //         children: [
            //           AvatarWidget(
            //               onTap: () {
            //                 context.read<ProfileCubit>().choseImage();
            //               },
            //               urlAvt: state.userOutput?.data?.avatar ?? ''),
            //           const SizedBox(width: 16),
            //           Column(
            //             crossAxisAlignment: CrossAxisAlignment.start,
            //             children: [
            //               Text(
            //                 state.userOutput?.data?.name ?? '---',
            //                 style: const TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold,
            //                 ),
            //               ),
            //               Text(
            //                 state.userOutput?.data?.email ?? '---',
            //                 style: const TextStyle(color: Colors.white),
            //               ),
            //             ],
            //           ),
            //         ],
            //       ),
            //     );
            //   },
            // ),

            // InkWell(
            //   onTap: (){
            //     context.read<InfoContractCubit>().choseImage(onSuccess: () {
            //       print('success');
            //       reloadAvatar = true;
            //     }, isDenied: () {
            //       ToolHelper.showSettingsPopupOpenSetting(
            //           context: context,
            //           title: 'Mở quyền truy cập thư viện ảnh',
            //           description:
            //           'Cho phép ứng dụng truy cập vào thư viện ảnh để thay đổi ảnh đại diện.');
            //     });
            //   },
            //   child: CircleAvatar(
            //     radius: 54.w,
            //     backgroundImage: NetworkImage(state.userOutput?.data?.avatar ?? ''),
            //     backgroundColor: Colors.transparent,
            //   ),
            // ),
            InkWell(
              onTap: () {
                context.read<InfoContractCubit>().choseImage(onSuccess: () {
                  print('success');
                  reloadAvatar = true;
                }, isDenied: () {
                  ToolHelper.showSettingsPopupOpenSetting(
                      context: context,
                      title: 'Mở quyền truy cập thư viện ảnh',
                      description:
                          'Cho phép ứng dụng truy cập vào thư viện ảnh để thay đổi ảnh đại diện.');
                });
              },
              child: AvatarWidget(
                padding: const EdgeInsets.all(16),
                isUpload: true,
                urlAvt: state.userOutput?.data?.avatar ?? '',
                size: 120,
              ),
            ),
            SizedBox(height: 14.h),
            Text(
              state.userOutput?.data?.name ?? '---',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: MyColors.darkGrayColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }
}

class UserInfoCard extends StatelessWidget {
  final List<UserInfoItem> items;

  const UserInfoCard({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        child: Column(
          children: _buildChildrenWithDividers(),
        ),
      ),
    );
  }

  List<Widget> _buildChildrenWithDividers() {
    final List<Widget> childrenWithDividers = [];
    for (int i = 0; i < items.length; i++) {
      childrenWithDividers.add(_buildInfoRow(items[i].label, items[i].value,
          valueWidget: items[i].valueWidget));
      if (i < items.length - 1) {
        childrenWithDividers.add(const DividerWidget());
      }
    }
    return childrenWithDividers;
  }

  Widget _buildInfoRow(String label, String? value, {Widget? valueWidget}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: MyColors.darkGrayColor,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: valueWidget ??
                Text(
                  value ?? '---',
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w400,
                      color: MyColors.lightGrayColor2),
                ),
          ),
        ],
      ),
    );
  }
}

class UserInfoItem {
  final String label;
  final String? value;
  final Widget? valueWidget;

  UserInfoItem(this.label, {this.value, this.valueWidget});
}

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Divider(
        color: Color(0xFFF0F0F0),
        thickness: 1,
      ),
    );
  }
}
