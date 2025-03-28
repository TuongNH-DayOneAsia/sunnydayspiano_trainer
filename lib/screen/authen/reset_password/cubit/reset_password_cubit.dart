import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/authen/reset_password/cubit/reset_password_state.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/base_output.dart';
import 'package:myutils/data/network/model/input/forget_password_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

class ResetPasswordCubit extends WidgetCubit<ResetPasswordState> {
  ResetPasswordCubit(this.forgetPasswordInput) : super(widgetState: const ResetPasswordState(null)) {
    isValidStream = Rx.combineLatest2(
      newPasswordSubject.stream,
      confirmPasswordSubject.stream,
      (String newPassword, String confirmPassword) {
        bool isNewPasswordValid = ''.validatePassword(newPassword).isEmpty;
        bool isConfirmPasswordValid = ''.validatePassword(confirmPassword).isEmpty;
        bool arePasswordsMatching = newPassword == confirmPassword;
        return isNewPasswordValid && isConfirmPasswordValid && arePasswordsMatching;
      },
    );
  }

  final ForgetPasswordInput? forgetPasswordInput;

  final AuthenRepository authenRepository = injector();
  final newPasswordSubject = BehaviorSubject<String>.seeded('');
  final confirmPasswordSubject = BehaviorSubject<String>.seeded('');
  late Stream<bool> isValidStream;

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  @override
  Future<void> close() {
    // TODO: implement close
    newPasswordSubject.close();
    confirmPasswordSubject.close();

    return super.close();
  }

  Future<void> callApiResetPassword({required Function() onSuccess, required Function(String message) onError}) async {
    forgetPasswordInput?.password = newPasswordSubject.value;
    forgetPasswordInput?.confirmPassword = confirmPasswordSubject.value;
    try {
      BaseOutput? request;
      if (inReleaseIOSFromApi) {
        request = await fetchApi(() => authenRepository.resetPassword((forgetPasswordInput?.toJsonResetEmail() ?? {})));
      } else {
        request = await fetchApi(() => isOtpFirebase
            ? authenRepository.resetPasswordOtp(forgetPasswordInput)
            : authenRepository.resetPassword((forgetPasswordInput?.toJsonResetPhone() ?? {})));
      }

      if (request?.statusCode == ApiStatusCode.success) {
        print('success');
        onSuccess();
      } else {
        if (language == 'en') {
          onError(await ToolHelper.translateText(request?.message ?? ''));
        } else {
          onError(request?.message ?? '');
        }
      }
    } catch (e) {
      print('error: $e');
      onError(isDebug ? e.toString() : MyString.messageError);
    }
  }
}
