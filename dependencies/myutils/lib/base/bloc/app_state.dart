import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:myutils/data/network/model/output/api_key_output.dart';

class AppState extends Equatable {
  final ConnectivityResult? connectivityResult;
  final InternetConnectionStatus? internetConnectionStatus;
  final DataKeyPrivate? dataKeyPrivate;

  const AppState({
    this.dataKeyPrivate,
    this.connectivityResult,
    this.internetConnectionStatus,
  });

  @override
  List<Object?> get props =>
      [connectivityResult, internetConnectionStatus, dataKeyPrivate];

  //copyWith
  AppState copyWith(
      {ConnectivityResult? connectivityResult,
        InternetConnectionStatus? internetConnectionStatus,
        DataKeyPrivate? dataKeyPrivate}) {
    return AppState(
        connectivityResult: connectivityResult ?? this.connectivityResult,
        internetConnectionStatus:
        internetConnectionStatus ?? this.internetConnectionStatus,
        dataKeyPrivate: dataKeyPrivate ?? this.dataKeyPrivate);
  }

  @override
  bool get stringify => true;
}

abstract class CachedWidgetState {
  CachedWidgetState.empty();

  CachedWidgetState? fromJson(Map<String, dynamic> json);

  Map<String, dynamic> toJson();
}
