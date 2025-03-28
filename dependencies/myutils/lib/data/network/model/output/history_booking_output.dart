import 'dart:convert';
import 'package:myutils/data/network/model/output/list_class_output.dart';
import 'package:myutils/helpers/extension/num_extension.dart';


/// status_code : 200
/// status : "success"
/// message : "Get booking histories successfully!"
/// data : {"pagination":{"totalPage":1,"perPage":10,"currentPage":1,"count":4},"rows":[{"id":4,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":1,"status_in_class":1,"status_booking_text":"Đặt lịch thành công","status_booking_color":"0xFF28A745","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":8,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":9,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room TL","class_type_name":"Lớp Class","branch_name":"SND Tên lửa","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":10,"class_lesson_start_date":"28/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 4"}]}
/// errors : ["",""]

HistoryBookingOutput historyBookingOutputFromJson(String str) => HistoryBookingOutput.fromJson(json.decode(str));

String historyBookingOutputToJson(HistoryBookingOutput data) => json.encode(data.toJson());

class HistoryBookingOutput {
  HistoryBookingOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  HistoryBookingOutput.fromJson(dynamic json) {
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

  HistoryBookingOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    Data? data,
    List<String>? errors,
  }) =>
      HistoryBookingOutput(
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
      map['data'] = data?.toJson();
    }
    map['errors'] = errors;
    return map;
  }
}

/// pagination : {"totalPage":1,"perPage":10,"currentPage":1,"count":4}
/// rows : [{"id":4,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":1,"status_in_class":1,"status_booking_text":"Đặt lịch thành công","status_booking_color":"0xFF28A745","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":8,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":9,"class_lesson_start_date":"27/08/2024","classroom_name":"Class room TL","class_type_name":"Lớp Class","branch_name":"SND Tên lửa","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 3"},{"id":10,"class_lesson_start_date":"28/08/2024","classroom_name":"Class room HVB","class_type_name":"Lớp Class","branch_name":"SND Huỳnh Văn Bánh","status_booking":0,"status_in_class":1,"status_booking_text":"Đặt lịch đã huỷ","status_booking_color":"0xFFFF4545","status_in_class_text":"Chưa đến lớp","status_in_class_color":"0xFFFF4545","coach":"Mr.Bin-Mr.Ben","day_of_week":"Thứ 4"}]

Data dataFromJson(String str) => Data.fromJson(json.decode(str));

String dataToJson(Data data) => json.encode(data.toJson());

class Data {
  Data({
    this.pagination,
    this.rows,
  });

  Data.fromJson(dynamic json) {
    pagination = json['pagination'] != null ? DataPagination.fromJson(json['pagination']) : null;
    if (json['rows'] != null) {
      rows = [];
      json['rows'].forEach((v) {
        rows?.add(DataHistoryBooking.fromJson(v));
      });
    }
  }

  DataPagination? pagination;
  List<DataHistoryBooking>? rows;

