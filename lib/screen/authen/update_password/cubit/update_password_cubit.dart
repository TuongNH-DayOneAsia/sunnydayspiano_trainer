import 'dart:async';

import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

part 'update_password_state.dart';

class UpdatePasswordCubit extends WidgetCubit<UpdatePasswordState> {
  UpdatePasswordCubit() : super(widgetState: UpdatePasswordState()) {
    isValidStream = Rx.combineLatest3(
      oldPasswordSubject.stream,
      newPasswordSubject.stream,
      confirmPasswordSubject.stream,
      (String currentPassword, String newPassword, String confirmPassword) {
        bool isCurrentPasswordValid = ''.validatePassword(currentPassword).isEmpty;
        bool isNewPasswordValid = ''.validatePassword(newPassword).isEmpty;
        bool isConfirmPasswordValid = ''.validatePassword(confirmPassword).isEmpty;
        bool arePasswordsMatching = newPassword == confirmPassword;
        bool isDifferentFromOldPassword = currentPassword != newPassword;

        return isCurrentPasswordValid &&
            isNewPasswordValid &&
            isConfirmPasswordValid &&
            arePasswordsMatching &&
            isDifferentFromOldPassword;
      },
    );
  }

  final AuthenRepository authenRepository = injector();
  final oldPasswordSubject = BehaviorSubject<String>.seeded('');
  final newPasswordSubject = BehaviorSubject<String>.seeded('');
  final confirmPasswordSubject = BehaviorSubject<String>.seeded('');
  final newCodeVerifySubject = BehaviorSubject<String>.seeded('');
  late Stream<bool> isValidStream;
  Timer? _autoUpdateTimer;

  @override
  Future<void> close() {
    // Cancel timer when cubit is closed
    _autoUpdateTimer?.cancel();
    return super.close();
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  void startAutoUpdate({required Function(String message) onError}) {
    callApiSendCodeChangePassword(onError: (message) {
      onError.call(message);
    });

    _autoUpdateTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      callApiSendCodeChangePassword(onError: (message) {
        onError.call(message);
      });
    });
  }

  // changePasswordInHome
  Future<void> callApiLogout({required Function(String message) onError}) async {
    // clearCacheGoToLogin();

    var data = {"virtual": ""};
    try {
      final request = await fetchApi(() => authenRepository.logout(data));
      if (request?.statusCode == ApiStatusCode.success) {
        localeManager.clearDataLocalLogout();
        LocalStream.shared.setLoggedIn(false);
        print('logout success');
        // clearCacheGoToLogin();
      } else {
        onError.call(request?.message ?? '');
      }
    } catch (e) {
      onError.call(isDebug ? e.toString() : MyString.messageError);

      print('error: $e');
    }
  }

  Future<void> callApiChangePassword({required Function() onSuccess, required Function(String message) onError}) async {
    var data = {
      "device_id": await deviceIdApp(),
      "new_code_verify": newCodeVerifySubject.value,
      "password_old": oldPasswordSubject.value,
      "password": newPasswordSubject.value,
      "confirm_password": confirmPasswordSubject.value
    };
    try {
      final request = await fetchApi(() => authenRepository.changePasswordInHome(data));
      if (request?.statusCode == ApiStatusCode.success && request?.data == true) {
        clearCacheGoToLogin();
      } else {
        if (language == 'en') {
          onError.call(await ToolHelper.translateText(request?.message ?? ''));
        } else {
          onError.call(request?.message ?? '');
        }
      }
    } catch (e) {
      onError.call(MyString.messageError);
    }
  }

  //sendCodeChangePassword
  Future<void> callApiSendCodeChangePassword({required Function(String message) onError}) async {
    var data = {"device_id": await deviceIdApp()};
    try {
      final request = await fetchApi(() => authenRepository.sendCodeChangePassword(data));
      if (request?.statusCode == ApiStatusCode.success && request?.data?.newCodeVerify?.isNotEmpty == true) {
        newCodeVerifySubject.add(request?.data?.newCodeVerify ?? '');
        return;
      } else {
        if (language == 'en') {
          onError.call(await ToolHelper.translateText(request?.message ?? ''));
        } else {
          if (request?.statusCode != ApiStatusCode.tokenExpired) {
            onError.call(request?.message ?? '');
          }
        }
      }
    } catch (e) {
      onError.call(isDebug ? e.toString() : MyString.messageError);
      print('error: $e');
    }
  }
}
