import 'package:flutter/material.dart';

/// status_code : 200
/// status : "success"
/// message : "Get contracts successfully!"
/// data : [{"key":"ONE_GENERAL","name":"Lớp 1-1 không gian chung","items":[{"product_name":"Mastery Plus","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":0,"total":13,"is_booking":false,"total_day_remain":2,"status_contract":4,"messages":"","status_name":"Còn 2 ngày hết hạn "},{"product_name":"Tặng thêm buổi trải nghiệm HLV","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":2,"total":2,"is_booking":false,"total_day_remain":2,"status_contract":4,"messages":"","status_name":"Còn 2 ngày hết hạn "}]},{"key":"ONE_PRIVATE","name":"Lớp 1-1 không gian riêng","items":[{"product_name":"1-1 riêng 56-80 buổi","slug_contract":"2699-50980e7a-c6e2-43b7-9c1d-a38c03559e08","total_learned":3,"total":60,"is_booking":true,"total_day_remain":97,"status_contract":2,"messages":"","status_name":"Còn hạn"},{"product_name":"1-1 riêng 56-80 buổi","slug_contract":"","total_learned":0,"total":90,"is_booking":true,"total_day_remain":474,"status_contract":2,"messages":"","status_name":"Còn hạn"}]}]
/// errors : []

class ContractsOutput {
  ContractsOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  ContractsOutput.fromJson(dynamic json) {
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
  int? statusCode;
  String? status;
  String? message;
  List<Data>? data;
  List<dynamic>? errors;
  ContractsOutput copyWith({
    int? statusCode,
    String? status,
    String? message,
    List<Data>? data,
    List<dynamic>? errors,
  }) =>
      ContractsOutput(
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
    if (errors != null) {
      map['errors'] = errors?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// key : "ONE_GENERAL"
/// name : "Lớp 1-1 không gian chung"
/// items : [{"product_name":"Mastery Plus","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":0,"total":13,"is_booking":false,"total_day_remain":2,"status_contract":4,"messages":"","status_name":"Còn 2 ngày hết hạn "},{"product_name":"Tặng thêm buổi trải nghiệm HLV","slug_contract":"2699-2050eec0-4f22-4977-bd39-25f7f7006905","total_learned":2,"total":2,"is_booking":false,"total_day_remain":2,"status_contract":4,"messages":"","status_name":"Còn 2 ngày hết hạn "}]

class Data {
  Data({
    this.key,
    this.name,
    this.items,
  });

  Data.fromJson(dynamic json) {
    key = json['key'];
    name = json['name'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items?.add(DataContract.fromJson(v));
      });
    }
  }

  String iconPath(){
    if(key == 'ONE_GENERAL'){
      return 'dashboard/hlv_general.svg';

    }else{
      return 'dashboard/hlv_private.svg';

    }
  }

  String? key;
  String? name;
  List<DataContract>? items;
  Data copyWith({
    String? key,
    String? name,
    List<DataContract>? items,
  }) =>
      Data(
        key: key ?? this.key,
        name: name ?? this.name,
        items: items ?? this.items,
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['key'] = key;
    map['name'] = name;
    if (items != null) {
      map['items'] = items?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// product_name : "Mastery Plus"
/// slug_contract : "2699-2050eec0-4f22-4977-bd39-25f7f7006905"
/// total_learned : 0
/// total : 13
/// is_booking : false
/// total_day_remain : 2
/// status_contract : 4
/// messages : ""
/// status_name : "Còn 2 ngày hết hạn "

class DataContract {
  DataContract({
    this.productName,
    this.slugContract,
    this.totalLearned,
    this.total,
    this.isBooking,
    this.totalDayRemain,
    this.statusContract,
    this.messages,
    this.statusName,
    this.key
  });

  DataContract.fromJson(dynamic json) {
    productName = json['product_name'];
    slugContract = json['slug_contract'];
    totalLearned = json['total_learned'];
    total = json['total'];
    isBooking = json['is_booking'];
    totalDayRemain = json['total_day_remain'];
    statusContract = json['status_contract'];
    messages = json['messages'];
    statusName = json['status_name'];
    key = json['key'];
  }
  String? productName;
  String? slugContract;
  int? totalLearned;
  int? total;
  bool? isBooking;
  int? totalDayRemain;
  int? statusContract;
  String? messages;
  String? statusName;
  String? key;



  Color colorStatus() {
    //EXPIRED = 1, -> Hết hạn
    //   IN_PROGRESS = 2, -> Còn hạn
    //   NOT_STARTED = 3, -> Chưa kích hoạt
    //   NEAR_EXPIRATION = 4 -> Gần hết hạn
    switch (statusContract) {
      case 1:
        return const Color(0xFFFF4545);
      case 2:
        return const Color(0xFF07B25C);
      case 3:
        return const Color(0xFF6A6A6A);
      case 4:
        return const Color(0xFFFFA44B);
      default:
        return  const Color(0xFF07B25C);
    }

  }

  DataContract copyWith({
    String? productName,
    String? slugContract,
    int? totalLearned,
    int? total,
    bool? isBooking,
    int? totalDayRemain,
    int? statusContract,
    String? messages,
    String? statusName,
    String? key
  }) =>
      DataContract(
        productName: productName ?? this.productName,
        slugContract: slugContract ?? this.slugContract,
        totalLearned: totalLearned ?? this.totalLearned,
        total: total ?? this.total,
        isBooking: isBooking ?? this.isBooking,
        totalDayRemain: totalDayRemain ?? this.totalDayRemain,
        statusContract: statusContract ?? this.statusContract,
        messages: messages ?? this.messages,
        statusName: statusName ?? this.statusName,
        key: key ?? this.key
      );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['product_name'] = productName;
    map['slug_contract'] = slugContract;
    map['total_learned'] = totalLearned;
    map['total'] = total;
    map['is_booking'] = isBooking;
    map['total_day_remain'] = totalDayRemain;
    map['status_contract'] = statusContract;
    map['messages'] = messages;
    map['status_name'] = statusName;
    map['key'] = key;
    return map;
  }
}
