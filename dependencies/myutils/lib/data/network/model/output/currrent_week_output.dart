import 'dart:convert';
/// status_code : 200
/// status : "success"
/// message : "Get schedules successfully!"
/// data : [{"full_date":"2024-08-12","date":"12/08","day":"Hôm nay"},{"full_date":"2024-08-13","date":"13/08","day":"Thứ 3"},{"full_date":"2024-08-14","date":"14/08","day":"Thứ 4"},{"full_date":"2024-08-15","date":"15/08","day":"Thứ 5"},{"full_date":"2024-08-16","date":"16/08","day":"Thứ 6"},{"full_date":"2024-08-17","date":"17/08","day":"Thứ 7"},{"full_date":"2024-08-18","date":"18/08","day":"Chủ nhật"}]
/// errors : []

CurrentWeekOutput calendarOutputFromJson(String str) => CurrentWeekOutput.fromJson(json.decode(str));
String calendarOutputToJson(CurrentWeekOutput data) => json.encode(data.toJson());
class CurrentWeekOutput {
  num? statusCode;
  String? status;
  String? message;
  List<DataCalendar>? data;
  List<String>? errors;

  CurrentWeekOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  CurrentWeekOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(DataCalendar.fromJson(v));
      });
    }
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v.toString());
      });
    }
  }

  CurrentWeekOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    List<DataCalendar>? data,
    List<String>? errors,
  }) => CurrentWeekOutput(
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
      map['errors'] = errors;
    }
    return map;
  }
}

class DataCalendar {
  String? fullDate;
  String? date;
  String? day;

  DataCalendar({
    this.fullDate,
    this.date,
    this.day,
  });

  DataCalendar.fromJson(dynamic json) {
    fullDate = json['full_date'] ?? '';
    date = json['date'] ?? '';
    day = json['day'] ?? '';
  }

  DataCalendar copyWith({
    String? fullDate,
    String? date,
    String? day,
  }) => DataCalendar(
    fullDate: fullDate ?? this.fullDate,
    date: date ?? this.date,
    day: day ?? this.day,
  );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['full_date'] = fullDate;
    map['date'] = date;
    map['day'] = day;
    return map;
  }
}

DataCalendar dataFromJson(String str) => DataCalendar.fromJson(json.decode(str));
String dataToJson(DataCalendar data) => json.encode(data.toJson());

