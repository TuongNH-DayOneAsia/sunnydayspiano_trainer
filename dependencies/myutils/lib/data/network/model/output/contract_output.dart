import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Get contracts successfully!"
/// data : [{"file":"https://staging-booking.sunnydays.vn/storage/students/student-8/contracts-8/file-20240917_133350-8.pdf"}]
/// errors : ["",""]

ContractOutput contractOutputFromJson(String str) => ContractOutput.fromJson(json.decode(str));

String contractOutputToJson(ContractOutput data) => json.encode(data.toJson());

class ContractOutput {
  ContractOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  ContractOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataPdf.fromJson(v));
      });
    }
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  List<DataPdf>? data;
  List<String>? errors;

  ContractOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    List<DataPdf>? data,
    List<String>? errors,
  }) =>
      ContractOutput(
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
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    map['errors'] = errors;
    return map;
  }
}

/// file : "https://staging-booking.sunnydays.vn/storage/students/student-8/contracts-8/file-20240917_133350-8.pdf"



class DataPdf {
  DataPdf({
    this.file,
    this.name,
  });

  DataPdf.fromJson(dynamic json) {
    file = json['file'] ?? '';
    name = json['name'] ?? '';
  }

  String? file;
  String? name;

  DataPdf copyWith({
    String? file,
    String? name,
  }) =>
      DataPdf(
        file: file ?? this.file,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['file'] = file;
    map['name'] = name;
    return map;
  }
}