  Data copyWith({
    DataPagination? pagination,
    List<DataHistoryBooking>? rows,
  }) =>
      Data(
        pagination: pagination ?? this.pagination,
        rows: rows ?? this.rows,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    if (rows != null) {
      map['rows'] = rows?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

/// id : 4
/// class_lesson_start_date : "27/08/2024"
/// classroom_name : "Class room HVB"
/// class_type_name : "Lớp Class"
/// branch_name : "SND Huỳnh Văn Bánh"
/// status_booking : 1
/// status_in_class : 1
/// status_booking_text : "Đặt lịch thành công"
/// status_booking_color : "0xFF28A745"
/// status_in_class_text : "Chưa đến lớp"
/// status_in_class_color : "0xFFFF4545"
/// coach : "Mr.Bin-Mr.Ben"
/// day_of_week : "Thứ 3"

class DataHistoryBooking {
  DataHistoryBooking({
    this.id,
    this.classLessonStartDate,
    this.classroomName,
    this.classTypeName,
    this.branchName,
    this.statusBooking,
    this.statusInClass,
    this.statusBookingText,
    this.statusBookingColor,
    this.statusInClassText,
    this.statusInClassColor,
    this.coach,
    this.dayOfWeek,
    this.bookingCode,
    this.key,
    this.type,
    this.instrumentStartEndTime,
  });

  DataHistoryBooking.fromJson(dynamic json) {
    id = MyNum.parseNum(json['id']);
    classLessonStartDate = json['class_lesson_start_date'] ?? '';
    classroomName = json['classroom_name'] ?? '';
    classTypeName = json['class_type_name'] ?? '';
    branchName = json['branch_name'] ?? '';
    statusBooking = MyNum.parseNum(json['status_booking']);
    statusInClass = MyNum.parseNum(json['status_in_class']);
    statusBookingText = json['status_booking_text'] ?? '';
    statusBookingColor = json['status_booking_color'] ?? '';
    statusInClassText = json['status_in_class_text'] ?? '';
    statusInClassColor = json['status_in_class_color'] ?? '';
    coach = json['coach'] ?? '';
    print('coachcoach: $coach');
    dayOfWeek = json['day_of_week'] ?? '';
    bookingCode = json['booking_code'] ?? '';
    key = json['key'] ?? '';
    type = json['type'] ?? '';
    instrumentStartEndTime = json['instrument_start_end_time'] ?? '';
  }

  num? id;
  String? classLessonStartDate;
  String? classroomName;
  String? classTypeName;
  String? branchName;
  num? statusBooking;
  num? statusInClass;
  String? statusBookingText;
  String? statusBookingColor;
  String? statusInClassText;
  String? statusInClassColor;
  String? coach;
  String? dayOfWeek;
  String? bookingCode;
  String? key;
  String? type;
  String? instrumentStartEndTime;

  // copyWith method
  DataHistoryBooking copyWith({
    num? id,
    String? classLessonStartDate,
    String? classroomName,
    String? classTypeName,
    String? branchName,
    num? statusBooking,
    num? statusInClass,
    String? statusBookingText,
    String? statusBookingColor,
    String? statusInClassText,
    String? statusInClassColor,
    String? coach,
    String? dayOfWeek,
    String? bookingCode,
    String? key,
    String? instrumentStartEndTime,
  }) =>
      DataHistoryBooking(
        id: id ?? this.id,
        classLessonStartDate: classLessonStartDate ?? this.classLessonStartDate,
        classroomName: classroomName ?? this.classroomName,
        classTypeName: classTypeName ?? this.classTypeName,
        branchName: branchName ?? this.branchName,
        statusBooking: statusBooking ?? this.statusBooking,
        statusInClass: statusInClass ?? this.statusInClass,
        statusBookingText: statusBookingText ?? this.statusBookingText,
        statusBookingColor: statusBookingColor ?? this.statusBookingColor,
        statusInClassText: statusInClassText ?? this.statusInClassText,
        statusInClassColor: statusInClassColor ?? this.statusInClassColor,
        coach: coach ?? this.coach,
        dayOfWeek: dayOfWeek ?? this.dayOfWeek,
        bookingCode: bookingCode ?? this.bookingCode,
        key: key ?? this.key,
        instrumentStartEndTime: instrumentStartEndTime ?? this.instrumentStartEndTime,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['class_lesson_start_date'] = classLessonStartDate;
    map['classroom_name'] = classroomName;
    map['class_type_name'] = classTypeName;
    map['branch_name'] = branchName;
    map['status_booking'] = statusBooking;
    map['status_in_class'] = statusInClass;
    map['status_booking_text'] = statusBookingText;
    map['status_booking_color'] = statusBookingColor;
    map['status_in_class_text'] = statusInClassText;
    map['status_in_class_color'] = statusInClassColor;
    map['coach'] = coach;
    map['booking_code'] = bookingCode;
    map['day_of_week'] = dayOfWeek;
    map['key'] = key;
    map['type'] = type;
    return map;
  }
}

/// totalPage : 1
/// perPage : 10
/// currentPage : 1
/// count : 4



class DataHistoryMain {
  String? header;
  final List<DataHistoryBooking>? listSub;

  DataHistoryMain({
    this.header,
    this.listSub,
  });

  //copyWith method
  DataHistoryMain copyWith({
    String? header,
    List<DataHistoryBooking>? listSub,
  }) {
    return DataHistoryMain(
      header: header ?? this.header,
      listSub: listSub ?? this.listSub,
    );
  }
}
