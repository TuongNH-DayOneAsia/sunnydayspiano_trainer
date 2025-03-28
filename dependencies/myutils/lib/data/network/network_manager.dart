// ignore_for_file: avoid_dynamic_calls

import 'dart:convert';

import 'package:dayoneasia/router/my_router.dart';
import 'package:dayoneasia/screen/authen/login/login_screen.dart';
import 'package:dayoneasia/screen/authen/welcome/welcome_screen.dart';
import 'package:dayoneasia/screen/dashboard/home/home_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/config/local_stream.dart';
import 'package:myutils/constants/api_constant.dart';
import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/cache_helper/cache_helper.dart';
import 'package:myutils/helpers/tools/tool_helper.dart';
import 'package:myutils/utils/multipart_file_extend.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'model/output/api_key_output.dart';
import 'model/output/refresh_token_output.dart';
import 'package:logger/logger.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:logger/logger.dart';

var logger = Logger(
  printer: PrettyPrinter(),
);

var loggerNoStack = Logger(
  printer: PrettyPrinter(
    methodCount: 2,
    // Number of method calls to be displayed
    errorMethodCount: 8,
    // Number of method calls if stacktrace is provided
    lineLength: 120,
    // Width of the output
    colors: true,
    // Colorful log messages
    printEmojis: true,
    // Should each log print contain a timestamp
    dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
  ),
);

class PendingRequestInfo {
  PendingRequestInfo({
    required this.options,
    this.requestHandler,
    this.responseHandler,
  });

  final RequestOptions options;
  final RequestInterceptorHandler? requestHandler;
  final ResponseInterceptorHandler? responseHandler;
}

class NetworkManager {
  NetworkManager() {
    _localeManager = injector();
    initDio();
    _listenToConnectivity();
  }

  Dio? _dio;
  Dio? _refreshTokenDio;
  LocaleManager? _localeManager;

  static const int connectTimeout = 60000;
  static const int receiveTimeout = 60000;

  String _baseUrl = '';
  String _baseUrlImage = '';
  String _accessToken = '';
  final String _refreshTokenPath = 'api/students/refresh-token';
  final List<PendingRequestInfo> _listPendingRequest = [];
  bool _isRefreshingToken = false;
  final List<PendingRequestInfo> _offlineRequests = [];
  final ConnectivityService _connectivityService = ConnectivityService();
  void _listenToConnectivity() {
    _connectivityService.connectivityStream.listen((isConnected) {
      if (isConnected) {
        _executeOfflineRequests();
      }
    });
  }
  void _executeOfflineRequests() {
    for (var request in _offlineRequests) {
      _makeRequest(
        request.options.method,
        request.options.path,
        queryParameters: request.options.queryParameters,
        data: request.options.data,
        headers: request.options.headers,
        extra: request.options.extra,
      );
    }
    _offlineRequests.clear();
  }

  void initDio() {
    _baseUrl = injector<AppConfig>().baseUrl ?? '';
    if (kDebugMode) {
      print("_baseUrl: $_baseUrl");
    }
    _baseUrlImage = injector<AppConfig>().urlImage ?? '';
    _accessToken = _localeManager?.getString(StorageKeys.accessToken) ?? '';
    final options = BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(milliseconds: connectTimeout),
      receiveTimeout: const Duration(milliseconds: receiveTimeout),
      validateStatus: (_) => true,
      headers: getCommonHeaders(),
    );

    if (kDebugMode) {
      print('path: $_baseUrl');
      print('_baseUrlImage: $_baseUrlImage');
    }

