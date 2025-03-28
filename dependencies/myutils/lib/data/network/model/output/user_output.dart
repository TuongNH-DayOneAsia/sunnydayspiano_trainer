
import 'dart:ui';

import 'package:flutter/material.dart';

enum StatusAccount {
  NOT_ACTIVE, //0
  LEARNING, //2
  EXPIRED, //3
  RESERVED, //4
}
class UserOutput {
  UserOutput({
    required this.statusCode,
    required this.data,
    required this.message,
    required this.errors,
    required this.status,
  });

  int? statusCode;
  DataUserInfo? data;
  String? message;
  List<dynamic>? errors;
  String? status;

  UserOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = DataUserInfo.fromJson(json['data']);
    }
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v.toString());
      });
    }
  }

  Map<String, dynamic> toJson() => {
        "status_code": statusCode,
        "data": data?.toJson(),
        "message": message,
        "errors":
            errors != null ? List<String>.from(errors!.map((x) => x)) : null,
        "status": status,
      };

  UserOutput copyWith({
    int? statusCode,
    DataUserInfo? data,
    String? message,
    List<dynamic>? errors,
    String? status,
  }) {
    return UserOutput(
      statusCode: statusCode ?? this.statusCode,
      data: data ?? this.data,
      message: message ?? this.message,
      errors: errors ?? this.errors,
      status: status ?? this.status,
    );
  }
}

class DataUserInfo {
  DataUserInfo({
    this.name,
    this.slug,
    this.username,
    this.email,
    this.phone,
    this.avatar,
    this.qrcodePath,
    this.address,
    this.studentCode,
    this.birthday,
    this.cccd,
    this.cccdPlaceIssue,
    this.cccdDateIssue,
    this.gender,
    this.deviceLastLogin,
    this.newAccount,
    this.branches,
    this.limitOtp,
    this.limitForget,
    this.isBookClass,
    this.isBookPractice,
    this.textIsBookClassLimitMonth,
    this.textIsBookPracticeLimitMonth,
    this.dateContract,
    this.numberShowContractAvailable,
    this.branch,
    this.unreadNotificationCount,
    this.contractStartDate,
    this.contractEndDate,
    this.studentStatus,
    this.studentStatusName,
  });

