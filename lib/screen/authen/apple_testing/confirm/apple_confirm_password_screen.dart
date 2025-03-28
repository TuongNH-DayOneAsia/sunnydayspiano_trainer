import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/apple_confirm_password_cubit.dart';

class AppleConfirmPasswordScreen extends BaseStatelessScreenV2 {
  static const String route = '/apple-confirm-password';
  final AppleRegisterAccountInput? appleRegisterAccountInput;

  const AppleConfirmPasswordScreen({
    super.key,
    this.appleRegisterAccountInput,
  });
  @override
  String get title => 'Confirm Password';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppleConfirmPasswordCubit(appleRegisterAccountInput: appleRegisterAccountInput),
      child: super.build(context),
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<AppleConfirmPasswordCubit, AppleConfirmPasswordState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('authentication.enterNewPassword'.tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      )),
                  const SizedBox(height: 20),
                  Text(
                    'authentication.newPassword'.tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    onChanged: context.read<AppleConfirmPasswordCubit>().newPasswordSubject.add,
                    isPassword: true,
                    hintText: "authentication.pleaseEnterNewPassword".tr(),
                    validateInput: (value) {
                      return ''.validatePassword(value);
                    },
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "authentication.confirmNewPassword".tr(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  CustomTextField(
                    onChanged: context.read<AppleConfirmPasswordCubit>().confirmPasswordSubject.add,
                    hintText: "authentication.pleaseConfirmNewPassword".tr(),
                    isPassword: true,
                    validateInput: (value) {
                      if (value.isEmpty) {
                        return "authentication.pleaseReEnterPassword".tr();
                      }
                      if (value != context.read<AppleConfirmPasswordCubit>().newPasswordSubject.value) {
                        return "authentication.passwordsDoNotMatch".tr();
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
                        text: "profile.cancel".tr(),
                        borderRadius: 50,
                        height: 35,
                        fontWeight: FontWeight.w500,
                        // fontSize: 12,
                        border: Border.all(color: MyColors.lightGrayColor, width: 0.5),
                        colorText: MyColors.lightGrayColor,
                        onPressed: (a) {
                          context.pop();
                          context.pop();
                        },
                      ),
                      const SizedBox(width: 10),
                      StreamBuilder<bool>(
                        stream: context.read<AppleConfirmPasswordCubit>().isValidStream,
                        initialData: false,
                        builder: (context, snapshot) {
                          return MyButton(
                              // fontSize: 12,
                              height: 35,
                              text: 'authentication.save'.tr(),
                              color: snapshot.data! ? MyColors.mainColor : MyColors.grey,
                              onPressed: (value) {
                                context.read<AppleConfirmPasswordCubit>().callApiCreateAccount(onSuccess: () {
                                  context.pop();
                                  context.pop();
                                  context.pop();
                                  print(appleRegisterAccountInput);
                                }, onError: (String message) {
                                  MyPopupMessage(context).showError(
                                    title: 'profile.notification'.tr(),
                                    error: message,
                                  );
                                });
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
