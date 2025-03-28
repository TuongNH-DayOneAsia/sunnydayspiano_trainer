import 'package:dayoneasia/config/firebase_config.dart';
import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:dayoneasia/screen/authen/login/cubit/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/helpers/extension/string_extension.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:rxdart/rxdart.dart';

class LoginCubit extends WidgetCubit<LoginState> {
  LoginCubit() : super(widgetState: const LoginState(null)) {
    isValidStream = Rx.combineLatest2(
      phoneOrEmailSubject.stream.map((phone) => inReleaseIOSFromApi
          ? ''.validateEmail(phone).isEmpty
          : ''.validatePhone(phone).isEmpty),
      passwordSubject.stream
          .map((password) => ''.validatePassword(password).isEmpty),
      (a, b) => a && b,
    );
  }

  final AuthenRepository authenRepository = injector();
  final phoneOrEmailSubject = BehaviorSubject<String>.seeded('');
  final textErrorSubject = BehaviorSubject<String>.seeded('');
  final passwordSubject = BehaviorSubject<String>();
  late Stream<bool> isValidStream;

  String get bannerApp =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.bannerApp ??
      '';

  void onPhoneChanged(String email) {
    phoneOrEmailSubject.add(email);
  }

  void onPasswordChanged(String password) {
    passwordSubject.add(password);
  }

  @override
  Future<void> close() {
    // TODO: implement close
    phoneOrEmailSubject.close();
    passwordSubject.close();
    textErrorSubject.close();
    return super.close();
  }

  @override
  void onWidgetCreated() {
    if (kDebugMode) {
      print('isOtpFirebase: $isOtpFirebase');
    }
    // TODO: implement onWidgetCreated
  }

  Future<void> callApiLogin({
    required Function() onSuccess,
    required Function(String message) onError,
    Function(String)? onMaintenance,
  }) async {
    if (inReleaseIOSFromApi) {
      await callApiLoginWithEmail(onSuccess: onSuccess, onError: onError);
    } else {
      await callApiLoginWithPhone(
          onSuccess: onSuccess, onError: onError, onMaintenance: onMaintenance);
    }
  }

  Future<void> callApiLoginWithEmail({
    required Function() onSuccess,
    required Function(String message) onError,
  }) async {
    try {
      final deviceId = await deviceIdApp();
      final data = {
        'email': phoneOrEmailSubject.value.trim(),
        'password': passwordSubject.value.trim(),
        'device_id': deviceId,
      };

      final request =
          await fetchApi(() => authenRepository.loginWithEmail(data));

      if (request?.statusCode == ApiStatusCode.success) {
        await localeManager.setStringValue(
            StorageKeys.accessToken, request?.data?.token ?? '');
        await localeManager.setObject(
            StorageKeys.userInfoLogin, request?.data?.toJson() ?? {});
        LocalStream.shared.setLoggedIn(true);
        onSuccess();
      } else {
        final errorMessage = request?.message ?? '';
        if (language == 'en') {
          final translatedMessage =
              await ToolHelper.translateText(errorMessage);
          textErrorSubject.add(translatedMessage);
          onError(translatedMessage);
        } else {
          textErrorSubject.add(errorMessage);
          onError(errorMessage);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      textErrorSubject.add(MyString.messageError);
      onError(MyString.messageError);
    }
  }

  Future<void> callApiLoginWithPhone({
    required Function() onSuccess,
    required Function(String message) onError,
    Function(String)? onMaintenance,
  }) async {
    bool? isMaintenance = localeManager
            .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
            ?.isMaintenance ??
        false;

    String? isMaintenanceMsg = localeManager
            .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
            ?.isMaintenanceMessage ??
        '';

    if (isMaintenance) {
      onMaintenance?.call(isMaintenanceMsg ?? '');
      return;
    }
    try {
      final accountBase =
          '$apiKeyBase${phoneOrEmailSubject.value.trim()}${injector<AppConfig>().keyLogin ?? ''}$apiKeyBase${passwordSubject.value.trim()}$apiKeyBase';
      var accountBaseToBase64 = ToolHelper.stringToBase64Encode(accountBase);
      accountBaseToBase64 =
          ToolHelper.stringToBase64Encode(accountBaseToBase64);
      showEasyLoading();
      final data = {
        'account_base': accountBaseToBase64,
        'device_id': await deviceIdApp(),
        'fcm_token': await getFcmToken(),
        'device_info': await ToolHelper.getDeviceInfo(),
      };
      if (kDebugMode) {
        print('data: ${data.toString()}');
      }
      final request = await fetchApi(
          () => authenRepository.loginWithPhone(data),
          showLoading: false);
      if (request?.statusCode == ApiStatusCode.success) {
        await localeManager.setStringValue(
            StorageKeys.accessToken, request?.data?.token ?? '');
        await localeManager.setObject(
            StorageKeys.userInfoLogin, request?.data?.toJson() ?? {});
        HapticFeedback.lightImpact();
        LocalStream.shared.setLoggedIn(true);
        hideEasyLoading();
        onSuccess();
      } else {
        final errorMessage = request?.message ?? '';
        if (language == 'en') {
          final translatedMessage =
              await ToolHelper.translateText(errorMessage);
          textErrorSubject.add(translatedMessage);
          hideEasyLoading();

          onError(translatedMessage);
        } else {
          textErrorSubject.add(errorMessage.isNotEmpty == true
              ? errorMessage
              : MyString.messageError);
          hideEasyLoading();

          onError(errorMessage.isNotEmpty == true
              ? errorMessage
              : MyString.messageError);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error: $e');
      }
      textErrorSubject.add(MyString.messageError);
      hideEasyLoading();

      onError(MyString.messageError);
    }
  }
}
