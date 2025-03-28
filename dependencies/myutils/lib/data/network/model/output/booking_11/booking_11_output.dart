import 'package:myutils/constants/api_constant.dart';

/// status_code : 200
/// status : "success"
/// message : "Booking successfully!"
/// data : {"booking_code":"1-1GE-17369264281","text_booking_code":"Mã đặt chỗ: 1-1GE-17369264281","text_full_time":"Thời gian: 16:00 - 17:00, 15/01/2025","branch_name":"Sunny Days Đặng Dung","text_branch":"Chi nhánh: 21 Đặng Dung, Phường Tân Định, Quận 1, Thành phố Hồ Chí Minh","book_note":""}

class Booking11Output {
  Booking11Output({
      this.statusCode,
      this.status,
      this.message,
      this.data,});

  Booking11Output.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    if(statusCode == ApiStatusCode.success){
      data = json['data'] != null ? DataBooking11.fromJson(json['data']) : null;
    }else{
      data = null;
    }

  }
  int? statusCode;
  String? status;
  String? message;
  DataBooking11? data;
Booking11Output copyWith({  int? statusCode,
  String? status,
  String? message,
  DataBooking11? data,
}) => Booking11Output(  statusCode: statusCode ?? this.statusCode,
  status: status ?? this.status,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status_code'] = statusCode;
    map['status'] = status;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

/// booking_code : "1-1GE-17369264281"
/// text_booking_code : "Mã đặt chỗ: 1-1GE-17369264281"
/// text_full_time : "Thời gian: 16:00 - 17:00, 15/01/2025"
/// branch_name : "Sunny Days Đặng Dung"
/// text_branch : "Chi nhánh: 21 Đặng Dung, Phường Tân Định, Quận 1, Thành phố Hồ Chí Minh"
/// book_note : ""

class DataBooking11 {
  DataBooking11({
      this.bookingCode,
      this.textBookingCode,
      this.textFullTime,
      this.branchName,
      this.textBranch,
      this.bookNote,});

  DataBooking11.fromJson(dynamic json) {
    bookingCode = json['booking_code'];
    textBookingCode = json['text_booking_code'];
    textFullTime = json['text_full_time'];
    branchName = json['branch_name'];
    textBranch = json['text_branch'];
    bookNote = json['book_note'];
  }
  String? bookingCode;
  String? textBookingCode;
  String? textFullTime;
  String? branchName;
  String? textBranch;
  String? bookNote;
  DataBooking11 copyWith({  String? bookingCode,
  String? textBookingCode,
  String? textFullTime,
  String? branchName,
  String? textBranch,
  String? bookNote,
}) => DataBooking11(  bookingCode: bookingCode ?? this.bookingCode,
  textBookingCode: textBookingCode ?? this.textBookingCode,
  textFullTime: textFullTime ?? this.textFullTime,
  branchName: branchName ?? this.branchName,
  textBranch: textBranch ?? this.textBranch,
  bookNote: bookNote ?? this.bookNote,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_code'] = bookingCode;
    map['text_booking_code'] = textBookingCode;
    map['text_full_time'] = textFullTime;
    map['branch_name'] = branchName;
    map['text_branch'] = textBranch;
    map['book_note'] = bookNote;
    return map;
  }

}