
import 'package:myutils/data/network/model/output/list_class_output.dart';



class ClassDetailOutput {
  ClassDetailOutput({
    this.statusCode,
    this.status,
    this.message,
    this.errors,
    this.dataClass
  });

  ClassDetailOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    dataClass = json['data'] != null ? DataClass.fromJson(json['data']) : DataClass();
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];

  }
  num? statusCode;
  String? status;
  String? message;
  DataClass? dataClass;
  List<String>? errors;




  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    map['data'] = dataClass?.toJson();
    map['errors'] = errors;

    return map;
  }
}








