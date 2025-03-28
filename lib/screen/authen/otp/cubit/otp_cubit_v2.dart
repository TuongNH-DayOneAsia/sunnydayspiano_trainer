import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/authen/otp/cubit/otp_state.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

class OtpCubitV2 extends WidgetCubit<OtpState> {
  OtpCubitV2({this.forgetPasswordInput}) : super(widgetState: const OtpState(null));

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

  Future<void> verifyCodeSms({
    required String emailOrPhone,
    required String pinCode,
    required Function(String) onSuccess,
  }) async {
    try {
      print('isOtpFirebase: $isOtpFirebase');

      final request = await fetchApi(() => authenRepository.verifyCode({
            'email': '',
            'phone': emailOrPhone,
            'code_verify': pinCode,
          }));

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
    return await _handleApiOtpV2();
  }


  Future<bool> _handleApiOtpV2() async {
    try {
      final request = await fetchApi(
          () async => authenRepository.sendCodeVerifySms({
                'device_id': await deviceIdApp(),
                'phone': forgetPasswordInput?.emailOrPhone ?? '',
              }),
          showLoading: true);
      if (request?.statusCode == ApiStatusCode.success) {
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
}
