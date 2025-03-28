import 'dart:convert';



BookingOutput bookingOutputFromJson(String str) => BookingOutput.fromJson(json.decode(str));
String bookingOutputToJson(BookingOutput data) => json.encode(data.toJson());
class BookingOutput {
  BookingOutput({
      this.statusCode, 
      this.status, 
      this.message, 
      this.data, 
      this.errors,});

  BookingOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataBooking.fromJson(json['data']) : null;
    if (json['errors'] != null) {
      errors = [];
      json['errors'].forEach((v) {
        errors?.add(v.toString());
      });
    }
  }
  num? statusCode;
  String? status;
  String? message;
  DataBooking? data;
  List<String>? errors;
BookingOutput copyWith({  num? statusCode,
  String? status,
  String? message,
  DataBooking? data,
  List<String>? errors,
}) => BookingOutput(  statusCode: statusCode ?? this.statusCode,
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
    if (errors != null) {
      map['errors'] = errors?.map((v) => v).toList();
    }
    return map;
  }

}
/// status_code : 200
/// status : "success"
/// message : "Booking successfully!"
/// data : {"id":1,"student_id":7,"class_lesson_id":105,"status_booking":1,"status_in_class":1,"status_note_booking":null,"status_note_in_class":null,"class_lesson_full_date":"2024-08-24","class_lesson_date":"2024-08-24","class_lesson_start_date":"2024-08-25","class_lesson_end_date":"2024-08-25","class_lesson_start_time":"22:08:00","class_lesson_end_time":"23:08:00","student_name":"Cao Minh Tường","student_phone":"0382960988","student_code":null,"student_cccd":null,"created_by_type":null,"created_by_id":null,"updated_by_type":null,"updated_by_id":7,"created_at":"2024-08-15T09:10:29.000Z","updated_at":"2024-08-15T09:10:29.000Z"}
/// errors : []

class DataBooking {
  DataBooking({
    this.bookingCode,
    this.textBookingCode,
    this.textFullTime,
    this.textBranch,
    this.fromTime,
    this.toTime,
    this.data,
    this.bookNote,});

  DataBooking.fromJson(dynamic json) {
    bookingCode = json['booking_code'];
    textBookingCode = json['text_booking_code'];
    textFullTime = json['text_full_time'];
    textBranch = json['text_branch'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
    data = json['data'];
    bookNote = json['book_note'];
  }
  String? bookingCode;
  String? textBookingCode;
  String? textFullTime;
  String? textBranch;
  String? fromTime;
  String? toTime;
  String? data;
  String? bookNote;
  DataBooking copyWith({  String? bookingCode,
    String? textBookingCode,
    String? textFullTime,
    String? textBranch,
    String? fromTime,
    String? toTime,
    String? data,
    String? bookNote

  }) => DataBooking(  bookingCode: bookingCode ?? this.bookingCode,
    textBookingCode: textBookingCode ?? this.textBookingCode,
    textFullTime: textFullTime ?? this.textFullTime,
    textBranch: textBranch ?? this.textBranch,
    fromTime: fromTime ?? this.fromTime,
    toTime: toTime ?? this.toTime,
    data: data ?? this.data,
    bookNote: bookNote ?? this.bookNote
  );
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['booking_code'] = bookingCode;
    map['text_booking_code'] = textBookingCode;
    map['text_full_time'] = textFullTime;
    map['text_branch'] = textBranch;
    map['from_time'] = fromTime;
    map['to_time'] = toTime;
    map['data'] = data;
    map['book_note'] = bookNote;
    return map;
  }

}