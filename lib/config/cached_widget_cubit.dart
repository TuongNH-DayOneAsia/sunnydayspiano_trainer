import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dayoneasia/config/widget_cubit.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myutils/base/bloc/app_cubit.dart';

import 'cached_widget_state.dart';

abstract class CachedWidgetCubit<State extends CachedWidgetState> extends WidgetCubit<State> with HydratedMixin {
  CachedWidgetCubit({required super.widgetState, required this.parseJsonFunction}) {
    // Future.microtask(hydrate);
    hydrate();
    _checkInternetStatus();
    _listenInternetConnection();
  }

  bool? isInternetAvailable;
  StreamSubscription? _internetSubscription;
  ParseJsonFunction parseJsonFunction;

  @override
  State? fromJson(Map<String, dynamic> json) {
    try {
      final value = parseJsonFunction.call(json) as State?;
      return value;
    } catch (e) {
      clear();
      return null;
    }
  }

  @override
  Map<String, dynamic> toJson(State state) => state.toJson();

  //Function for call api, handle data loading, data error
  @override
  Future<T?> fetchApi<T>(Future<T> Function() apiFunction,
      {bool showLoading = true,
      bool loadFromCache = false,
      bool checkInternetBeforeFetchingData = true,
      bool showToastError = true,
      int millisecondsDelay = 0,
      bool showToastException = true,
      VoidCallback? onInternetRestored}) async {
    isInternetAvailable ??= await InternetConnectionChecker().hasConnection;
    if (isInternetAvailable == false) {
      showNormalToast('Kết nối mạng không ổn định, vui lòng thử lại sau');
      return Future.value();
    }
    //check loading, show loading before fetch api
    if (showLoading) {
      showEasyLoading();
    }

    await Future.delayed(Duration(milliseconds: millisecondsDelay));

    try {
      final response = await apiFunction.call();
      handleApiResponse(response,
          showLoading: showLoading, showToastError: showToastError, showToastException: showToastException);
      return response;
    } catch (err, stackTrace) {
      if (showLoading) {
        hideEasyLoading();
      }
      handleApiError(err, showToastException);
      return null;
    } finally {
      if (showLoading) {
        hideEasyLoading();
      }
    }
  }

  Future<void> _listenInternetConnection() async {
    // final appCubit = AppNavigator.navigatorKey.currentContext?.read<AppCubit>();
    _internetSubscription = AppCubit().stream.listen((event) {
      if (event.internetConnectionStatus == InternetConnectionStatus.connected &&
          event.connectivityResult != ConnectivityResult.none) {
        isInternetAvailable = true;
      } else {
        isInternetAvailable = false;
      }
    });
  }

  @override
  close() async {
    super.close();
    _internetSubscription?.cancel();
  }

  Future<void> _checkInternetStatus() async {
    isInternetAvailable = await InternetConnectionChecker().hasConnection;
  }
}

class ResultParser<OutputType> {
  ResultParser(this.json, this.parseJsonFunction);

  final Map<String, dynamic> json;
  final ParseJsonFunction parseJsonFunction;

  Future<OutputType> parseInBackground() async {
    final ReceivePort receivePort = ReceivePort();

    await Isolate.spawn(_decodeAndParseJson, receivePort.sendPort);

    return await receivePort.first as OutputType;
  }

  void _decodeAndParseJson(SendPort sendPort) async {
    final output = parseJsonFunction(json);
    Isolate.exit(sendPort, output);
  }
}

typedef ParseJsonFunction<OutputType> = OutputType Function(Map<String, dynamic> jsonData);
