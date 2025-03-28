import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Save code OTP successfully!"
/// data : {"code":"123123"}
/// errors : ["",""]

AppleSendOtpOutput appleSendOtpOutputFromJson(String str) => AppleSendOtpOutput.fromJson(json.decode(str));
String appleSendOtpOutputToJson(AppleSendOtpOutput data) => json.encode(data.toJson());
class AppleSendOtpOutput {
  AppleSendOtpOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  AppleSendOtpOutput.fromJson(dynamic json) {
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
AppleSendOtpOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  Data? data,
  List<String>? errors,
}) => AppleSendOtpOutput(  statusCode: statusCode ?? this.statusCode,
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

/// code : "123123"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.code,});

  Data.fromJson(dynamic json) {
    code = json['code'];
  }
  String? code;
Data copyWith({  String? code,
}) => Data(  code: code ?? this.code,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    return map;
  }

}