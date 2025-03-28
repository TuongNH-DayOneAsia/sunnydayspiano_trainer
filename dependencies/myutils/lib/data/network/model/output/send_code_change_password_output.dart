import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Send code successfully!"
/// data : {"new_code_verify":"875663","new_code_expired":"2024-09-05T11:24:42.731Z"}
/// errors : ["",""]

SendCodeChangePasswordOutput sendCodeChangePasswordFromJson(String str) => SendCodeChangePasswordOutput.fromJson(json.decode(str));
String sendCodeChangePasswordToJson(SendCodeChangePasswordOutput data) => json.encode(data.toJson());
class SendCodeChangePasswordOutput {
  SendCodeChangePasswordOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  SendCodeChangePasswordOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? statusCode;
  String? status;
  String? message;
  Data? data;
  List<String>? errors;
SendCodeChangePasswordOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  Data? data,
  List<String>? errors,
}) => SendCodeChangePasswordOutput(  statusCode: statusCode ?? this.statusCode,
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
    if (data != null) {
      map['data'] = data?.toJson();
    }
    map['errors'] = errors;
    return map;
  }

}

/// new_code_verify : "875663"
/// new_code_expired : "2024-09-05T11:24:42.731Z"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.newCodeVerify, 
      this.newCodeExpired,});

  Data.fromJson(dynamic json) {
    newCodeVerify = json['new_code_verify'];
    newCodeExpired = json['new_code_expired'];
  }
  String? newCodeVerify;
  String? newCodeExpired;
Data copyWith({  String? newCodeVerify,
  String? newCodeExpired,
}) => Data(  newCodeVerify: newCodeVerify ?? this.newCodeVerify,
  newCodeExpired: newCodeExpired ?? this.newCodeExpired,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['new_code_verify'] = newCodeVerify;
    map['new_code_expired'] = newCodeExpired;
    return map;
  }

}