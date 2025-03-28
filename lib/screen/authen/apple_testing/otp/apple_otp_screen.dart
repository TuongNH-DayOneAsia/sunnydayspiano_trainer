import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/base_state_less_screen_v2.dart';
import 'package:myutils/utils/widgets/my_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

import '../confirm/apple_confirm_password_screen.dart';
import 'cubit/apple_otp_screen_cubit.dart';

class AppleOtpScreen extends BaseStatelessScreenV2 {
  final AppleRegisterAccountInput? appleRegisterAccountInput;
  static const String route = '/apple-otp';

  const AppleOtpScreen({
    super.key,
    this.appleRegisterAccountInput,
  });

  @override
  String get title => 'OTP';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppleOtpScreenCubit(appleRegisterAccountInput: appleRegisterAccountInput),
      child: super.build(context),
    );
  }

  Widget buildVerificationMessage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'authentication.enterVerificationCode'.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          'authentication.verificationCodeSentMessage'.tr(),
          style: const TextStyle(fontSize: 14),
        ),
        Text(
          appleRegisterAccountInput?.email ?? '',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          'authentication.checkInboxAndEnterCode'.tr(),
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  @override
  Widget buildBody(BuildContext pageContext) {
    return BlocBuilder<AppleOtpScreenCubit, AppleOtpScreenState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildVerificationMessage(),
              const SizedBox(height: 16),
              OTPTextField(
                spaceBetween: 12,
                otpFieldStyle: OtpFieldStyle(
                  borderColor: Colors.grey,
                  focusBorderColor: MyColors.mainColor,
                ),
                length: 6,
                width: MediaQuery.of(context).size.width,
                fieldWidth: 50,
                style: const TextStyle(fontSize: 14),
                textFieldAlignment: MainAxisAlignment.spaceAround,
                fieldStyle: FieldStyle.box,
                onChanged: (pin) {
                  context.read<AppleOtpScreenCubit>().setPinCode(pin);
                },
              ),
              StreamBuilder<String>(
                stream: context.read<AppleOtpScreenCubit>().textErrorBehavior,
                builder: (context, snapshot) {
                  if (snapshot.data?.isNotEmpty == true) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text(snapshot.data!,
                          style: TextStyle(
                            fontSize: 12,
                            color: MyColors.redColor,
                            fontWeight: FontWeight.w400,
                          )),
                    );
                  } else {
                    return const SizedBox(
                      height: 10,
                    );
                  }
                },
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  MyButton(
                    text: "profile.cancel".tr(),
                    borderRadius: 50,
                    height: 35,
                    fontWeight: FontWeight.w500,
                    border: Border.all(color: MyColors.lightGrayColor, width: 0.5),
                    colorText: MyColors.lightGrayColor,
                    onPressed: (a) {
                      context.pop();
                    },
                  ),
                  const SizedBox(width: 10),
                  StreamBuilder<String>(
                      stream: context.read<AppleOtpScreenCubit>().pinCode,
                      builder: (context, snapshot) {
                        return MyButton(
                          onPressed: (v) {
                            final pin = snapshot.data ?? '';
                            if (pin.length != 6) {
                              context.read<AppleOtpScreenCubit>().setErrorMessage('authentication.invalidVerificationCode'.tr());
                              return;
                            } else {
                              context.read<AppleOtpScreenCubit>().verifyOtpEmail(
                                onSuccess: () {
                                  print('success');
                                  context.push(AppleConfirmPasswordScreen.route, extra: appleRegisterAccountInput);
                                },
                                onError: (String) {
                                  print('error');
                                },
                              );
                            }
                          },
                          text: 'authentication.next'.tr(),
                          height: 35.h,
                          isEnable: snapshot.data?.length == 6,
                          color: snapshot.data?.length == 6 ? MyColors.mainColor : MyColors.lightGrayColor.withOpacity(0.6),
                        );
                      })
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
