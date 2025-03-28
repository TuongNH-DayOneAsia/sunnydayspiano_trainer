import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:myutils/config/app_config.dart';
import 'package:myutils/config/injection.dart';
import 'package:myutils/constants/remote_config_constants.dart';
import 'package:myutils/data/network/model/output/firebase_config_model.dart';

class RemoteConfigManager {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  RemoteConfigManager.init() {
    _initConfig();
  }

  Future<void> _initConfig() async {
    await _remoteConfig.setDefaults(const {
      RemoteConfigConstants.inReleaseProgress: false,
      RemoteConfigConstants.inDev: false,
      RemoteConfigConstants.flexibleUpdate: false,
      RemoteConfigConstants.immediateUpdate: false,
      RemoteConfigConstants.allowSurvey: true,
    });
    await _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(
          seconds: 10), // a fetch will wait up to 10 seconds before timing out
      minimumFetchInterval: const Duration(
          seconds:
              10), // fetch parameters will be cached for a maximum of 1 hour
    ));

    _fetchConfig();
  }

  // Fetching, caching, and activating remote config
  Future<void> _fetchConfig() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.none) {
      await _remoteConfig.fetchAndActivate();
    }
  }

  Future<void> fetchAndActivate() async {
    await _remoteConfig.fetchAndActivate();
  }

  bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }

  /// Gets the value for a given key as an int.
  int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  /// Gets the value for a given key as a double.
  double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  /// Gets the value for a given key as a String.
  String getString(String key) {
    return _remoteConfig.getString(key);
  }

  FirebaseConfigData getFirebaseConfigData() {
    final firebaseConfigVersion =
        injector<AppConfig>().firebaseConfigVersion ?? '';
    final jsonConfig = getString(
        RemoteConfigConstants.firebaseConfigVersion + firebaseConfigVersion);
    try {
      final firebaseConfig = FirebaseConfigData.fromJson(
          json.decode(jsonConfig) as Map<String, dynamic>);
      return firebaseConfig;
    } catch (e) {
      return FirebaseConfigData.defaultConfig();
    }
  }

  Future<void> refreshFirebaseConfig() async {
    try {
      await _remoteConfig.activate();
      await _remoteConfig.fetch();
      await _remoteConfig.fetchAndActivate();
    } catch (e) {
      // Handle error
    }
  }
}
