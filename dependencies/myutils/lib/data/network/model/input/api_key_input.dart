/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

import 'package:myutils/data/network/model/base_input.dart';

// ApiKeyInput apiKeyInputFromJson(String str) => ApiKeyInput.fromJson(json.decode(str));
//
// String apiKeyInputToJson(ApiKeyInput data) => json.encode(data.toJson());

class ApiKeyInput extends BaseInput {
    ApiKeyInput({
        required this.keyRandom,
        required this.appSunnyDay,
        required this.apiUserPassword,
        required this.apiUserId,
    });

    String keyRandom;
    String appSunnyDay;
    String apiUserPassword;
    String apiUserId;

    factory ApiKeyInput.fromJson(Map<dynamic, dynamic> json) => ApiKeyInput(
        keyRandom: json["key_random"],
        appSunnyDay: json["app_sunny_day"],
        apiUserPassword: json["api_user_password"],
        apiUserId: json["api_user_id"],
    );

    Map<String, dynamic> toJson() => {
        "key_random": keyRandom,
        "app_sunny_day": appSunnyDay,
        "api_user_password": apiUserPassword,
        "api_user_id": apiUserId,
    };
}
