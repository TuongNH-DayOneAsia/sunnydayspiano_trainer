
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/data/network/model/base_input.dart';
import 'package:translator/translator.dart';

import 'network_manager.dart';


abstract class BaseRepository {
  final String _serviceName;
  NetworkManager? _networkManager;

  BaseRepository(this._serviceName) {
    _networkManager = injector();
  }

  Future<Map<String, dynamic>?> request<DataType, QueryType>(
      {required String method,
      required String path,
      QueryType? queryParameters,
      DataType? data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? extra,
      bool isNotLoadCacheFail = true}) async {

    final result = await _networkManager?.request(
        method.toUpperCase(), path,
        queryParameters: (queryParameters is BaseInput)
            ? queryParameters.toJson()
            : (queryParameters as Map<String, dynamic>?),
        data: (data is BaseInput)
            ? data.toJson()
            : (data as Map<String, dynamic>?),
        // isLoadFromCache: isNotLoadCacheFail,
        headers: headers  ,
        extra: extra);
    return result;
  }


  Future<Map<String, dynamic>?>? requestFormData({
    required String method,
    required String path,
    BaseInput? queryParameters,
    FormData? data,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
  }) async {
    final result = await _networkManager?.requestFormData(
        method.toUpperCase(), path,
        queryParameters: queryParameters?.toJson(),
        data: data,
        headers: headers,
        extra: extra);

    if (kDebugMode) {
      print('requestFormData result: ${result.toString()}');
      // logger.d(result);
    }
    return result;
  }
}
