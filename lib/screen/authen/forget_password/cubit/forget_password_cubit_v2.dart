import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/authen/forget_password/cubit/forget_password_state_v2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

class ForgetPasswordCubitV2 extends WidgetCubit<ForgetPasswordStateV2> {
  ForgetPasswordCubitV2() : super(widgetState: ForgetPasswordInitialV2()) {
    isValidStream = phoneOrEmailSubject.stream.map((phone) => ''.validatePhone(phone).isEmpty);
    // isValidStream = phoneOrEmailSubject.stream
    //     .map((phone) => inReleaseIOS ? ''.validateEmail(phone).isEmpty : ''.validatePhone(phone).isEmpty);
  }

  final AuthenRepository authenRepository = injector();
  final OtpService otpService = injector();

  final phoneOrEmailSubject = BehaviorSubject<String>.seeded('');
  late Stream<bool> isValidStream;

  void onPhoneOrEmailChanged(String email) {
    phoneOrEmailSubject.add(email);
  }

  String titleTextField() {
    return 'authentication.phoneNumber'.tr();
  }

  String validateInput(String value) {
    return ''.validatePhone(value);
  }

  Future<void> callApiSendCodeVerify() async {
    _handleApiOtpV2();
  }

  Future<void> _handleApiOtpV2() async {
    try {
      final request = await fetchApi(
          () async => authenRepository.sendCodeVerifySms({
                'device_id': await deviceIdApp(),
                'phone': phoneOrEmailSubject.value,
              }),
          showLoading: true);
      if (request?.statusCode == ApiStatusCode.success) {
        emit(ForgetPasswordSuccessV2());
      } else {
        if (language == 'en') {
          final translatedMessage = await ToolHelper.translateText(request?.message ?? '');
          emit(ForgetPasswordErrorV2(translatedMessage));
        } else {
          emit(ForgetPasswordErrorV2(request?.message ?? ''));
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    emit(ForgetPasswordErrorV2(MyString.messageError));
    hideEasyLoading();
  }





  @override
  Future<void> close() {
    // TODO: implement close
    phoneOrEmailSubject.close();
    return super.close();
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }
}
