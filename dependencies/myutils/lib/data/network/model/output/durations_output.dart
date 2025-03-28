import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get durations successfully!"
/// data : [30,60,90]
/// errors : ["",""]

DurationsOutput durationsOutputFromJson(String str) => DurationsOutput.fromJson(json.decode(str));
String durationsOutputToJson(DurationsOutput data) => json.encode(data.toJson());
class DurationsOutput {
  DurationsOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  DurationsOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? json['data'].cast<num>() : [];
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }
  num? statusCode;
  String? status;
  String? message;
  List<num>? data;
  List<String>? errors;
DurationsOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<num>? data,
  List<String>? errors,
}) => DurationsOutput(  statusCode: statusCode ?? this.statusCode,
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