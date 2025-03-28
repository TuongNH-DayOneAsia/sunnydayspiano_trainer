import 'dart:convert';

import 'package:myutils/constants/api_constant.dart';

/// slug : "1213"
/// token : "tokeninhere"

class LoginOutput {
  LoginOutput({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.errors,
    required this.status,
  });

  int? statusCode;
  DataLogin? data;
  String? message;
  List<dynamic>? errors;
  String? status;

  LoginOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    message = json['message'];
    status = json['status'];
    if (json['status_code'] == ApiStatusCode.success) {
      data = DataLogin.fromJson(json['data']);
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
        "errors": errors != null ? List<String>.from(errors!.map((x) => x)) : null,
        "status": status,
      };
}

class DataLogin {
  DataLogin({
    this.slug,
    this.token,
  });

  DataLogin.fromJson(dynamic json) {
    slug = json['slug'] ?? '';
    token = json['token'] ?? '';
  }

  String? slug;
  String? token;

  DataLogin copyWith({
    String? slug,
    String? token,
  }) =>
      DataLogin(
        slug: slug ?? this.slug,
        token: token ?? this.token,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['slug'] = slug;
    map['token'] = token;
    return map;
  }
}
