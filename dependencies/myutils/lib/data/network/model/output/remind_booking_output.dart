import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Get booking successfully!"
/// data : {"booking_code":"CL-172561330335","class_type":"Đặt lịch Lớp Class","class_lesson_start_date":"Thời gian: 06/09/2024","branch_name":"Sunny Days Sunny Days Huỳnh Văn Bánh"}
/// errors : ["",""]

RemindBookingOutput remindBookingOutputFromJson(String str) => RemindBookingOutput.fromJson(json.decode(str));

String remindBookingOutputToJson(RemindBookingOutput data) => json.encode(data.toJson());

class RemindBookingOutput {
  RemindBookingOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  RemindBookingOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? List<DataRemindBooking>.from(json['data'].map((v) => DataRemindBooking.fromJson(v))) : [];
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  List<DataRemindBooking>? data;
  List<String>? errors;

  RemindBookingOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    List<DataRemindBooking>? data,
    List<String>? errors,
  }) =>
      RemindBookingOutput(
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

/// booking_code : "CL-172561330335"
/// class_type : "Đặt lịch Lớp Class"
/// class_lesson_start_date : "Thời gian: 06/09/2024"
/// branch_name : "Sunny Days Sunny Days Huỳnh Văn Bánh"

class DataRemindBooking {
  DataRemindBooking({
    this.bookingCode,
    this.classType,
    this.classLessonStartDate,
    this.branchName,
    this.type,
  });

  DataRemindBooking.fromJson(dynamic json) {
    bookingCode = json['booking_code'] ?? '';
    classType = json['class_type'] ?? '';
    classLessonStartDate = json['start_date'] ?? '';
    branchName = json['branch_name'] ?? '';
    type = json['type'] ?? '';
    date = json['date'] ?? '';
    time = json['time'] ?? '';
  }

  String? bookingCode;
  String? classType;
  String? classLessonStartDate;
  String? branchName;
  String? type;
  String? date;
  String? time;

  DataRemindBooking copyWith({
    String? bookingCode,
    String? classType,
    String? classLessonStartDate,
    String? branchName,
    String? type,
  }) =>
      DataRemindBooking(
        bookingCode: bookingCode ?? this.bookingCode,
        classType: classType ?? this.classType,
        classLessonStartDate: classLessonStartDate ?? this.classLessonStartDate,
        branchName: branchName ?? this.branchName,
        type: type ?? this.type,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_code'] = bookingCode;
    map['class_type'] = classType;
    map['class_lesson_start_date'] = classLessonStartDate;
    map['branch_name'] = branchName;
    map['type'] = type;
    return map;
  }
}
