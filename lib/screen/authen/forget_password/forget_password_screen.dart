import 'package:dayoneasia/screen/authen/forget_password/cubit/forget_password_cubit_v2.dart';
import 'package:dayoneasia/screen/authen/otp/otp_screen.dart';
import 'package:dayoneasia/screen/authen/widget/authen_common_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:myutils/utils/widgets/customt_textfield_widget.dart';
import 'package:myutils/utils/widgets/my_button.dart';

import 'cubit/forget_password_state_v2.dart';

class ForgetPasswordScreen extends AuthenCommonWidget {
  static const String route = '/forget-password';

  const ForgetPasswordScreen({super.key});

  @override
  String get title => 'authentication.forgotPassword'.tr();

  @override
  Widget buildContent(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => ForgetPasswordCubitV2(),
      child: const _Body(),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ForgetPasswordCubitV2, ForgetPasswordStateV2>(
      listener: (context, state) {
        if (state is ForgetPasswordSuccessV2) {
          context.push(OtpScreen.route,
              extra: ForgetPasswordInput(
                  emailOrPhone: context.read<ForgetPasswordCubitV2>().phoneOrEmailSubject.value,
                  verifyIdFirebase: state.verificationId));
        }
        if (state is ForgetPasswordErrorV2) {
          MyPopupMessage.showPopUpWithIcon(
            title: 'profile.notification'.tr(),
            context: context,
            barrierDismissible: false,
            description: state.error,
            colorIcon: MyColors.redColor,
            iconAssetPath: 'booking/booking_not_data.svg',
            confirmText: 'bookingClass.goBack'.tr(),
          );
        }
      },
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('authentication.forgotPassword'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.darkGrayColor,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 20),
            Text(context.read<ForgetPasswordCubitV2>().titleTextField(),
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.darkGrayColor,
                  fontWeight: FontWeight.w600,
                )),
            const SizedBox(height: 5),
            CustomTextField(
              keyboardType: TextInputType.phone,
              hintText: '${'authentication.enter'.tr()} ${context.read<ForgetPasswordCubitV2>().titleTextField().toLowerCase()}',
              onChanged: (email) {
                context.read<ForgetPasswordCubitV2>().onPhoneOrEmailChanged(email);
              },
              validateInput: (value) {
                return context.read<ForgetPasswordCubitV2>().validateInput(value);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MyButton(
                  text: "profile.cancel".tr(),
                  borderRadius: 50,
                  height: 35.h,
                  fontWeight: FontWeight.w500,
                  // fontSize: 12,
                  border: Border.all(color: MyColors.lightGrayColor, width: 0.5),
                  colorText: MyColors.lightGrayColor,
                  onPressed: (a) {
                    context.pop();
                  },
                ),
                const SizedBox(width: 10),
                StreamBuilder<bool>(
                    stream: context.read<ForgetPasswordCubitV2>().isValidStream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: MyButton(
                          // fontSize: 12,
                          onPressed: (v) {
                            if (snapshot.data!) {
                              context.read<ForgetPasswordCubitV2>().callApiSendCodeVerify();
                            }
                          },
                          height: 35,
                          isLoading: state is ForgetPasswordLoadingV2,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          text: 'authentication.sendVerificationCode'.tr(),
                          color: snapshot.data! ? MyColors.mainColor : MyColors.lightGrayColor.withOpacity(0.6),
                        ),
                      );
                    }),
              ],
            ),
          ],
        );
      },
    );
  }
}
