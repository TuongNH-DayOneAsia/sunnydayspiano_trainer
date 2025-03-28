import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Đã quá số lần gửi OTP của ngày hôm nay"
/// data : false
/// errors : ["",""]

class OtpVerifyOutput {
  OtpVerifyOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  OtpVerifyOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] is bool) {
      data = json['data'];
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
OtpVerifyOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  bool? data,
  List<String>? errors,
}) => OtpVerifyOutput(  statusCode: statusCode ?? this.statusCode,
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