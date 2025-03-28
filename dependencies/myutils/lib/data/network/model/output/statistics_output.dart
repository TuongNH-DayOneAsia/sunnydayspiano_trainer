import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Get statistics successfully!"
/// data : {"attended":0,"late":0,"remaining":-1,"not_yet_class":3,"limit_cancel":4,"message_note":"<div style='width: 337px'><span style='color: #FF4646; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Lưu ý:<br/></span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Không được Hủy quá </span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>4 lần/tháng</span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'> và trước 2h thời gian bắt đầu của buổi học. <br/>Học viên không đến lớp (đặt lịch nhưng không đi học) không được quá 3 lần/tháng<br/></span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Nếu vi phạm, hệ thống đặt lịch trên ứng dụng sẽ bị ngưng 14 ngày<br/>Xin chân thành cảm ơn!</span></div>"}
/// errors : ["",""]

StatisticsOutput statisticsOutputFromJson(String str) => StatisticsOutput.fromJson(json.decode(str));

String statisticsOutputToJson(StatisticsOutput data) => json.encode(data.toJson());

class StatisticsOutput {
  StatisticsOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  StatisticsOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataStatistics.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  DataStatistics? data;
  List<String>? errors;

  StatisticsOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    DataStatistics? data,
    List<String>? errors,
  }) =>
      StatisticsOutput(
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

/// attended : 0
/// late : 0
/// remaining : -1
/// not_yet_class : 3
/// limit_cancel : 4
/// message_note : "<div style='width: 337px'><span style='color: #FF4646; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Lưu ý:<br/></span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Không được Hủy quá </span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>4 lần/tháng</span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'> và trước 2h thời gian bắt đầu của buổi học. <br/>Học viên không đến lớp (đặt lịch nhưng không đi học) không được quá 3 lần/tháng<br/></span><span style='color: #9B9B9B; font-size: 10px; font-family: Be Vietnam Pro; font-weight: 400; line-height: 14px; word-wrap: break-word'>Nếu vi phạm, hệ thống đặt lịch trên ứng dụng sẽ bị ngưng 14 ngày<br/>Xin chân thành cảm ơn!</span></div>"

class DataStatistics {
  DataStatistics({
    this.attended,
    this.late,
    this.remaining,
    this.notYetClass,
    this.limitCancel,
    this.messageNote,
    this.booked,
    this.numberShowContract,
    this.numberShowContractAvailable,
  });

  DataStatistics.fromJson(dynamic json) {
    attended = json['attended'] ?? 0;
    late = json['late'] ?? 0;
    remaining = json['remaining'] ?? 0;
    notYetClass = json['not_yet_class'] ?? 0;
    limitCancel = json['limit_cancel'] ?? 0;
    messageNote = json['message_note'] ?? '';
    booked = json['booked'] ?? 0;
    numberShowContract = json['number_show_contract'] ?? 0;
    numberShowContractAvailable = json['number_show_contract_available'] ?? 0;
  }

  num? attended;
  num? late;
  num? remaining;
  num? notYetClass;
  num? limitCancel;
  num? booked;
  String? messageNote;
  num? numberShowContract;
  num? numberShowContractAvailable;

  DataStatistics copyWith({
    num? attended,
    num? late,
    num? remaining,
    num? notYetClass,
    num? limitCancel,
    String? messageNote,
    num? booked,
    num? numberShowContract,
    num? numberShowContractAvailable,
  }) =>
      DataStatistics(
        attended: attended ?? this.attended,
        late: late ?? this.late,
        remaining: remaining ?? this.remaining,
        notYetClass: notYetClass ?? this.notYetClass,
        limitCancel: limitCancel ?? this.limitCancel,
        messageNote: messageNote ?? this.messageNote,
        booked: booked ?? this.booked,
        numberShowContract: numberShowContract ?? this.numberShowContract,
        numberShowContractAvailable: numberShowContractAvailable ?? this.numberShowContractAvailable,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['attended'] = attended;
    map['late'] = late;
    map['remaining'] = remaining;
    map['not_yet_class'] = notYetClass;
    map['limit_cancel'] = limitCancel;
    map['message_note'] = messageNote;
    map['booked'] = booked;
    map['number_show_contract'] = numberShowContract;
    map['number_show_contract_cancel'] = numberShowContractAvailable;
    return map;
  }
}
