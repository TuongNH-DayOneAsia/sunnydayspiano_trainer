import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myutils/base/bloc/app_state.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/data/network/model/input/api_key_input.dart';
import 'package:myutils/data/repositories/authen_repository.dart';

class AppCubit extends WidgetCubit<AppState> {
  AppCubit() : super(widgetState: const AppState()) {
    // callApiKeyPrivate();
    _checkInternetStatus();
    _listenConnectivity();
    _listenInternetConnectionStatus();
  }

  StreamSubscription? _connectivitySubscription;
  StreamSubscription? _internetConnectionStatusSubscription;
  AuthenRepository authenRepository = injector();

  Future<void> _listenConnectivity() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((event) async {
      // logger.d('connectivity changed: $event');
      if (event.first != ConnectivityResult.none) {
        final internetConnectionStatus =
            await InternetConnectionChecker().connectionStatus;
        emit(state.copyWith(
            internetConnectionStatus: internetConnectionStatus,
            connectivityResult: event.first));
      } else {
        emit(state.copyWith(
          connectivityResult: event.first,
        ));
      }
    });
  }

  Future<void> _listenInternetConnectionStatus() async {
    _internetConnectionStatusSubscription =
        InternetConnectionChecker().onStatusChange.listen((event) {
      // logger.d('internet connection status changed: $event');
      emit(state.copyWith(
        internetConnectionStatus: event,
      ));
    });
  }

  @override
  Future<void> close() {
    _connectivitySubscription?.cancel();
    _internetConnectionStatusSubscription?.cancel();
    return super.close();
  }

  Future<void> _checkInternetStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    final internetConnectionStatus =
        await InternetConnectionChecker().connectionStatus;
    emit(state.copyWith(
      connectivityResult: connectivityResult.first,
      internetConnectionStatus: internetConnectionStatus,
    ));
  }

  @override
  void onWidgetCreated() {
    // TODO: implement onWidgetCreated
  }

  Future<void> callApiKeyPrivate() async {
    final data = ApiKeyInput(
        keyRandom: injector<AppConfig>().keyRandom ?? '',
        appSunnyDay: injector<AppConfig>().appSunnyDay ?? '',
        apiUserPassword: injector<AppConfig>().apiUserPassword ?? '',
        apiUserId: injector<AppConfig>().apiUserId ?? '');
    try {
      final request = await authenRepository.keyPrivate(data);
      if (request.statusCode == ApiStatusCode.success) {
        if (request.data?.apiKeyPrivate?.isNotEmpty == true) {
          localeManager.setObject(
              StorageKeys.apiKeyPrivate, request.data!.toJson());
          emit(state.copyWith(dataKeyPrivate: request.data));
          if (kDebugMode) {
            print(
                'request.data?.apiKeyPrivate: ${request.data?.firebaseConfigData}');
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  String cachedLanguage() {
    return localeManager.getString(StorageKeys.cachedLang) ?? 'vi';
  }
}
