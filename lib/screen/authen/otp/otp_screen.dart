import 'dart:async';

import 'package:dayoneasia/screen/authen/otp/cubit/otp_cubit_v2.dart';
import 'package:dayoneasia/screen/authen/otp/cubit/otp_state.dart';
import 'package:dayoneasia/screen/authen/reset_password/reset_password_screen.dart';
import 'package:dayoneasia/screen/authen/widget/authen_common_widget.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/utils/widgets/my_button.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/otp_field_style.dart';
import 'package:otp_text_field/style.dart';

class OtpScreen extends AuthenCommonWidget {
  final ForgetPasswordInput? forgetPasswordInput;
  static const route = '/otp';

  const OtpScreen({super.key, this.forgetPasswordInput});

  @override
  String get title => 'authentication.otp'.tr();

  @override
  Widget buildContent(BuildContext pageContext) {
    return BlocProvider(
      create: (context) => OtpCubitV2(forgetPasswordInput: forgetPasswordInput),
      child: _BuildBody(forgetPasswordInput: forgetPasswordInput),
    );
  }
}

class _BuildBody extends StatefulWidget {
  final ForgetPasswordInput? forgetPasswordInput;

  const _BuildBody({this.forgetPasswordInput});

  @override
  State<_BuildBody> createState() => _BuildBodyState();
}

class _BuildBodyState extends State<_BuildBody> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OtpCubitV2, OtpState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildVerificationMessage(widget.forgetPasswordInput?.emailOrPhone ?? ''),
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
                context.read<OtpCubitV2>().setPinCode(pin);
              },
            ),
            StreamBuilder<String>(
              stream: context.read<OtpCubitV2>().textErrorBehavior,
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
            CountdownTimer(
              durationInMinutes: 2,
              onTap: () async {

                return await context.read<OtpCubitV2>().callApiSendCodeVerify();

              },
              onTimeout: () {
                context.read<OtpCubitV2>().isOtpExpired = true;
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
                    stream: context.read<OtpCubitV2>().pinCode,
                    builder: (context, snapshot) {
                      return MyButton(
                        onPressed: (v) {
                          final pin = snapshot.data ?? '';
                          if (pin.length != 6) {
                            context.read<OtpCubitV2>().setErrorMessage('authentication.invalidVerificationCode'.tr());
                            return;
                          } else {
                            context.read<OtpCubitV2>().verifyCodeSms(
                                  emailOrPhone: widget.forgetPasswordInput?.emailOrPhone ?? '',
                                  pinCode: snapshot.data ?? '',
                                  onSuccess: (verifyCode) {
                                    context.push(
                                      ResetPasswordScreen.route,
                                      extra: ForgetPasswordInput(
                                        emailOrPhone: widget.forgetPasswordInput?.emailOrPhone ?? '',
                                        codeResetPassword: verifyCode,
                                      ),
                                    );
                                  },
                                );
                          }
                        },
                        text: 'authentication.next'.tr(),
                        height: 35,
                        isEnable: snapshot.data?.length == 6,
                        color: snapshot.data?.length == 6 ? MyColors.mainColor : MyColors.lightGrayColor.withOpacity(0.6),
                      );
                    })
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildVerificationMessage(String phone) {
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
          phone,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Text(
          'authentication.checkInboxAndEnterCode'.tr(),
          style: TextStyle(fontSize: 14),
        ),
      ],
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final int durationInMinutes;
  final Future<bool> Function() onTap;
  final VoidCallback onTimeout;

  const CountdownTimer({
    super.key,
    required this.durationInMinutes,
    required this.onTap,
    required this.onTimeout,
  });

  @override
  _CountdownTimerState createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late Timer _timer;
  late int _remainingSeconds;
  bool _isCountdownActive = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    print('initState _CountdownTimerState');
    _remainingSeconds = widget.durationInMinutes * 60;
    startTimer();
  }

  void startTimer() {
    setState(() {
      _isCountdownActive = true;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer.cancel();
          _isCountdownActive = false;
          widget.onTimeout(); // Gọi callback khi hết thời gian
        }
      });
    });
  }

  Future<void> resetTimer() async {
    if (!_isCountdownActive && !_isLoading) {
      setState(() {
        _isLoading = true;
      });

      bool success = await widget.onTap();

      if (success) {
        setState(() {
          _remainingSeconds = widget.durationInMinutes * 60;
          startTimer();
        });
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    if (_isCountdownActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  String get timerDisplay {
    final minutes = (_remainingSeconds / 60).floor().toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: (_isCountdownActive || _isLoading) ? null : resetTimer,
        child: Row(
          children: [
            Text(
              _isCountdownActive ? '${'authentication.enterVerificationCode'.tr()} ' : '${'authentication.resendOtp'.tr()} ',
              style: TextStyle(
                decoration: _isCountdownActive ? TextDecoration.none : TextDecoration.underline,
                fontSize: 14,
                color: MyColors.grayColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (_isCountdownActive)
              Text(
                timerDisplay,
                style: TextStyle(fontSize: 14, color: MyColors.grayColor, fontWeight: FontWeight.w400),
              ),
            if (_isLoading)
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(MyColors.grayColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
