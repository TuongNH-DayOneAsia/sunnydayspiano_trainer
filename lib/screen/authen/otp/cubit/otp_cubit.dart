import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/authen/otp/cubit/otp_state.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/data/network/model/output/verify_code_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

class OtpCubit extends WidgetCubit<OtpState> {
  OtpCubit({this.forgetPasswordInput}) : super(widgetState: const OtpState(null));

  final AuthenRepository authenRepository = injector();
  final ForgetPasswordInput? forgetPasswordInput;
  final textErrorBehavior = BehaviorSubject<String>.seeded('');
  final pinCode = BehaviorSubject<String>.seeded('');
  final OtpService otpService = injector();

  bool isOtpExpired = false;

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  String get titlePhoneOrEmail => forgetPasswordInput?.emailOrPhone ?? '';

  @override
  Future<void> close() async {
    textErrorBehavior.close();
    pinCode.close();
    super.close();
  }

  void setPinCode(String pinCode) => this.pinCode.add(pinCode);

  Future<bool> _handleFirebaseOtp() async {
    showEasyLoading();
    try {
      Completer<bool> completer = Completer<bool>();
      await otpService.verifyOtp(
        numberPhone: forgetPasswordInput?.emailOrPhone ?? '',
        codeSent: (value) async {
          hideEasyLoading();
          completer.complete(true);
        },
        verificationFailed: (message) {
          setErrorMessage(message);
          hideEasyLoading();
          completer.complete(false);
        },
      );

      return await completer.future;
    } catch (e) {
      setErrorMessage(MyString.messageError);
      hideEasyLoading();
      return false;
    }
  }

  Future<void> setErrorMessage(String message) async {
    if (textErrorBehavior.value != message) {
      if (language == 'en') {
        textErrorBehavior.add(await ToolHelper.translateText(message));
      } else {
        textErrorBehavior.add(message);
      }
    }
  }



  Future<bool> callApiSendCodeVerify() async {
    isOtpExpired = false;
    if (isOtpFirebase) {
      return await _handleFirebaseOtp();
    } else {
      return await _handleApiOtp();
    }
  }

  Future<bool> _handleApiOtp() async {
    try {
      var data = {
        'email': isOtpFirebase ? forgetPasswordInput?.emailOrPhone ?? '' : '',
        'phone': isOtpFirebase ? '' : forgetPasswordInput?.emailOrPhone ?? '',
      };
      final request = await fetchApi(() => authenRepository.sendCodeVerify(data));
      if (request?.statusCode == ApiStatusCode.success) {
        print('success');
        setErrorMessage('');
        return true;
      }
      setErrorMessage(request?.message ?? '');
      return false;
    } catch (e) {
      setErrorMessage('Đã xảy ra lỗi. Vui lòng thử lại sau.');
      return false;
    }
  }

  Future<void> verifyCode({
    required String pinCode,
    required Function(String) onSuccess,
  }) async {
    if (isOtpExpired) {
      setErrorMessage('Mã OTP đã hết hạn');
      return;
    }

    if (isOtpFirebase) {
      await _verifyOtpFirebase(
        verificationId: forgetPasswordInput?.verifyIdFirebase ?? '',
        onSuccess: () => _verifyCodeFirebase(
            phone: forgetPasswordInput?.emailOrPhone ?? '',
            verifyId: forgetPasswordInput?.verifyIdFirebase ?? '',
            onSuccess: onSuccess),
        onError: setErrorMessage,
      );
    } else {
      await _verifyCodeEmail(emailOrPhone: forgetPasswordInput?.emailOrPhone ?? '', pinCode: pinCode, onSuccess: onSuccess);
    }
  }

  Future<void> _verifyCodeEmail({
    required String emailOrPhone,
    required String pinCode,
    required Function(String) onSuccess,
  }) async {
    try {
      print('isOtpFirebase: $isOtpFirebase');

      VerifyCodeOutput? request;
      if (inReleaseIOSFromApi) {
        request = await fetchApi(() => authenRepository.verifyCode({
              'email': emailOrPhone,
              'phone': '',
              'code_verify': pinCode,
            }));
      } else {
        request = await fetchApi(() => authenRepository.verifyCode({
              'email': isOtpFirebase ? forgetPasswordInput?.emailOrPhone ?? '' : '',
              'phone': isOtpFirebase ? '' : forgetPasswordInput?.emailOrPhone ?? '',
              'code_verify': pinCode,
            }));
      }

      if (request?.statusCode == ApiStatusCode.success) {
        onSuccess(request?.data?.codeResetPassword ?? '');
      } else {
        setErrorMessage(request?.message ?? '');
      }
    } catch (e) {
      setErrorMessage(MyString.messageError);
      print('error: $e');
    }
  }

  Future<void> _verifyOtpFirebase({
    required String verificationId,
    required Function() onSuccess,
    required Function(String) onError,
  }) async {
    showEasyLoading();
    try {
      await otpService.signInWithPhoneNumber(
        verificationId: verificationId,
        smsCode: pinCode.value,
        onSuccess: () {
          hideEasyLoading();
          onSuccess();
        },
        onError: (message) {
          hideEasyLoading();
          if (message != textErrorBehavior.value) {
            onError(message);
          }
        },
      );
    } catch (e) {
      hideEasyLoading();
      onError('Đã có lỗi xảy ra, vui lòng thử lại sau.');
      print('error: $e');
    }
  }

  Future<void> _verifyCodeFirebase({
    required String phone,
    required String verifyId,
    required Function(String) onSuccess,
  }) async {
    try {
      final request = await authenRepository.verifyCodeOtp({
        'phone': phone,
        'verify_id_firebase': verifyId,
      });
      if (request.statusCode == ApiStatusCode.success) {
        onSuccess(request.data?.codeResetPassword ?? '');
      } else {
        setErrorMessage(request.message ?? '');
      }
    } catch (e) {
      setErrorMessage(MyString.messageError);
      print('error: $e');
    }
  }
}
