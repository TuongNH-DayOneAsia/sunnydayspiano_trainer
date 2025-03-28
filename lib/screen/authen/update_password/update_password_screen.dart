import 'package:dayoneasia/screen/authen/update_password/cubit/update_password_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import '../login/login_screen.dart';

class UpdatePasswordScreen extends BaseStatelessScreenV2 {
  final bool isCanPop;
  static const String route = '/updatePasswordScreen';

  const UpdatePasswordScreen({
    super.key,
    required this.isCanPop,
  }) : super(automaticallyImplyLeading: isCanPop);

  @override
  // TODO: implement title
  String? get title => 'authentication.changePassword'.tr();
  @override
  Widget build(BuildContext context){
    return BlocProvider(
        create: (context) => UpdatePasswordCubit()
          ..startAutoUpdate(
            onError: (message) {
              MyPopupMessage(context).showError(
                title: 'profile.notification'.tr(),
                error: message,
              );
            },
          ),
        child: super.build(context)
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    print('isCanPop: $isCanPop');
    return WillPopScope(
      onWillPop: () async {
        if (isCanPop) {
          // pageContext.pop(true);
          return true;
        }
        return false;
      },
      child: BlocProvider(
        create: (context) => UpdatePasswordCubit()
          ..startAutoUpdate(
            onError: (message) {
              MyPopupMessage(context).showError(
                title: 'profile.notification'.tr(),
                error: message,
              );
            },
          ),
        child: BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.all(16.0.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    Text(
                      'authentication.currentPassword'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      onChanged: context.read<UpdatePasswordCubit>().oldPasswordSubject.add,
                      isPassword: true,
                      hintText: "authentication.enterCurrentPassword".tr(),
                      validateInput: (value) {
                        return ''.validatePassword(value);
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'authentication.newPassword'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        height: 0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      onChanged: context.read<UpdatePasswordCubit>().newPasswordSubject.add,
                      isPassword: true,
                      hintText: "authentication.pleaseEnterNewPassword".tr(),
                      validateInput: (value) {
                        return ''.validatePassword(value,
                            checkPasswordOld: context.read<UpdatePasswordCubit>().oldPasswordSubject.value);
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'authentication.confirmNewPassword'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CustomTextField(
                      onChanged: context.read<UpdatePasswordCubit>().confirmPasswordSubject.add,
                      hintText: "authentication.pleaseConfirmNewPassword".tr(),
                      isPassword: true,
                      validateInput: (value) {
                        if (value.isEmpty) {
                          return 'authentication.pleaseReEnterPassword'.tr();
                        }
                        if (value != context.read<UpdatePasswordCubit>().newPasswordSubject.value) {
                          return 'authentication.passwordsDoNotMatch'.tr();
                        }
                        return '';
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Text(
                      'authentication.passwordRequirementsDetailed'.tr(),
                      style: const TextStyle(
                        color: Color(0xFF808080),
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 35),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (!isCanPop)
                          MyButton(
                            text: "Huỷ",
                            borderRadius: 50,
                            height: 35,
                            fontWeight: FontWeight.w500,
                            // fontSize: 12,
                            border: Border.all(color: MyColors.lightGrayColor, width: 0.5),
                            colorText: MyColors.lightGrayColor,
                            onPressed: (a) {
                              MyPopupMessage.confirmPopUp(
                                cancelText: 'Huỷ',
                                confirmText: 'Đồng ý',
                                title: 'Huỷ đổi mật khẩu',
                                context: context,
                                barrierDismissible: false,
                                description: 'Bạn có chắc chắn muốn huỷ đổi mật khẩu, nếu bạn huỷ sẽ mất dữ liệu đã đăng nhập?',
                                onConfirm: () {
                                  context.pushReplacement(LoginScreen.route);

                                  context.read<UpdatePasswordCubit>().callApiLogout(
                                    onError: (message) {
                                      MyPopupMessage(context).showError(
                                        title: 'Thông báo',
                                        error: message,
                                        // hideCancelBtn: true,
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        const SizedBox(width: 10),
                        StreamBuilder<bool>(
                          stream: context.read<UpdatePasswordCubit>().isValidStream,
                          initialData: false,
                          builder: (context, snapshot) {
                            return MyButton(
                                // fontSize: 12,
                                height: 35,
                                border: Border.all(color: snapshot.data! ? MyColors.mainColor : MyColors.grey, width: 0.5),
                                text: 'authentication.save'.tr(),
                                color: snapshot.data! ? MyColors.mainColor : MyColors.grey,
                                onPressed: (value) {
                                  context.read<UpdatePasswordCubit>().callApiChangePassword(
                                      onSuccess: () {},
                                      onError: (message) {
                                        MyPopupMessage(context).showError(
                                          title: 'profile.notification'.tr(),
                                          error: message,
                                        );
                                        print('message: $message');
                                      });
                                  print('value: $value');
                                });
                          },
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BuildBody extends StatefulWidget {
  final bool isCanPop;

  const _BuildBody({super.key, required this.isCanPop});

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (!widget.isCanPop) {
      SystemChannels.platform.invokeMethod('SystemNavigator.routeInformationUpdated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdatePasswordCubit, UpdatePasswordState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.0.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40.h),
                Text(
                  'Mật khẩu hiện tại',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  onChanged: context.read<UpdatePasswordCubit>().oldPasswordSubject.add,
                  isPassword: true,
                  hintText: "Vui lòng điền mật khẩu hiện tại",
                  validateInput: (value) {
                    return ''.validatePassword(value);
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  'Mật khẩu mới',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  onChanged: context.read<UpdatePasswordCubit>().newPasswordSubject.add,
                  isPassword: true,
                  hintText: "Vui lòng điền mật khẩu mới",
                  validateInput: (value) {
                    return ''.validatePassword(value);
                  },
                ),
                const SizedBox(height: 18),
                Text(
                  'Xác nhận mật khẩu mới',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                CustomTextField(
                  onChanged: context.read<UpdatePasswordCubit>().confirmPasswordSubject.add,
                  hintText: "Vui lòng xác nhận mật khẩu mới",
                  isPassword: true,
                  validateInput: (value) {
                    if (value.isEmpty) {
                      return 'Vui lòng nhập lại mật khẩu';
                    }
                    if (value != context.read<UpdatePasswordCubit>().newPasswordSubject.value) {
                      return 'Mật khẩu không khớp';
                    }
                    return '';
                  },
                ),
                const SizedBox(
                  height: 18,
                ),
                const Text(
                  'Mật khẩu gồm: 8 kí tự, ít nhất 1 kí tự hoa, 1 kí tự đặc biệt, bao gồm kí tự chữ và số',
                  style: TextStyle(
                    color: Color(0xFF808080),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    height: 0,
                  ),
                ),
                const SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    MyButton(
                      text: "Huỷ",
                      borderRadius: 50,
                      height: 35,
                      fontWeight: FontWeight.w500,
                      // fontSize: 12,
                      border: Border.all(color: MyColors.lightGrayColor, width: 0.5),
                      colorText: MyColors.lightGrayColor,
                      onPressed: (a) {
                        MyPopupMessage.confirmPopUp(
                          cancelText: 'Huỷ',
                          confirmText: 'Đồng ý',
                          title: 'Huỷ đổi mật khẩu',
                          context: context,
                          barrierDismissible: false,
                          description: 'Bạn có chắc chắn muốn huỷ đổi mật khẩu, nếu bạn huỷ sẽ mất dữ liệu đã đăng nhập?',
                          onConfirm: () {
                            context.read<UpdatePasswordCubit>().callApiLogout(
                              onError: (message) {
                                MyPopupMessage(context).showError(
                                  title: 'Thông báo',
                                  error: message,
                                  // hideCancelBtn: true,
                                );
                              },
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    StreamBuilder<bool>(
                      stream: context.read<UpdatePasswordCubit>().isValidStream,
                      initialData: false,
                      builder: (context, snapshot) {
                        return MyButton(
                            // fontSize: 12,
                            height: 35,
                            border: Border.all(color: snapshot.data! ? MyColors.mainColor : MyColors.grey, width: 0.5),
                            text: 'Lưu',
                            color: snapshot.data! ? MyColors.mainColor : MyColors.grey,
                            onPressed: (value) {
                              context.pop(true);
                              print('value: $value');
                            });
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
