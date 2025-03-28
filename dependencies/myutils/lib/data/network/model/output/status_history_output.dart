import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get status history successfully!"
/// data : [{"status":null,"name":"Tất cả đặt lịch"},{"status":1,"name":"Đã đặt"},{"status":0,"name":"Đã huỷ"}]
/// errors : []

StatusHistoryOutput statusHistoryOutputFromJson(String str) => StatusHistoryOutput.fromJson(json.decode(str));
String statusHistoryOutputToJson(StatusHistoryOutput data) => json.encode(data.toJson());
class StatusHistoryOutput {
  StatusHistoryOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  StatusHistoryOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataHistoryStatus.fromJson(v));
      });
    }

  }
  num? statusCode;
  String? status;
  String? message;
  List<DataHistoryStatus>? data;
  List<dynamic>? errors;
StatusHistoryOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  List<DataHistoryStatus>? data,
  List<dynamic>? errors,
}) => StatusHistoryOutput(  statusCode: statusCode ?? this.statusCode,
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
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// status : null
/// name : "Tất cả đặt lịch"


class DataHistoryStatus {
  DataHistoryStatus({
      this.status, 
      this.name,});

  DataHistoryStatus.fromJson(dynamic json) {
    status = json['status'] ?? -1;
    name = json['name'] ?? '';
  }
  int? status;
  String? name;
  DataHistoryStatus copyWith({  dynamic status,
  String? name,
}) => DataHistoryStatus(  status: status ?? this.status,
  name: name ?? this.name,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['name'] = name;
    return map;
  }

}