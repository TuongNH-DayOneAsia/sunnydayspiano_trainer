import 'dart:async';
import 'dart:convert';

import 'package:myutils/constants/locale_keys_enum.dart';
import 'package:myutils/data/network/dayone_json_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LocaleManager {
  static final LocaleManager _instance = LocaleManager._init();

  SharedPreferences? _preferences;

  static LocaleManager get instance => _instance;

  LocaleManager._init() {
    SharedPreferences.getInstance().then((value) {
      _preferences = value;
    });
  }

  static Future init() async {
    instance._preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> clearAll() async {
    await _preferences!.clear();
  }

  Future<void> clearKey(StorageKeys key) async {
    await _preferences!.remove(key.toString());
  }
  T? loadSavedObject<T>(StorageKeys key, T Function(Map<String, dynamic> map) fromJson) {
    final String? jsonString = _preferences?.getString(key.toString());
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString);
        if (decoded is Map<String, dynamic>) {
          T? model = JsonParser.jsonToModel(fromJson, decoded);
          return model;
        } else {
          print('Stored data is not a valid JSON object');
          _preferences?.remove(key.toString()); // Remove invalid data
          return null;
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        _preferences?.remove(key.toString()); // Remove invalid data
        return null;
      }
    }
    return null;
  }

  Future<void> setObject(StorageKeys key,Map<String, dynamic> mapObject) async {
    await _preferences?.setString(key.toString(), json.encode(mapObject));
  }
  Future<void> clearDataLocalLogout() async {
    await _preferences!.remove(StorageKeys.accessToken.toString());
    await _preferences!.remove(StorageKeys.userInfoLogin.toString());
  }

  Future<bool> setStringValue(StorageKeys key, String? value) async {
    return _preferences!.setString(key.toString(), value ?? '');
  }

  Future<bool> setStringListValue(StorageKeys key, List<String>? value) async {
    return _preferences!.setStringList(key.toString(), value ?? []);
  }

  // ignore: avoid_positional_boolean_parameters
  Future<bool> setBoolValue(StorageKeys key, bool? value) async {
    return _preferences!.setBool(key.toString(), value ?? false);
  }

  String? getString(StorageKeys key) => _preferences?.getString(key.toString());

  List<String>? getStringList(StorageKeys key) => _preferences?.getStringList(key.toString());

  bool? getBool(StorageKeys key) => _preferences!.getBool(key.toString());

  //Cache config data for user




}