    _dio = Dio(options);
    _refreshTokenDio = Dio(options);
    _configRefreshToken();
    // _dio?.interceptors.add(PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseBody: true,
    //     responseHeader: false,
    //     error: true,
    //     compact: true,
    //     maxWidth: 90,
    //     enabled: kDebugMode,
    //     filter: (options, args){
    //       // don't print requests with uris containing '/posts'
    //       if(options.path.contains('/posts')){
    //         return false;
    //       }
    //       // don't print responses with unit8 list data
    //       return !args.isResponse || !args.hasUint8ListData;
    //     }
    // )
    // );
  }

  Future<String?> getIPAddress() async {
    try {
      Dio getIPAddress = Dio();

      final response = await getIPAddress.get('https://api.ipify.org');

      if (kDebugMode) {
        print('IP Address API Response: ${response?.data}');
        print('IP Address API Response Type: ${response?.data.runtimeType}');
      }

      if (response?.statusCode == 200) {
        return response?.data?.toString().trim();
      } else {
        if (kDebugMode) {}
        return null;
      }
    } on DioException catch (e) {
      if (kDebugMode) {}
      return null;
    } catch (e) {
      if (kDebugMode) {}
      return null;
    }
  }

  Map<String, dynamic> getCommonHeaders({String? accept, String? contentType}) {
    return {
      'Accept': accept ?? 'application/json',
      ApiConstant.contentType: contentType ?? 'application/json',
      ApiConstant.authorization: 'Bearer $_accessToken',
      ApiConstant.keyPrivate:
          _localeManager?.loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)?.apiKeyPrivate ?? '',
    };
  }

  void _configRefreshToken() {
    _dio?.interceptors.add(InterceptorsWrapper(
      onRequest: _handleRequest,
      onResponse: _handleResponse,
    ));
  }

  Future<void> _logApiRequest({Map<String, dynamic>? data, required String currentPath}) async {
    List<String> listPathAuthen = [
      "api/systems/key-private",
      "api/students/send-code-verify",
      "api/students/verify-code",
      "api/students/reset-password",
      "api/students/login",
      "api/accounts/login",
      "api/students/logout",
      "api/students/otp/verify",
      "api/students/otp/send-code-verify",
      "api/students/otp/reset-password",
      "api/students/send-code-change-password",
      "api/students/change-password",
      "api/accounts/register",
      "api/accounts/send-otp",
      "api/accounts/delete/",
      "api/accounts/validate-account",
      "api/students/check-phone-exists",
      "api/students/send-code-verify-sms"
    ];

    if (listPathAuthen.contains(currentPath)) {
      return;
    }

    try {
      await _dio?.post(
        'api/app-error-log',
        data: data,
        options: Options(headers: getCommonHeaders()),
        cancelToken: CancelToken(),
      );
    } catch (e) {
      print('Failed to log API request: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>?> _makeRequest(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    bool isFormData = false,
  }) async {
    Response? result;
    late Options options;

    final input = (method == RequestMethod.get)
        ? queryParameters
        : (method == RequestMethod.post || method == RequestMethod.put ? data : '');

    Map<String, dynamic> _createLogData() => {
          "url": path,
          "method": method,
          "input": jsonEncode(input) ?? '',
          "output": jsonEncode(result?.data) ?? '',
        };

    try {
      if (!await _connectivityService.checkInitialConnection()) {
        _offlineRequests.add(PendingRequestInfo(
          options: RequestOptions(
            path: path,
            method: method,
            queryParameters: queryParameters,
            data: data,
            headers: headers,
            extra: extra,
          ),
        ));
        throw Exception('No internet connection');
      }

      updateHeader();
      options = Options(
        method: method,
        headers: {...getCommonHeaders(), ...?headers},
        extra: extra,
      );

      result = await _dio?.request(
        path,
        queryParameters: queryParameters,
        options: options,
        data: data,
        cancelToken: CancelToken(),
      );
      //
      if (result?.data['status_code'] != ApiStatusCode.success && result?.data['status_code'] != ApiStatusCode.tokenExpired) {
        await _logApiRequest(data: _createLogData(), currentPath: path);
      }

      return result?.data as Map<String, dynamic>?;
    } catch (error) {
      await _logApiRequest(data: _createLogData(), currentPath: path);

      if (kDebugMode) {
        logger.e('Error: $error');
      }
      return null;
    } finally {
      loggerNoStack.i('Header: ${_safeJsonEncode(options.headers)}');
    }
  }

  void _safeLog(Function() logFunction) {
    try {
      logFunction();
    } catch (e) {
      logger.e('Error during logging: $e');
    }
  }

  String _safeJsonEncode(dynamic object) {
    try {
      return jsonEncode(object);
    } catch (e) {
      return 'Error encoding JSON: $e';
    }
  }

  Future<Map<String, dynamic>?> request(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return _makeRequest(
      method,
      path,
      queryParameters: queryParameters,
      data: data,
      headers: headers,
      extra: extra,
    );
  }

  Future<Map<String, dynamic>?> requestFormData(
    String method,
    String path, {
    Map<String, dynamic>? queryParameters,
    FormData? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) {
    return _makeRequest(
      method,
      path,
      queryParameters: queryParameters,
      data: data,
      headers: getCommonHeaders(accept: '*/*', contentType: 'multipart/form-data'),
      extra: extra,
      isFormData: true,
    );
  }

  void _handleResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('_result of ${response.requestOptions.path}: $response');
    }
    if (response.data[ApiConstant.statusCode] == ApiStatusCode.refreshToken) {
      _handleRefreshToken(response, handler);
    } else {
      handler.resolve(response);
    }
  }

  void _handleRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isRefreshingToken) {
      _listPendingRequest.add(PendingRequestInfo(options: options, requestHandler: handler));
    } else {
      handler.next(options);
    }
  }

  Future<void> _handleRefreshToken(Response response, ResponseInterceptorHandler handler) async {
    if (_isRefreshingToken) {
      _listPendingRequest.add(PendingRequestInfo(options: response.requestOptions, responseHandler: handler));
    } else {
      _isRefreshingToken = true;
      try {
        final value = await postRefreshToken(_accessToken);
        if (kDebugMode) {
          print('value: $value');
        }
        _isRefreshingToken = false;
        if (value?.statusCode != 200) {
          await returnExpireToken(response, handler);
        } else {
          RefreshTokenOutput refreshTokenOutput = RefreshTokenOutput.fromJson(value!.data);
          await _updateNewToken(refreshTokenOutput.data?.token ?? '');
          _recallApi(response.requestOptions, handler);
          _executePendingRequest();
        }
      } catch (error) {
        if (kDebugMode) {
          print('error: $error');
        }
        _isRefreshingToken = false;
        await returnExpireToken(response, handler);
      }
    }
  }

  Future<Response?> postRefreshToken(String exToken) async {
    if (kDebugMode) {
      print('refresh_token: $_refreshTokenPath');
    }

    final String keyPrivate =
        _localeManager?.loadSavedObject(StorageKeys.apiKeyPrivate, DataKeyPrivate.fromJson)?.apiKeyPrivate ?? '';
    String deviceId = await ToolHelper.getDeviceId();
    return _refreshTokenDio?.post(
      _refreshTokenPath,
      options: Options(
        headers: {
          'accept': '*/*',
          'Content-Type': 'application/json',
          'keyPrivate': keyPrivate,
        },
      ),
      data: {'token': exToken, "device_id": deviceId},
    );
  }

  Future<void> _updateNewToken(String newToken) async {
    _accessToken = newToken;
    await _localeManager?.setStringValue(StorageKeys.accessToken, newToken);
  }

  void updateHeader() {
    _accessToken = _localeManager?.getString(StorageKeys.accessToken) ?? '';
    _dio?.options.headers = getCommonHeaders();
  }

  void _recallApi(RequestOptions options, ResponseInterceptorHandler? handler) {
    if (kDebugMode) {
      print('recalling ${options.path}');
    }

    options.headers[ApiConstant.authorization] = 'Bearer $_accessToken';

    if (options.data is FormData) {
      options.data = _cloneFormData(options.data);
    }

    _dio?.fetch(options).then(
      (r) {
        if (kDebugMode) {
          print('recall success $r');
        }
        handler?.resolve(r);
      },
      onError: (e) {
        handler?.reject(e as DioException);
      },
    );
  }

  Future<void> returnExpireToken(Response response, ResponseInterceptorHandler? handler) async {
    response.data = {ApiConstant.statusCode: ApiStatusCode.tokenExpired, ApiConstant.message: response.data[ApiConstant.message]};
    handler?.resolve(response);
    for (final item in _listPendingRequest) {
      item.options.cancelToken?.cancel();
    }
    await _localeManager?.clearDataLocalLogout();
    // myRouter.go(WelcomeScreen.route);
    myRouter.go(LoginScreen.route);
    LocalStream.shared.setLoggedIn(false);
  }

  void _executePendingRequest() {
    if (kDebugMode) {
      print('execute pending request');
    }
    for (final item in _listPendingRequest) {
      if (kDebugMode) {
        print('execute ${item.options.path}');
      }
      if (item.requestHandler != null) {
        item.options.headers[ApiConstant.authorization] = 'Bearer $_accessToken';

        if (item.options.data is FormData) {
          item.options.data = _cloneFormData(item.options.data);
        }

        item.requestHandler?.next(item.options);
      } else {
        _recallApi(item.options, item.responseHandler);
      }
    }
    _listPendingRequest.clear();
  }

  FormData _cloneFormData(FormData data) {
    final newFormData = FormData();
    newFormData.fields.addAll(data.fields);
    for (final mapFile in data.files) {
      if (mapFile.value is MultipartFileExtended) {
        final value = mapFile.value as MultipartFileExtended;
        newFormData.files.add(MapEntry(
          mapFile.key,
          MultipartFileExtended.fromFileSync(
            value.filePath ?? '',
            filename: value.filename,
            contentType: value.contentType,
          ),
        ));
      }
    }
    return newFormData;
  }
}

class ConnectivityService {
  final _connectivity = Connectivity();
  final _controller = StreamController<bool>.broadcast();

  Stream<bool> get connectivityStream => _controller.stream;

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((result) {
      _controller.add(_isConnected(result.first));
    });
  }

  Future<bool> checkInitialConnection() async {
    final result = await _connectivity.checkConnectivity();

    return _isConnected(result.first);

  }

  bool _isConnected(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }

  void dispose() {
    _controller.close();
  }
}
