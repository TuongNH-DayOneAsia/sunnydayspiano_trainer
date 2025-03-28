import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/data/repositories/otp/otp_service.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

part 'apple_forget_password_state.dart';

class AppleForgetPasswordCubit extends WidgetCubit<AppleForgetPasswordState> {
  AppleForgetPasswordCubit() : super(widgetState: AppleForgetPasswordInitial()) {
    var dataApiKeyPrivate = localeManager.loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson);
    if (dataApiKeyPrivate != null) {
      dataApiKeyPrivate.typeOtp = '2';
      localeManager.setObject(StorageKeys.apiKeyPrivate, dataApiKeyPrivate.toJson());
    }
    isValidStream = phoneOrEmailSubject.stream.map((phone) => ''.validateEmail(phone).isEmpty);
  }

  final AuthenRepository authenRepository = injector();
  final OtpService otpService = injector();

  final phoneOrEmailSubject = BehaviorSubject<String>.seeded('');
  late Stream<bool> isValidStream;

  void onPhoneOrEmailChanged(String email) {
    phoneOrEmailSubject.add(email);
  }

  String validateInput(String value) {
    return ''.validateEmail(value);
  }

  Future<void> callApiSendCodeVerify() async {
    await _handleApiOtp();
  }

  Future<void> _handleApiOtp() async {
    emit(AppleForgetPasswordLoading());

    try {
      final request = await fetchApi(() => authenRepository.sendCodeVerify({
            'email': phoneOrEmailSubject.value,
            'phone': '',
          }));
      if (request?.statusCode == ApiStatusCode.success) {
        emit(AppleForgetPasswordSuccess());
      } else {
        if (language == 'en') {
          final translatedMessage = await ToolHelper.translateText(request?.message ?? '');
          emit(AppleForgetPasswordError(translatedMessage));
        } else {
          emit(AppleForgetPasswordError(request?.message ?? ''));
        }
      }
    } catch (e) {
      _handleError(e);
    }
  }

  void _handleError(dynamic error) {
    emit(AppleForgetPasswordError(MyString.messageError));
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
