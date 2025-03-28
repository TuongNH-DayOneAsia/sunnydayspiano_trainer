import 'dart:convert';

/// status_code : 200
/// status : "success"
/// message : "Get detail booking practice successfully!"
/// data : {"clas_type_name":"Lớp tập luyện đàn","booking_code":"PR-17266462877","classroom":"Practice Room HVB","practice_time":"10:00-11:30","instrument_start_date":"18/09/2024","branch_name":"270 Huỳnh Văn Bánh, Phường 11, Quận Phú Nhuận, Thành phố Hồ Chí Minh","instrument_duration":"90 phút","instrument_code":"HVB_Đàn3","created_at":"14:58 18/09/2024","book_note":"","is_cancel":true}
/// errors : ["",""]

BookingDetailPracticeOutput roomDetailOutputFromJson(String str) => BookingDetailPracticeOutput.fromJson(json.decode(str));

String roomDetailOutputToJson(BookingDetailPracticeOutput data) => json.encode(data.toJson());

class BookingDetailPracticeOutput {
  BookingDetailPracticeOutput({
    this.statusCode,
    this.status,
    this.message,
    this.data,
    this.errors,
  });

  BookingDetailPracticeOutput.fromJson(dynamic json) {
    statusCode = json['status_code'];
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? DataDetailPractice.fromJson(json['data']) : null;
    errors = json['errors'] != null ? json['errors'].cast<String>() : [];
  }

  num? statusCode;
  String? status;
  String? message;
  DataDetailPractice? data;
  List<String>? errors;

  BookingDetailPracticeOutput copyWith({
    num? statusCode,
    String? status,
    String? message,
    DataDetailPractice? data,
    List<String>? errors,
  }) =>
      BookingDetailPracticeOutput(
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

/// clas_type_name : "Lớp tập luyện đàn"
/// booking_code : "PR-17266462877"
/// classroom : "Practice Room HVB"
/// practice_time : "10:00-11:30"
/// instrument_start_date : "18/09/2024"
/// branch_name : "270 Huỳnh Văn Bánh, Phường 11, Quận Phú Nhuận, Thành phố Hồ Chí Minh"
/// instrument_duration : "90 phút"
/// instrument_code : "HVB_Đàn3"
/// created_at : "14:58 18/09/2024"
/// book_note : ""
/// is_cancel : true

class DataDetailPractice {
  DataDetailPractice({
    this.classTypeName,
    this.bookingCode,
    this.classroom,
    this.practiceTime,
    this.instrumentStartDate,
    this.branchName,
    this.instrumentDuration,
    this.instrumentCode,
    this.createdAt,
    this.bookNote,
    this.isCancel,
    this.statusBooking,
    this.statusInClass,
    this.statusBookingText,
    this.statusBookingColor,
    this.statusInClassText,
    this.statusInClassColor,
    this.cancelDate,
    this.productName
  });

  DataDetailPractice.fromJson(dynamic json) {
    classTypeName = json['class_type_name'] ?? '';
    bookingCode = json['booking_code'] ?? '';
    classroom = json['classroom'] ?? '';
    practiceTime = json['practice_time'] ?? '';
    instrumentStartDate = json['instrument_start_date'] ?? '';
    branchName = json['branch_name'] ?? '';
    instrumentDuration = json['instrument_duration'] ?? '';
    instrumentCode = json['instrument_code'] ?? '';
    createdAt = json['created_at'] ?? '';
    bookNote = json['book_note'] ?? '';
    statusBooking = json['status_booking'] ?? 0;
    statusInClass = json['status_in_class'] ?? 0;
    statusBookingText = json['status_booking_text'] ?? '';
    statusBookingColor = json['status_booking_color'] ?? '';
    statusInClassText = json['status_in_class_text'] ?? '';
    statusInClassColor = json['status_in_class_color'] ?? '';
    isCancel = json['is_cancel'] ?? false;
    cancelDate = json['cancel_date'] ?? '';

    instrumentStartDatetime = json['instrument_start_datetime'] ?? '';
    productName = json['product_name'] ?? '';

  }

  String? classTypeName;
  String? bookingCode;
  String? classroom;
  String? practiceTime;
  String? instrumentStartDate;
  String? branchName;
  String? instrumentDuration;
  String? instrumentCode;
  String? createdAt;
  String? bookNote;

  num? statusBooking;
  num? statusInClass;
  String? statusBookingText;
  String? statusBookingColor;
  String? statusInClassText;
  String? statusInClassColor;
  String? productName;

  bool? isCancel;
  String? cancelDate;
  //    "instrument_start_datetime": "2024-09-28 15:50:00",
  String? instrumentStartDatetime;

  DataDetailPractice copyWith({
    String? clasTypeName,
    String? bookingCode,
    String? classroom,
    String? practiceTime,
    String? instrumentStartDate,
    String? branchName,
    String? instrumentDuration,
    String? instrumentCode,
    String? createdAt,
    String? bookNote,
    num? statusBooking,
    num? statusInClass,
    String? statusBookingText,
    String? statusBookingColor,
    String? statusInClassText,
    String? statusInClassColor,
    bool? isCancel,
    String? cancelDate,
    String? productName,
  }) =>
      DataDetailPractice(
        classTypeName: clasTypeName ?? this.classTypeName,
        bookingCode: bookingCode ?? this.bookingCode,
        classroom: classroom ?? this.classroom,
        practiceTime: practiceTime ?? this.practiceTime,
        instrumentStartDate: instrumentStartDate ?? this.instrumentStartDate,
        branchName: branchName ?? this.branchName,
        instrumentDuration: instrumentDuration ?? this.instrumentDuration,
        instrumentCode: instrumentCode ?? this.instrumentCode,
        createdAt: createdAt ?? this.createdAt,
        bookNote: bookNote ?? this.bookNote,
        statusBooking: statusBooking ?? this.statusBooking,
        statusInClass: statusInClass ?? this.statusInClass,
        statusBookingText: statusBookingText ?? this.statusBookingText,
        statusBookingColor: statusBookingColor ?? this.statusBookingColor,
        statusInClassText: statusInClassText ?? this.statusInClassText,
        statusInClassColor: statusInClassColor ?? this.statusInClassColor,
        isCancel: isCancel ?? this.isCancel,
        cancelDate: cancelDate ?? this.cancelDate,
        productName: productName ?? this.productName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['clas_type_name'] = classTypeName;
    map['booking_code'] = bookingCode;
    map['classroom'] = classroom;
    map['practice_time'] = practiceTime;
    map['instrument_start_date'] = instrumentStartDate;
    map['branch_name'] = branchName;
    map['instrument_duration'] = instrumentDuration;
    map['instrument_code'] = instrumentCode;
    map['created_at'] = createdAt;
    map['book_note'] = bookNote;
    map['status_booking'] = statusBooking;
    map['status_in_class'] = statusInClass;
    map['status_booking_text'] = statusBookingText;
    map['status_booking_color'] = statusBookingColor;
    map['status_in_class_text'] = statusInClassText;
    map['status_in_class_color'] = statusInClassColor;
    map['product_name'] = productName;

    map['is_cancel'] = isCancel;
    map['cancel_date'] = cancelDate;
    return map;
  }
}