  DataUserInfo.fromJson(dynamic json) {
    name = json['name'] ?? '';
    slug = json['slug'] ?? '';
    username = json['username'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
    avatar = json['avatar'] ?? '';
    qrcodePath = json['qrcode_path'] ?? '';
    address = json['address'] ?? '';
    studentCode = json['student_code'] ?? '';
    birthday = json['birthday'] ?? '';
    cccd = json['cccd'] ?? '';
    cccdPlaceIssue = json['cccd_place_issue'] ?? '';
    cccdDateIssue = json['cccd_date_issue'] ?? '';
    gender = json['gender'] ?? '';
    deviceLastLogin = json['device_last_login'] ?? '';
    newAccount = json['new_account'] ?? false;
    branches = json['branches'] != null ? json['branches'].cast<String>() : [];
    limitOtp = json['limit_otp'] ?? 0;
    limitForget = json['limit_forget'] ?? 0;
    isBookClass = json['is_book_class'] ?? true;
    isBookPractice = json['is_book_practice'] ?? true;
    textIsBookClassLimitMonth = json['text_is_book_class_limit_month'] ?? '';
    textIsBookPracticeLimitMonth =
        json['text_is_book_practice_limit_month'] ?? '';
    dateStart = json['date_start'] ?? '';
    dateEnd = json['date_end'] ?? '';
    dateContract = json['date_contract'] ?? '';
    numberShowContractAvailable = json['number_show_contract_available'] ?? 0;
    unreadNotificationCount = json['unread_notification_count'] ?? 0;
    branch = json['branch'] ?? '---';
    contractStartDate = json['contract_start_date'] ?? '';
    contractEndDate = json['contract_end_date'] ?? '';
    studentStatus = json['student_status'] ?? 0;
    studentStatusName = json['student_status_name'] ?? '';
  }

  String? name;
  String? slug;
  String? username;
  String? email;
  String? phone;
  String? avatar;
  String? qrcodePath;
  String? address;
  String? studentCode;
  String? birthday;
  String? cccd;
  String? cccdPlaceIssue;
  String? cccdDateIssue;
  String? gender;
  String? deviceLastLogin;
  bool? newAccount;
  String? branch;

  List<String>? branches;
  num? limitOtp;
  num? limitForget;
  bool? isBookClass;
  bool? isBookPractice;
  String? textIsBookClassLimitMonth;
  String? textIsBookPracticeLimitMonth;
  String? dateStart;
  String? dateEnd;
  String? dateContract;
  int? numberShowContractAvailable;
  int? unreadNotificationCount;

  int? studentStatus;
  String? studentStatusName;

  String? contractStartDate;
  String? contractEndDate;
  DataUserInfo copyWith(
          {String? name,
          String? slug,
          String? username,
          String? email,
          String? phone,
          String? avatar,
          String? qrcodePath,
          String? address,
          String? studentCode,
          String? birthday,
          String? cccd,
          String? cccdPlaceIssue,
          String? cccdDateIssue,
          String? gender,
          String? deviceLastLogin,
          bool? newAccount,
          List<String>? branches,
          num? limitOtp,
          num? limitForget,
          bool? isBookClass,
          bool? isBookPractice,
          String? textIsBookClassLimitMonth,
          String? textIsBookPracticeLimitMonth,
          String? branch,
          String? contractStartDate,
          String? contractEndDate,
          int? studentStatus,
          String? studentStatusName}) =>
      DataUserInfo(
        name: name ?? this.name,
        slug: slug ?? this.slug,
        username: username ?? this.username,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        avatar: avatar ?? this.avatar,
        qrcodePath: qrcodePath ?? this.qrcodePath,
        address: address ?? this.address,
        studentCode: studentCode ?? this.studentCode,
        birthday: birthday ?? this.birthday,
        cccd: cccd ?? this.cccd,
        cccdPlaceIssue: cccdPlaceIssue ?? this.cccdPlaceIssue,
        cccdDateIssue: cccdDateIssue ?? this.cccdDateIssue,
        gender: gender ?? this.gender,
        deviceLastLogin: deviceLastLogin ?? this.deviceLastLogin,
        newAccount: newAccount ?? this.newAccount,
        branches: branches ?? this.branches,
        limitOtp: limitOtp ?? this.limitOtp,
        limitForget: limitForget ?? this.limitForget,
        isBookClass: isBookClass ?? this.isBookClass,
        isBookPractice: isBookPractice ?? this.isBookPractice,
        textIsBookClassLimitMonth:
            textIsBookClassLimitMonth ?? this.textIsBookClassLimitMonth,
        textIsBookPracticeLimitMonth:
            textIsBookPracticeLimitMonth ?? this.textIsBookPracticeLimitMonth,
        branch: branch ?? this.branch,
        contractStartDate: contractStartDate ?? this.contractStartDate,
        contractEndDate: contractEndDate ?? this.contractEndDate,
        studentStatus: studentStatus ?? this.studentStatus,
        studentStatusName: studentStatusName ?? this.studentStatusName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['name'] = name;
    map['slug'] = slug;
    map['username'] = username;
    map['email'] = email;
    map['phone'] = phone;
    map['avatar'] = avatar;
    map['qrcode_path'] = qrcodePath;
    map['address'] = address;
    map['student_code'] = studentCode;
    map['birthday'] = birthday;
    map['cccd'] = cccd;
    map['cccd_place_issue'] = cccdPlaceIssue;
    map['cccd_date_issue'] = cccdDateIssue;
    map['gender'] = gender;
    map['device_last_login'] = deviceLastLogin;
    map['new_account'] = newAccount;
    map['branches'] = branches;
    map['limit_otp'] = limitOtp;
    map['limit_forget'] = limitForget;
    map['is_book_class_limit_month'] = isBookClass;
    map['is_book_practice_limit_month'] = isBookPractice;
    map['text_is_book_class_limit_month'] = textIsBookClassLimitMonth;
    map['text_is_book_practice_limit_month'] = textIsBookPracticeLimitMonth;
    map['branch'] = branch;
    map['contract_start_date'] = contractStartDate;
    map['contract_end_date'] = contractEndDate;
    map['student_status'] = studentStatus;
    map['student_status_name'] = studentStatusName;
    return map;
  }

  // bool get isActive => studentStatus == 2;
  bool get isActive => studentStatus == 2;

  StatusAccount  statusAccount() {
    switch (studentStatus) {
      case 0:
        return StatusAccount.NOT_ACTIVE;
      case 2:
        return StatusAccount.LEARNING;
      case 3:
        return StatusAccount.EXPIRED;
      case 4:
        return StatusAccount.RESERVED;
      default:
        return StatusAccount.RESERVED;
    }
  }
  Color getColorByStatus(StatusAccount status) {
    switch (status) {
      case StatusAccount.NOT_ACTIVE:
        return Colors.red;
      case StatusAccount.LEARNING:
        return Colors.blue;
      case StatusAccount.EXPIRED:
      case StatusAccount.RESERVED:
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }

}

