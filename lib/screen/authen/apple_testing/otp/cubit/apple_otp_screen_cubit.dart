import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

part 'apple_otp_screen_state.dart';

class AppleOtpScreenCubit extends WidgetCubit<AppleOtpScreenState> {
  AppleOtpScreenCubit({this.appleRegisterAccountInput}) : super(widgetState: const AppleOtpScreenState()) {
    print('appleRegisterAccountInput: $appleRegisterAccountInput');
  }

  final AuthenRepository authenRepository = injector();
  final textErrorBehavior = BehaviorSubject<String>.seeded('');
  final pinCode = BehaviorSubject<String>.seeded('');
  final OtpService otpService = injector();
  final AppleRegisterAccountInput? appleRegisterAccountInput;

  bool isOtpExpired = false;

  @override
  Future<void> close() async {
    textErrorBehavior.close();
    pinCode.close();
    super.close();
  }

  void setPinCode(String pinCode) => this.pinCode.add(pinCode);

  Future<void> setErrorMessage(String message) async {
    if (textErrorBehavior.value != message) {
      if (language == 'en') {
        textErrorBehavior.add(await ToolHelper.translateText(message));
      } else {
        textErrorBehavior.add(message);
      }
    }
  }

  Future<void> verifyOtpEmail({
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    showEasyLoading();
    try {
      final data = {
        "email": appleRegisterAccountInput?.email ?? '',
        // "phone": appleRegisterAccountInput?.phone ?? '',
        "code_verify": pinCode.value,
      };
      final sendOtp = await fetchApi(() => authenRepository.appleSendOtp(data));
      if (sendOtp?.statusCode == ApiStatusCode.success) {
        appleRegisterAccountInput?.codeConfirmApple = sendOtp?.data?.code ?? '';

        onSuccess();
      } else {
        setErrorMessage(sendOtp?.message ?? '');
      }
    } catch (e) {
      setErrorMessage('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      print('error: $e');
    }
  }

  Future<void> verifyOtpFirebase({
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    showEasyLoading();
    try {
      await otpService.signInWithPhoneNumber(
        verificationId: appleRegisterAccountInput?.verifyIdFirebase ?? '',
        smsCode: pinCode.value,
        onSuccess: () async {
          final data = {
            "phone": appleRegisterAccountInput?.phone ?? '',
            "otp": pinCode.value,
          };
          final sendOtp = await fetchApi(() => authenRepository.appleSendOtp(data));
          if (sendOtp?.statusCode == ApiStatusCode.success) {
            appleRegisterAccountInput?.codeConfirmApple = pinCode.value;
            hideEasyLoading();
            onSuccess();
          } else {
            setErrorMessage(sendOtp?.message ?? '');
          }
        },
        onError: (message) {
          hideEasyLoading();
          if (message != textErrorBehavior.value) {
            setErrorMessage(message);
          }
        },
      );
    } catch (e) {
      hideEasyLoading();
      setErrorMessage('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      print('error: $e');
    }
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}
