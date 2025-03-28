/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

// RefreshTokenOutput refreshTokenOutputFromJson(String str) => RefreshTokenOutput.fromJson(json.decode(str));
//
// String refreshTokenOutputToJson(RefreshTokenOutput data) => json.encode(data.toJson());

class RefreshTokenOutput {
    RefreshTokenOutput({
         this.statusCode,
         this.data,
         this.message,
         this.errors,
         this.status,
    });

    int? statusCode;
    Data? data;
    String? message;
    List<dynamic>? errors;
    String? status;

    RefreshTokenOutput.fromJson(dynamic json) {
        statusCode = json['status_code'];
        message = json['message'];
        status = json['status'];
        if (json['data'] != null) {
            data = Data.fromJson(json['data']);
        }else{
            data = null;
        }
        if (json['errors'] != null) {
            errors = [];
            json['errors'].forEach((v) {
                errors?.add(v.toString());
            });
        }
    }
    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data?.toJson(),
        "message": message,
        "errors":
        errors != null ? List<String>.from(errors!.map((x) => x)) : null,
        "status": status,
    };
}

class Data {
    Data({
         this.token,
    });

    String? token;

    Data.fromJson(dynamic json) {
        token=json["token"] ?? '';

    }
    Map<String, dynamic> toJson() => {
        "token": token,
    };
}
