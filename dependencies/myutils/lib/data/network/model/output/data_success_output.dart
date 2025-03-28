import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Send code successfully!"
/// data : true
/// errors : ["",""]

DataSuccessOutput dataSuccessOutputFromJson(String str) => DataSuccessOutput.fromJson(json.decode(str));

String dataSuccessOutputToJson(DataSuccessOutput data) => json.encode(data.toJson());

class DataSuccessOutput {
  DataSuccessOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  DataSuccessOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] is bool) {
      data = json['data'];
    } else if (json['data'] is List && (json['data'] as List).isEmpty) {
      data = false;
    } else {
      data = false;
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  bool? data;
  List<String>? errors;

  DataSuccessOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    bool? data,
    List<String>? errors,
  }) =>
      DataSuccessOutput(
        statusCode: statusCode ?? this.statusCode,
        status: status ?? this.status,
        message: message ?? this.message,
        data: data ?? this.data,
        errors: errors ?? this.errors,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    map['data'] = data;
    map['errors'] = errors;
    return map;
  }
}
