import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/network/model/input/apple_register_account_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

part 'apple_confirm_password_state.dart';

class AppleConfirmPasswordCubit extends WidgetCubit<AppleConfirmPasswordState> {
  final AppleRegisterAccountInput? appleRegisterAccountInput;

  AppleConfirmPasswordCubit({this.appleRegisterAccountInput}) : super(widgetState: const AppleConfirmPasswordState()) {
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

  Future<void> callApiCreateAccount({required Function() onSuccess, required Function(String message) onError}) async {
    appleRegisterAccountInput?.password = newPasswordSubject.value;
    appleRegisterAccountInput?.confirmPassword = confirmPasswordSubject.value;

    try {
      final request = await fetchApi(() => authenRepository.appleRegisterAccount(appleRegisterAccountInput!));
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
