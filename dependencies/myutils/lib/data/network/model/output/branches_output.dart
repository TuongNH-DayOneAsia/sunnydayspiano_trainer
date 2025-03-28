/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

import 'package:myutils/data/network/model/output/list_class_output.dart';



class BranchesOutput  {

    num? statusCode;
    String? status;
    String? message;
    List<String>? errors;
    List<DataInfoNameBooking>? data;

    BranchesOutput({
        this.statusCode,
        this.status,
        this.message,
        this.data,
        this.errors,
    });

    BranchesOutput.fromJson(dynamic json) {
        statusCode = json['status_code'] ?? -1;
        message = json['message'] ?? '';
        if (json['status_code'] == 200) {
            data = [];
            json['data'].forEach((v) {
                data?.add(DataInfoNameBooking.fromJson(v));
            });
        }else{
            data = [];
        }
        status = json['status'] ?? '';

    }
}


abstract class ApiResponse {
    String? message;
    List<String>? errors;
    String? status;
    int? statusCode;

    ApiResponse({
        this.message,
        this.errors,
        this.status,
        this.statusCode,
    });

    ApiResponse.fromJson(dynamic json) {
        statusCode = json['status_code'] ?? -1;
        message = json['message'] ?? '';
        status = json['status'] ?? '';
        if (json['errors'] != null) {
            errors = List<String>.from(json['errors'].map((x) => x.toString()));
        }
    }

    Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "message": message,
        "status": status,
        "errors": errors?.isNotEmpty == true ? List<String>.from(errors!) : [],
    };
}



