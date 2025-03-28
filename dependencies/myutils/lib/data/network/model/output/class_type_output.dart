import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get list class type successfully!"
/// data : [{"key":"CLASS"},{"key":"ONE_PRIVATE"},{"key":"ONE_GERENAL"},{"key":"CLASS_PRACTICE"}]
/// errors : []

ClassTypeOutput classTypeOutputFromJson(String str) => ClassTypeOutput.fromJson(json.decode(str));
String classTypeOutputToJson(ClassTypeOutput data) => json.encode(data.toJson());
class ClassTypeOutput {
  ClassTypeOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
    });

  ClassTypeOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(Data.fromJson(v));
      });
    }

  }
  num? statusCode;
  String? status;
  String? message;
  List<Data>? data;
ClassTypeOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<Data>? data,
  List<dynamic>? errors,
}) => ClassTypeOutput(  statusCode: statusCode ?? this.statusCode,
  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }

    return map;
  }

}

/// key : "CLASS"

Data dataFromJson(String str) => Data.fromJson(json.decode(str));
String dataToJson(Data data) => json.encode(data.toJson());
class Data {
  Data({
      this.key,});

  Data.fromJson(dynamic json) {
    key = json['key'];
  }
  String? key;
Data copyWith({  String? key,
}) => Data(  key: key ?? this.key,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    return map;
  }

}