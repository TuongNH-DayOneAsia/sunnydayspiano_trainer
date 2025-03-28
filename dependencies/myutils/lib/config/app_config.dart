import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:myutils/helpers/extension/string_extension.dart';

import '../helpers/extension/image_extension.dart';

class AppConfig {
  //Config in local
  String? baseUrl;
  String? urlImage;
  String? primaryColor;
  Flavor? flavor;
  String? apiVersion;
  String appName = 'Day one';
  bool debugTag = true;
  int cacheDuration = 100;
  String initialRoute = '';
  String? domainChat = '';
  String? appVersion = '';
  String? firebaseConfigVersion = '';

  String? sentryDNS = '';

  String? keyRandom = '';
  String? appSunnyDay = '';
  String? apiUserPassword = '';
  String? apiUserId = '';
  String? keyLogin = '';

  AppConfig._init(this.flavor);

  static Future<AppConfig> create(Flavor flavor) async {
    final appConfig = AppConfig._init(flavor);
    return appConfig._loadConfig();
  }

  bool isProduction() => flavor == Flavor.prod;

  Future<AppConfig> _loadConfig() async {
    try {
      const basePath = 'packages/common_resource/assets/env/env.';

      var envFile = basePath + (flavor?.name ?? 'prod');
      await dotenv.load(fileName: envFile);
      debugTag = flavor == Flavor.staging;
      baseUrl = dotenv.env[ConfigConstants.domainHost] ?? '';
      apiVersion = dotenv.env[ConfigConstants.apiVersion] ?? '';
      appVersion = dotenv.env[ConfigConstants.appVersion] ?? '';
      firebaseConfigVersion = dotenv.env[ConfigConstants.firebaseConfigVersion] ?? '';
      sentryDNS = dotenv.env[ConfigConstants.sentryDNS] ?? '';

      keyRandom = dotenv.env[ConfigConstants.keyRandom] ?? '';
      appSunnyDay = dotenv.env[ConfigConstants.appSunnyDay] ?? '';
      apiUserPassword = dotenv.env[ConfigConstants.apiUserPassword] ?? '';
      apiUserId = dotenv.env[ConfigConstants.apiUserId] ?? '';
      keyLogin = dotenv.env[ConfigConstants.keyLogin] ?? '';

      cacheDuration = 100;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    return this;
  }
}

class ConfigConstants {
  static const themeColor = 'THEME_COLOR';
  static const domainProduction = 'DOMAIN_PRODUCTION';
  static const domainHost = 'DOMAIN_HOST';
  static const domainStagingImage = 'DOMAIN_IMAGE';
  static const apiVersion = 'API_VERSION';
  static const cacheDuration = 'CACHE_DURATION';
  static const appVersion = 'APP_VERSION';
  static const sentryDNS = 'SENTRY_DNS';
  static const firebaseConfigVersion = 'FIREBASE_CONFIG_VERSION';
  static const API_URL = 'API_URL';
  static const keyRandom = "KEY_RANDOM";
  static const appSunnyDay = "APP_SUNNYDAY";
  static const apiUserPassword = "API_USERPASSWORD";
  static const apiUserId = "API_USERID";
  static const keyLogin = "KEY_LOGIN";
}

enum Flavor { staging, prod, dev, local, demo, test }
