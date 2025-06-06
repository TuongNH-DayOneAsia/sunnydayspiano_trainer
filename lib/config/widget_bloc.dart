import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dayoneasia/router/my_router.dart';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/day_one_application.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/network/model/input/api_key_input.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';
import 'package:myutils/data/network/model/output/login_output.dart';
import 'package:myutils/data/repositories/authen_repository.dart';
import 'package:myutils/helpers/extension/colors_extension.dart';
import 'package:myutils/helpers/tools/remote_config_manager.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/popup/my_popup_message.dart';
import 'package:package_info_plus/package_info_plus.dart';

abstract class WidgetBloc<Event, State> extends Bloc<Event, State> {


  void onWidgetCreated();



  WidgetBloc({required State widgetState}) : super(widgetState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onWidgetCreated();
    });


  }

  //
  bool get isDebug => injector<AppConfig>().debugTag;
  LocaleManager localeManager = injector();

  String get language =>
      localeManager.getString(StorageKeys.cachedLang) ?? 'vi';

  String get accessToken =>
      localeManager.getString(StorageKeys.accessToken) ?? '';

  String get apiKeyPrivate =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.apiKeyPrivate ??
          '';

  bool get isOtpFirebase =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.isOtpFirebase ??
          false;

  String get slug =>
      localeManager
          .loadSavedObject(StorageKeys.userInfoLogin, DataLogin.fromJson)
          ?.slug ??
          '';

  String get apiKeyBase =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.apiKeyBase ??
          '';

  String get urlPolicy =>
      localeManager
          .loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
          ?.clauseLink ??
          'https://sunnydays.vn/privacy-policy';

  final bool inReleaseProgress = (injector<RemoteConfigManager>()
      .getFirebaseConfigData()
      .inReleaseProgress ??
      false);
  AuthenRepository _authenRepository = injector();

  bool get inReleaseIOSFromApi => (((localeManager
      .loadSavedObject(
      StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)
      ?.firebaseConfigData
      .inReleaseProgress ??
      false)) &&
      Platform.isIOS);

  final bool inDev =
  (injector<RemoteConfigManager>().getFirebaseConfigData().inDev ?? false);
  bool _isLoggingOut = false;
  bool _isForeUpdate = false;

  Future<String> deviceIdApp() async {
    final deviceId = await ToolHelper.getDeviceId();
    return deviceId;
  }

  void showToast(
      String? message, {
        int? timeInSecForIosWeb,
        double? fontSize = 12,
        Color? backgroundColor,
        Color? textColor,
        bool webShowClose = false,
        ToastGravity? toastGravity = ToastGravity.TOP,
      }) {
    if ((message?.isNotEmpty ?? false) == true) {
      Fluttertoast.showToast(
        timeInSecForIosWeb: timeInSecForIosWeb ?? 3,
        msg: message ?? '',
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity,
        backgroundColor: backgroundColor,
        textColor: textColor,
        fontSize: fontSize,
      );
    }
  }

  Future<void> showEasyLoading() {
    return EasyLoading.show(
        indicator: const CircularProgressIndicator(),
        maskType: EasyLoadingMaskType.custom);
  }

  Future<void> hideEasyLoading() {
    return EasyLoading.dismiss(animation: true);
  }

  void showErrorToast(String? message) {
    showToast(message, backgroundColor: MyColors.crimsonRed);
  }

  void showSuccessToast(String? message) {
    showToast(message, backgroundColor: MyColors.emerald);
  }

  void showNormalToast(String? message) {
    // Commented implementation as in original code
  }

  void showNormalNotificationDialog({String? title, required String? content}) {
    // Commented implementation as in original code
  }

  Future<T?> fetchApi<T>(Future<T> Function() apiFunction,
      {bool showLoading = true,
        bool loadFromCache = false,
        bool checkInternetBeforeFetchingData = true,
        bool showToastError = true,
        int millisecondsDelay = 0,
        bool showToastException = true,
        VoidCallback? onInternetRestored}) async {
    final hasInternetConnection =
        await Connectivity().checkConnectivity() != ConnectivityResult.none;

    if (checkInternetBeforeFetchingData && !hasInternetConnection) {
      if (kDebugMode) {
        print('WidgetBloc fetchApi no internet connection');
      }
      if (showToastError) {
        showToast('Không có kết nối mạng',
            backgroundColor: MyColors.crimsonRed);
      }
      return Future.value();
    }

    if (showLoading && hasInternetConnection) {
      showEasyLoading();
    }

    await Future.delayed(Duration(milliseconds: millisecondsDelay));

    try {
      final response = await apiFunction.call();
      handleApiResponse(response,
          showLoading: showLoading,
          showToastError: showToastError,
          showToastException: showToastException);
      return response;
    } catch (err, stackTrace) {
      if (showLoading) {
        hideEasyLoading();
      }
      handleApiError(err, showToastException);
      return null;
    } finally {
      if (showLoading && hasInternetConnection) {
        hideEasyLoading();
      }
    }
  }

  @override
  Future<void> close() async {
    super.close();
    // Drain stream to prevent emit state after closing bloc
    stream.drain();
  }

  Future handleApiError(err, showPopupException) async {
    if (err is dio.DioException && !isClosed) {
      if (showPopupException == true) {
        // showErrorToast('${err.message} [${err.requestOptions.path}]');
      }
      if (kDebugMode) {
        print(err.requestOptions.path);
        print(err.requestOptions.uri);
        print(err.requestOptions.headers);
        print(err.requestOptions.queryParameters);
        print(err.requestOptions.data);
        print(err.requestOptions.extra);
        print('Response: ');
        print(err.response);
        print(err.error);
      }
    } else {
      if (!isClosed) {
        // showErrorToast(err.toString());
      }
      if (kDebugMode) {
        print(err.toString());
      }
    }
  }

  Future<void> handleApiResponse(dynamic response,
      {bool showLoading = true,
        bool showToastError = true,
        bool showToastException = true}) async {
    if (showLoading) {
      hideEasyLoading();
    }

    if (response?.statusCode == ApiStatusCode.tokenExpired) {
      if (!isClosed) {
        if (kDebugMode) {
          print('Token expired');
        }
        await clearCacheGoToLogin();
      }
      await close();
      return;
    }

    if (response?.statusCode != ApiStatusCode.success && showToastError) {
      // response?.message?.let(showNormalToast);
    }
  }

  void forceUpdate() async {
    try {
      final config = localeManager.loadSavedObject(
          StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson);
      bool isForceUpdate = config?.isForceUpdate ?? false;
      if (!isForceUpdate) return;

      String latestVersion = Platform.isIOS
          ? config?.appLastVersioniOS ?? ''
          : config?.appLastVersionAndroid ?? '';
      bool isRequireForceUpdate = config?.isRequireForceUpdate ?? false;

      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (packageInfo.version != latestVersion) {
        MyPopupMessage.confirmPopUp(
          cancelText: isRequireForceUpdate ? '' : 'Huỷ',
          confirmText: 'Đồng ý',
          title: 'Cập nhật ứng dụng',
          context: GlobalContext.context!,
          barrierDismissible: false,
          description: 'Có phiên bản mới. Bạn có muốn cập nhật không?',
          onConfirm: () => ToolHelper.openAppStore(),
        );
      }
    } catch (e) {
      print('Force update error: $e');
    }
  }

  Future<void> clearCacheGoToLogin() async {
    if (_isLoggingOut) return;
    _isLoggingOut = true;
    try {
      await localeManager.clearDataLocalLogout();
      myRouter.go(LoginScreen.route);
      EventBus.shared.setLoggedIn(false);
      print('clearCacheGoToLogin');
      callApiKeyPrivate();
    } finally {
      _isLoggingOut = false;
    }
  }

  Future<void> callApiKeyPrivate() async {
    final data = ApiKeyInput(
        keyRandom: injector<AppConfig>().keyRandom ?? '',
        appSunnyDay: injector<AppConfig>().appSunnyDay ?? '',
        apiUserPassword: injector<AppConfig>().apiUserPassword ?? '',
        apiUserId: injector<AppConfig>().apiUserId ?? '');
    try {
      final request = await _authenRepository.keyPrivate(data);
      if (request.statusCode == ApiStatusCode.success) {
        if (request.data?.apiKeyPrivate?.isNotEmpty == true) {
          localeManager.setObject(
              StorageKeys.apiKeyPrivate, request.data!.toJson());
          print(
              'request.data?.apiKeyPrivate: ${request.data?.firebaseConfigData}');
        }
      }
    } catch (e) {
      print(e);
    }
  }

  // void on<E extends Event>(EventPredicate<E> predicate, EventHandler<E, State> handler) {
  //   super.on<E>(predicate, handler);
  // }

  // Example event mapper for common event handling pattern
  void mapEventToState<E extends Event>(
      E event,
      Future<State> Function(E event) handler,
      ) async {
    try {
      final newState = await handler(event);
      emit(newState);
    } catch (error) {
      // Handle error case
      handleApiError(error, true);
    }
  }
}